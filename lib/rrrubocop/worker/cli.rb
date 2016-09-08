module RRRuboCop
  module Worker
    class CLI
      # @param arguments [Array<String>] command line arguments
      def initialize(arguments)
        # TODO: Parse arguments
        @port = arguments[1].to_i # FIXME
        @host = "127.0.0.1"  # FIXME
      end

      def work_loop
        loop do
          Runner.new(@port, @host).run
        end
      rescue RRRuboCop::Worker::EndOfFiles
      end
    end
  end
end
