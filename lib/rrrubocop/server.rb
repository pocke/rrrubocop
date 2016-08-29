module RRRuboCop
  class Server
    def run
      # TODO: spawn with current ruby path
      pid = Process.spawn(client_path)
      Process.wait(pid)
    end


    private

    def client_path
      File.join(RRRuboCop::RootDir, 'exe', 'rrrubocop-client')
    end
  end
end
