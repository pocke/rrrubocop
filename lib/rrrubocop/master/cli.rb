module RRRuboCop
  class Master
    class CLI
      # @param arguments [Array<String>] command line arguments
      def initialize(arguments)
        # TODO: Parse arguments

        # TODO: get path list by RuboCop's method
        paths = Dir['**/*.rb']
      end
    end
  end
end
