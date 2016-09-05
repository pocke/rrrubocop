require 'socket'
require 'json'

module RRRuboCop
  class Client
    EndOfFiles = Class.new(StandardError)

    # @param args [Array<String>] command line arguments
    def initialize(args)
      # FIXME
      @port = args[1].to_i
      @host = "127.0.0.1"
    end

    def run
      loop do
        args = fetch_cli_args
        cli = RuboCop::CLI.new
        cli.run(args)
      end
    rescue EndOfFiles
      # Analysing finish.
      exit 0
    end


    private

    def fetch_cli_args
      resp = fetch
      resp['arguments']
    end

    def fetch
      # https://github.com/pocke/rrrubocop/issues/1
      s = TCPSocket.open(@host, @port)
      raw_data = s.gets
      data = JSON.parse(raw_data)
      raise EndOfFiles, data['error'] if data['error']
      return data
    ensure
      s.close
    end
  end
end

