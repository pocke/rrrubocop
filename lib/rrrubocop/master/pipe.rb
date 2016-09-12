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

      # XXX: Error handling when queue is empty
      # @return [Response]
      def deq_response
        @resp_queue.deq
      end

      # @param resp [Response]
      def enq_response(resp)
        @resp_queue.push resp
        @latch.count_down
      end

      def wait_enqueueing
        @latch.wait
      end
    end
  end
end
