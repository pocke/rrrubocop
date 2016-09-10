require 'socket'
require 'json'

module RRRuboCop
  module Worker
    EndOfFiles = Class.new(StandardError)
  end
end

require 'rrrubocop/worker/cli'
require 'rrrubocop/worker/runner'
require 'rrrubocop/worker/formatter'
