# README

This demonstrates the weird behavior we're seeing when we include a gem that
has an `after: :load_config_initializers` initializer.

We originally started investigating it after the flipper gem caused a notable
spike in database connections. We were able to isolate it down to the use of
that initializer load order and determined that it isn't related to flipper
specifically.

So, we created a sample gem called dbgemtest that just prints it's name in an
initializer. That's all it does.

Using that, we were able to isolate the problem to a combination of apartment,
sidekiq, and activejob. We demonstrate it by showing the loss of tenant
information because connection leaks are hard to reliably recreate.

The issue doesn't happen when using sidekiq. It only happens with sidekiqswarm.

### SETUP

To set it up the first time, run bin/setup. This will install the gems, create
the database and seed it with two tenants.

### Running the examples

To see the code working, run the following command:

```bash
bin/dev
```

This will start up redis, sidekiqswarm, and then enque two jobs.

Each job should output a WARN log entry showing the tenant it is being run
from. Both jobs should be on the same tenant and you should see the following
log output:

```
worker | TIMESTAMP pid=PID tid=TID class=FirstJob jid=JID WARN: FirstJob - Tenant: first
worker | TIMESTAMP pid=PID tid=TID class=SecondJob jid=JID WARN: SecondJob - Tenant: first
```

To see the code breaking, run:

```bash
BROKEN=true bin/dev
```

This will do the same thing. The only difference is that the dbgemtest railtie
is included if BROKEN is true. You should see this log output if it is broken:

```
worker | TIMESTAMP pid=PID tid=TID class=FirstJob jid=JID WARN: FirstJob - Tenant: first
worker | TIMESTAMP pid=PID tid=TID WARN: SecondJob - Tenant: public
```

Tip: If you want to simplify the output, add ` | grep WARN` to the commands.

### Additional thoughts

ros-apartment-sideqkiq adds middleware in an initializer. When sidekiqswarm
creates new instances it has some initializer logic that runs and may be missing
the ros-apartment-sidekiq middleware. We're investigating that.

We can also ensure that ActiveJob uses the right tenant by adding the following:

```ruby
module Zipline::ActiveJobWithTenant
  extend ActiveSupport::Concern

  class_methods do
    def execute(job_data)
      Apartment::Tenant.switch(job_data['tenant']) do
        super
      end
    end
  end

  def serialize
    super.merge('tenant' => Apartment::Tenant.current)
  end
end

ActiveJob::Base.include(Zipline::ActiveJobWithTenant)
```

But, we don't understand why we *don't* need to do that in the woking case.
