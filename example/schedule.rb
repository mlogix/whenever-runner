# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#

# usage script_with_lock 'script_name', lock: 'lock_name'
job_type :custom_script, "cd :path && :environment_variable=:environment ./custom_script :task :output"

every 2.minutes do
  custom_script "task:every-two-minutes"
end

every 17.minutes do
  custom_script "task:every-seventeen-minutes"
end

every 2.hours do
  custom_script "task:every-two-hours"
end

every 12.hours do
  custom_script "task:every-twelve-hours"
end

every :day do
  custom_script "task:every-single-day"
end


every :day, :at => '1:00 am' do
  custom_script "task:every-single-day-at-1am"
end
