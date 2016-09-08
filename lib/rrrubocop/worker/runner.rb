require 'socket'
require 'json'

module RRRuboCop
  module Worker
    class Runner
      # @param port [Integer] TCP port number
      # @param host [String] host name
      def initialize(port, host)
        @port = port
        @host = host
      end

      def run
        args = fetch
        cli = RuboCop::CLI.new
        cli.run(args)
      end

      private

      def fetch
        # https://github.com/pocke/rrrubocop/issues/1
        s = TCPSocket.open(@host, @port)
        raw_data = s.gets
        data = JSON.parse(raw_data)
        return data
      ensure
        s.close
      end
    end
  end
end
