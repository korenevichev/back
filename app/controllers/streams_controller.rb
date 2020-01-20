require 'socket'
require 'uri'
require 'em-websocket'
require 'json'
require 'mock/mock_stream_service'

class StreamsController < ApplicationController
  include ActionController::Live
  PER_PAGE = 10

  def index
    stream_url = 'rtsp://admin:1qaz!QAZ@192.168.112.42:554/ch1/main'
    stream_analyzer_service = StreamAnalyzerService.new(stream_url)
    image_analyzer_service = ImageAnalyzerService.new

    videoCapture = FaceSDK::VideoCapture.new(stream_url)

    blob = videoCapture.read_frame


    # frames = image_analyzer_service.frames(blob)
    # fr1 = image_analyzer_service.frames(path: '/Users/lizavetakarenevich/Downloads/6.jpg')
    # fr2 = image_analyzer_service.frames(path: '/Users/lizavetakarenevich/Downloads/7.jpg')
    # d1 = fr1.first['Descriptor']
    # d2 = fr2.first['Descriptor']
    # binding.pry
    #FaceSDK::CompareFacesByDescriptor(d1, d2, FaceSDK::GetDefaultComparisonParameters())
    # descriptor1 = Descriptor.first.descriptor_values
    # descriptor2 = Descriptor.last.descriptor_values
    # FaceSDK::CompareFacesByDescriptor(descriptor2, descriptor2, FaceSDK::GetDefaultComparisonParameters())

    descriptors = Descriptor.all
    #

    # Thread.new do
    #   loop do
    #     EM.run {
    #       EM::WebSocket.start(:host => "127.0.0.1", :port => 8080) do |ws|
    #         ws.onopen {
    #           EM.add_periodic_timer(1) {
    #             ws.send 'hello'
    #             # response_frame = stream_analyzer_service.start_frames_analyzing(descriptors)
    #             # response_frame[:image] = Base64.encode64(response_frame[:image])
    #             # ws.send data.to_json
    #           }
    #         }
    #       end
    #     }
    #     sleep 1
    #   end
    # end

    trap("INT") do
      t.exit
      exit
    end

    # Thread.new do
    #   stream_analyzer_service.store_frames
    # end
  end

  def identify
    response.headers['Content-Type'] = 'text/event-stream'
    response.headers['Access-Control-Allow-Origin'] = '*'
    stream_url = 'rtsp://admin:1qaz!QAZ@192.168.112.42:554/ch1/main'
    stream_analyzer_service = StreamAnalyzerService.new(stream_url)
    descriptors = Descriptor.all

    stream_analyzer_service.store_frames

    response_frame = stream_analyzer_service.start_frames_analyzing(descriptors)
    puts
    i = Base64.encode64(response_frame[:image])

    sse = SSE.new(response.stream, retry: 300)
    sse.write({ employees: response_frame[:employees], image: i })
  ensure
    sse.close
  end
end
