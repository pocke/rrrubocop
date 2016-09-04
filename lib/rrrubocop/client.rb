module RRRuboCop
  class Client
    EndOfFiles = Class.new(StandardError)

    def run
      loop do
        args = fetch_cli_args
        cli = RuboCop::CLI.new
        cli.run(args)
      end
    rescue EndOfFiles
      # Analysing finish.
    end


    private

    def fetch_cli_args
    end
  end
end

