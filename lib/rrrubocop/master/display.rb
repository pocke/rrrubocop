module RRRuboCop
  module Master
    class Display
      # @param pipe [RRRuboCop::Master::Pipe]
      # @param out [IO]
      def initialize(pipe, out)
        @pipe = pipe
        @formatter = RuboCop::Formatter::ProgressFormatter.new(out)
        watch_resp
      end

      def wait
        @pipe.wait_enqueueing
      end


      private

      def watch_resp
        Thread.new do
          @formatter.started([]) # XXX: it's dummy data
          loop do
            begin
            resp = @pipe.deq_response
            break unless resp

            resp.body['file_started'].each.with_index do |file_started, idx|
              @formatter.file_started(*file_started)
              file_finished = resp.body['file_finished'][idx]
              @formatter.file_finished(*file_finished)
            end

            rescue => ex
              p ex
              p ex.backtrace
              raise ex
            end
          end
          # TODO: send sum of resp data
          @formatter.finished([])
        end
      end
    end
  end
end
