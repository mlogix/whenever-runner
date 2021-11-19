require "optparse"
require "whenever/runner/version"
require "whenever/runner/logger"
require "whenever/runner/daemon"
require "daemons"

module Whenever
  module Runner
    class Error < StandardError; end

    def self.current_tasks
      Thread.current[:current_tasks] ||= {}
    end

    def self.executed_tasks
      Thread.current[:executed_tasks] ||= {}
    end

    def self.call(options)
      puts "Set full path to schedule.rb file\n\n" unless options.dig(:file).to_s.length > 0

      Thread.new { Daemon.call(options) }.join
    end
  end
end

options = {}
OptionParser.new do |opts|
  opts.on("-f", "--file [schedule file]", "Full path to schedule.rb file") do |schedule_file|
    options[:file] = schedule_file if schedule_file
  end

  opts.on("--timezone [timezone]", "Set timezone. Default: UTC") do |timezone|
    options[:timezone] = timezone if timezone
  end

  opts.on("--daemonize", "Daemonize runner") do |daemonize|
    options[:daemonize] = daemonize if daemonize
  end

  opts.on("-v", "--version") do
    puts "Whenever Runner v#{Whenever::Runner::VERSION}"
    exit(0)
  end
end.parse!

daemon_options = {
  backtrace: true,
  ontop: true,
  log_output: true,
  mode: :proc,
  script: "whenever-runner",
  app_name: "whenever-runner"
}

Daemons.daemonize(daemon_options) if options[:daemonize]

Whenever::Runner.call(options)
