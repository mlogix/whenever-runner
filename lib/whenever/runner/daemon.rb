require "whenever"
require "fugit"
require "digest"
require "whenever/runner/processor"

module Whenever
  module Runner
    class Daemon
      DELAY = 1

      def self.call(options)
        jobs = read_prepared_jobs!(options)

        Runner.logger.info("----------------------------------------------------------------------------")
        Runner.logger.info "Parsed #{jobs.length} job(s)"
        Runner.logger.info("----------------------------------------------------------------------------")

        jobs.each do |expr, cmds|
          cmds.each do |cmd|
            Runner.logger.info "#{expr} #{cmd}\n"
          end
        end
        Runner.logger.info("----------------------------------------------------------------------------")

        proceed_jobs!(jobs, options)
      end

      private

      def self.read_prepared_jobs!(options)
        planned_job_list = Whenever::JobList.new(file: options[:file])
        planned_jobs = planned_job_list.instance_variable_get("@jobs")
        return if planned_jobs.empty?

        tasks = planned_jobs.delete(:default_mailto)
        tasks.each do |times, jobs|
          jobs.each do |job|
            Whenever::Output::Cron.enumerate(times).each do |time|
              Whenever::Output::Cron.enumerate(job.at, false).each do |at|
                cron_task = Whenever::Output::Cron.new(time, job.output, at, options)

                Whenever::Runner.current_tasks[cron_task.time_in_cron_syntax] ||= []
                Whenever::Runner.current_tasks[cron_task.time_in_cron_syntax] << job.output
              end
            end
          end
        end

        Whenever::Runner.current_tasks
      end

      def self.proceed_jobs!(jobs, options)
        loop do
          jobs.each do |expr, cmds|
            cron = Fugit.parse(expr)
            processing_time = ::EtOrbi::EoTime.new(Time.now.utc, options[:timezone] || "UTC")
            next_time = cron.next_time(processing_time - DELAY)

            if next_time <= processing_time
              cmds.each do |cmd|
                sha = Digest::SHA2.hexdigest([next_time, expr, cmd].map(&:to_s).join(""))
                next unless Whenever::Runner.executed_tasks[sha].nil?

                Runner.logger.info("Proceed: [Time: #{processing_time} | command: #{cmd}]")
                Whenever::Runner.executed_tasks[sha] = processing_time
                Thread.new do
                  Processor.call(cmd)
                end
              end
            end
          end

          sleep DELAY
        end
      end
    end
  end
end
