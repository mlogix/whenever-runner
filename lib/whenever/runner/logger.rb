module Whenever
  module Runner
    class Logger
      def error(args)
        puts args
        puts "\n"
      end

      def info(args)
        puts args
        puts "\n"
      end
    end

    def logger
      @logger ||= Logger.new
    end
    module_function :logger
  end
end
