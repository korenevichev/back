# Descriptor
class FrameStorageService
  def initialize
    @frames = []
    @mutex = Mutex.new
  end

  def store(frame)
    @mutex.lock
    @frames << frame
    @mutex.unlock
  end

  def next_frame
    @mutex.lock
    element = @frames.shift
    @mutex.unlock
    element
  end
end
