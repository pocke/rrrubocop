require 'thread'
require 'json'
require 'socket'
require 'rbconfig'

require 'concurrent'
require 'concurrent/atomic/count_down_latch'

module RRRuboCop
  module Master
  end
end

require 'rrrubocop/master/pipe'
require 'rrrubocop/master/cli'
require 'rrrubocop/master/display'
