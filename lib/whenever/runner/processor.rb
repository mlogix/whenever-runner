module Whenever
  module Runner
    class Processor
      def self.call(cmd)
        begin
          Runner.logger.info "[#{Time.now.utc}] Proceed job: \n#{cmd}\n"

          Kernel.system("#{cmd} &")

          Runner.logger.info "\n -" * 80
        rescue StandardError => e
          Runner.logger.error(e)
        end
      end
    end
  end
end
