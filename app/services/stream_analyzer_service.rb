# frozen_string_literal: true

require 'mock/mock_stream_service'
require 'frame_storage_service'

class StreamAnalyzerService
  attr_reader :frame_storage_service

  def initialize(stream_url)
    @stream_url = stream_url
    @video_capture = FaceSDK::VideoCapture.new(@stream_url)
    @frame_storage_service = FrameStorageService.new
  end

  def read_frame
    return unless @video_capture.IsOpened()
    @video_capture.ReadFrame()
  end

  def video_stream_running?
    @video_capture.IsOpened()
  end

  def store_frames
    while video_stream_running? do
      puts 'thread 2'
      frame_storage_service.store(read_frame)
      sleep 1
    end
  end
end
