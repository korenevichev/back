require 'socket'
require 'uri'
require 'em-websocket'
require 'json'
require 'mock/mock_stream_service'

class StreamsController < ApplicationController
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
    Thread.new do
      loop do
        res = stream_analyzer_service.start_frames_analyzing(descriptors)
        puts res
        sleep 1
      end
    end

    # trap("INT") do
    #   t.exit
    #   exit
    # end

    Thread.new do
      stream_analyzer_service.store_frames
    end

    # fr1 = image_analyzer_service.frames('/Users/lizavetakarenevich/Downloads/4.png')
    # fr2 = image_analyzer_service.frames('/Users/lizavetakarenevich/Downloads/5.png')
    #image_analyzer_service.add_employee('/Users/lizavetakarenevich/Downloads/4.png', 'Oleg', 'Gubin', 'Head of Rnd')
    #image_analyzer_service.add_employee('/Users/lizavetakarenevich/Downloads/5.png', 'Ksenia', 'Meshkova', 'Rnd Engineer')
    #image_analyzer_service.add_employee('/Users/lizavetakarenevich/Downloads/6.jpg', 'Angelina', 'Jolie', 'Actress')


    #   EM.run {
    #     EM::WebSocket.run(:host => "127.0.0.1", :port => 8080) do |ws|
    #       ws.onopen { |handshake|
    #         file = '/Users/lizavetakarenevich/Downloads/2.jpg'
    #         f = File.binread(file).to_s
    #         i = Base64.encode64(f)
    #         data = { employees: [{name: 'ttt', surname: 'lolo', job_position: 'xyi'}], image: i }
    #         ws.send data.to_json
    #         puts "WebSocket connection open"
    #
    #         # Access properties on the EM::WebSocket::Handshake object, e.g.
    #         # path, query_string, origin, headers
    #
    #         # Publish message to the client
    #
    #         ws.send "Hello Client, you connected to #{handshake.path}"
    #       }
    #
    #       ws.onclose { puts "Connection closed" }
    #
    #       ws.onmessage { |msg|
    #         puts "Recieved message: #{msg}"
    #         ws.send "Pong: #{msg}"
    #       }
    #     end
    #   }
  end

  def identify;
  end
end
