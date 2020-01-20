require 'socket'
require 'uri'
require 'em-websocket'
require 'json'
require 'mock/mock_stream_service'

class StreamsController < ApplicationController
  include ActionController::Live

  def identify
    response.headers['Content-Type'] = 'text/event-stream'
    response.headers['Access-Control-Allow-Origin'] = '*'
    stream_url = 'rtsp://admin:1qaz!QAZ@192.168.112.42:554/ch1/main'
    stream_analyzer_service = StreamAnalyzerService.new(stream_url)
    descriptors = Descriptor.all

    stream_analyzer_service.store_frames

    response_frame = stream_analyzer_service.start_frames_analyzing(descriptors)
    i = Base64.encode64(response_frame[:image])

    sse = SSE.new(response.stream, retry: 300)
    sse.write({ employees: response_frame[:employees], image: i })
  ensure
    sse.close
  end
end
