class Formatter < RuboCop::Formatter::BaseFormatter
  class << self
    attr_reader :buffer

    def reset_buffer
      @buffer = {
        started: nil,
        file_started: [],
        file_finished: [],
        finished: nil,
      }
    end
  end

  def initialize(_output, _options = {})
    super
    self.class.reset_buffer
  end

  def started(*args)
    self.class.buffer[:started] = args
  end

  def file_started(*args)
    self.class.buffer[:file_started].push args
  end

  def file_finished(*args)
    self.class.buffer[:file_finished].push args
  end

  def finished(*args)
    self.class.buffer[:finished] = args
  end
end
