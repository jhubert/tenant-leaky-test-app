# README

This demonstrates the weird behavior we're seeing when we include a gem that
has an `after: :load_config_initializers` initializer.


### SETUP

To set it up the first time, run bin/setup


### Running the examples

To see the code working, run the following command:

bin/dev

This will start up redis, sidekiqswarm, and then enque two jobs.

Each job should output a WARN log entry showing the tenant it is being run
from. Both jobs should be on the same tenant and you should see the following
log output:

```
worker | TIMESTAMP pid=PID tid=TID class=FirstJob jid=JID WARN: FirstJob - Tenant: first
worker | TIMESTAMP pid=PID tid=TID class=SecondJob jid=JID WARN: SecondJob - Tenant: first
```

To see the code breaking, run:

BROKEN=true bin/dev

This will do the same thing. The only difference is that the dbgemtest railtie
is included if BROKEN is true. You should see this log output if it is broken:

```
worker | TIMESTAMP pid=PID tid=TID class=FirstJob jid=JID WARN: FirstJob - Tenant: first
worker | TIMESTAMP pid=PID tid=TID WARN: SecondJob - Tenant: public
```

Tip: If you want to simplify the output, add ` | grep WARN` to the commands.
