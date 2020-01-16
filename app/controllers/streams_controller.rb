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

    blob = videoCapture.ReadFrame()


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
    n = 0
    t = Thread.new do
      loop do
        n = n + 1
        puts 'thread 1'
        next_frame = stream_analyzer_service.frame_storage_service.next_frame
        #if next_frame.present?
          #frames = image_analyzer_service.frames(blob: next_frame)
          frames = image_analyzer_service.frames(path: '/Users/lizavetakarenevich/Downloads/6.jpg')
          puts 'no faces found' if frames.size == 0
          puts 'face is found' if frames.size > 0
          frames.each do |frame|
            puts 'frame ' + frame['Descriptor']
            descriptors.reverse.each do |descriptor|
              puts 'descriptor ' + descriptor.descriptor_values.length.to_s
              person_is_found = FaceSDK::CompareFacesByDescriptor(frame['Descriptor'], descriptor.descriptor_values, FaceSDK::GetDefaultComparisonParameters())
              puts 'comparison ' + person_is_found.to_s
              # puts 'face is found' + descriptor.person.name if person_is_found > 0.75
              # puts 'face not found' if person_is_found < 0.75
            end
          end
        #end
        sleep 1
      end
    end

    trap("INT") do
      t.exit
      exit
    end

    stream_analyzer_service.store_frames


    # fr1 = image_analyzer_service.frames('/Users/lizavetakarenevich/Downloads/4.png')
    # fr2 = image_analyzer_service.frames('/Users/lizavetakarenevich/Downloads/5.png')
    #image_analyzer_service.add_employee('/Users/lizavetakarenevich/Downloads/4.png', 'Oleg', 'Gubin', 'Head of Rnd')
    #image_analyzer_service.add_employee('/Users/lizavetakarenevich/Downloads/5.png', 'Ksenia', 'Meshkova', 'Rnd Engineer')
    image_analyzer_service.add_employee('/Users/lizavetakarenevich/Downloads/6.jpg', 'Angelina', 'Jolie', 'Actress')


    # EM.run {
    #   EM::WebSocket.run(:host => "127.0.0.1", :port => 8080) do |ws|
    #     ws.onopen { |handshake|
    #       files = ['/Users/lizavetakarenevich/Downloads/1.jpeg', '/Users/lizavetakarenevich/Downloads/2.jpg']
    #       files.each do |file|
    #         f = File.binread(file).to_s
    #         data = {employees: [], image: f}
    #         ws.send data.to_json
    #       end
    #       puts "WebSocket connection open"
    #
    #       # Access properties on the EM::WebSocket::Handshake object, e.g.
    #       # path, query_string, origin, headers
    #
    #       # Publish message to the client
    #
    #       # ws.send "Hello Client, you connected to #{handshake.path}"
    #     }
    #
    #     ws.onclose { puts "Connection closed" }
    #
    #     ws.onmessage { |msg|
    #       puts "Recieved message: #{msg}"
    #       ws.send "Pong: #{msg}"
    #     }
    #   end
    # }
  end

  def identify;
  end
end
