require 'thread'
require 'json'
require 'socket'
require 'rbconfig'

module RRRuboCop
  class Server

    Request = Struct.new("Request", :id, :body)

    # @param paths [Array<String>] target file paths
    def run(paths)
      port = start_server(req_ch, resp_ch)
      start_workers(port)
      resp.ch.wait
    end


    private

    def client_path
      File.join(RRRuboCop::RootDir, 'exe', 'rrrubocop-client')
    end


    # @param req_ch [Thread::Queue<RRRuboCop::Server::Request>]
    # @param resp_ch [Thread::Queue<RRRuboCop::Server::Response>]
    # @return [Integer] TCP port number
    def start_server(req_ch, resp_ch)
      server = TCPServer.new(0)

      Thread.new do
        loop do
          client = server.accept
          req = req_ch.pop
          break unless req # queue is closed

          client.puts JSON.parse(req.body)
          client.flush
          resp_raw = JSON.parse(client.read)
          resp = Response.new(resp_raw)
          resp.id = req.id
          resp_ch.push resp
          client.close
        end
      end

      return server.addr[1]
    end

    # @param port [Integer] TCP Port number of RRRuboCop server
    def start_workers(port)
      # FIXME
      nproc = `nproc`.to_i
      nproc.times do
        Process.spawn(RbConfig.ruby, client_path, '--port', port.to_s)
      end
    end
  end
end
