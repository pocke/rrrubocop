require 'socket'
require 'json'

module RRRuboCop
  module Worker
    class Runner
      # @param port [Integer] TCP port number
      # @param host [String] host name
      def initialize(port, host)
        # https://github.com/pocke/rrrubocop/issues/1
        @port = port
        @host = host
      end

      def run
        s = TCPSocket.open(@host, @port)
        raw_data = s.gets
        args = JSON.parse(raw_data)

        cli = RuboCop::CLI.new
        # TODO: get result
        cli.run(args)
        s.puts JSON.generate([])
      ensure
        s.close if s
      end
    end
  end
end
