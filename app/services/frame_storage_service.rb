class FrameStorageService
  attr_reader :limit

  def initialize(limit = 1)
    @limit = limit
  end

  def fetch
    data = []
    frame_keys.slice(0, limit).each { |key| data << redis.get(key) }
    data
  end

  private

  def redis
    @redis ||= Redis.new(host: 'redis')
  end

  def frame_keys
    redis.keys.sort_by { |file_name| -file_name[/^\d+/].to_i }
  end
end
