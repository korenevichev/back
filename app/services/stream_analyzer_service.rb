# frozen_string_literal: true

require 'mock/mock_stream_service'
require 'frame_storage_service'

class StreamAnalyzerService
  include FaceSDK
  attr_reader :frame_storage_service

  def initialize(stream_url)
    @stream_url = stream_url
    @video_capture = VideoCapture.new(@stream_url)
    @frame_storage_service = FrameStorageService.new
    @image_analyzer_service = ImageAnalyzerService.new
    @compare_params = FaceSDK::default_comparison_params
    @n = 0
  end

  def read_frame
    return unless @video_capture.opened

    @video_capture.read_frame
  end

  def video_stream_running?
    @video_capture.opened
  end

  def store_frames
    while video_stream_running?
      puts 'thread 2'
      frame_storage_service.store(read_frame)
      sleep 1
    end
  end

  def start_frames_analyzing(descriptors)
    @n = @n + 1
    puts 'thread 1'
    next_frame = frame_storage_service.next_frame
    #if next_frame.present?
      #frames = @image_analyzer_service.frames(blob: next_frame)
       frames = @image_analyzer_service.frames(path: '/Users/lizavetakarenevich/Downloads/5.png')
       frames = @image_analyzer_service.frames(path: '/Users/lizavetakarenevich/Downloads/6.jpg') if @n%2 == 0
      frames.each do |frame|
        descriptors.each do |descriptor|
          person_is_found = FaceSDK::compare_faces_by_descriptor(frame['Descriptor'], descriptor.descriptor_values)
            puts 'comparison ' + person_is_found.to_s
            puts 'face is found'  if person_is_found > @compare_params[:threshold99]
            puts 'face not found' if person_is_found < @compare_params[:threshold99]
        end
      end
    #end

  end
end
