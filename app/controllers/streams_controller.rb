require 'socket'
require 'uri'
require 'json'

class StreamsController < ApplicationController
  include ActionController::Live

  def identify
    response.headers['Content-Type'] = 'text/event-stream'
    response.headers['Access-Control-Allow-Origin'] = '*'
    stream_analyzer_service = StreamAnalyzerService.new
    descriptors = Descriptor.all

    begin
      response_frame = stream_analyzer_service.start_frames_analyzing(descriptors)
      i = Base64.encode64(response_frame[:image])
      sse = SSE.new(response.stream, retry: 300)
      sse.write({ employees: response_frame[:employees], image: i })
    ensure
      sse.close if sse
    end
  end
end
