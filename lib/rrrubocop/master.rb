require 'thread'
require 'json'
require 'socket'
require 'rbconfig'

require 'rrrubocop/master/pipe'

module RRRuboCop
  class Master

    Request = Struct.new("Request", :id, :body)

    # @param paths [Array<String>] analyse target path
    def run(paths)
      pipe = Pipe.new(paths)

      port = start_server(pipe)
      start_workers(port)
      resp.ch.wait
    end


    private

    def client_path
      File.join(RRRuboCop::RootDir, 'exe', 'rrrubocop-client')
    end


    # TODO: split as a new class
    # @param pipe [Pipe] pipe for request and response
    # @return [Integer] TCP port number
    def start_server(pipe)
      server = TCPServer.new(0)

      Thread.new do
        loop do
          Thread.new(server.accept) do |client|
            req = pipe.deq_request
            break unless req # queue is closed # XXX: is it ok?

            client.puts JSON.parse(req.body)
            client.flush
            resp_raw = JSON.parse(client.read)
            resp = Response.new(resp_raw)
            resp.id = req.id
            # XXX: when crash, should enqueue an error?
            resp_ch.enq_response resp
            client.close
          end
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
