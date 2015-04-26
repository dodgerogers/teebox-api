# Options
Delayed::Worker.destroy_failed_jobs = true
Delayed::Worker.sleep_delay = 2
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 1.hour
#Delayed::Worker.logger = Rails.logger
#Delayed::Worker.logger.auto_flushing = 1
Delayed::Worker.delay_jobs = !Rails.env.test?