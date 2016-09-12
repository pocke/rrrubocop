module RRRuboCop
  module Master
    class Pipe
      # @param requests [Array<RRRuboCop::Master::Request>]
      def initialize(requests)
        @req_queue = Thread::Queue.new
        @resp_queue = Thread::Queue.new

        requests.each do |req|
          @req_queue.push req
        end

        @latch = Concurrent::CountDownLatch.new(requests.size)
      end

      # @return [Request]
      def deq_request
        @req_queue.deq(true)
      end

      # @return [Response]
      def deq_response
        p 'dequeueing'
        @resp_queue.deq
      ensure
        @latch.count_down
      end

      # @param resp [Response]
      def enq_response(resp)
        p 'enqueueing'
        @resp_queue.push resp
      end

      def wait_enqueueing
        @latch.wait
        @resp_queue.close
      end
    end
  end
end
