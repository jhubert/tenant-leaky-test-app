Apartment::Tenant.switch!('first')
FirstJob.perform_later
# make sure the jobs have time to run
sleep 3
