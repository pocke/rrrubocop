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
        raise RRRuboCop::Worker::EndOfFiles unless raw_data # when server is closed
        args = JSON.parse(raw_data) + ['--format', 'RRRuboCop::Worker::Formatter']

        cli = RuboCop::CLI.new
        cli.run(args)
        s.puts JSON.generate(Formatter.buffer)
      rescue RRRuboCop::Worker::EndOfFiles
        raise
      rescue => ex
        p ex
        raise
      ensure
        s.close if s
      end
    end
  end
end
