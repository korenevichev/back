# frozen_string_literal: true
require 'httparty'
require 'json'
require 'base64'

module FaceSDK

  BASE_URL = 'http://localhost:4000'

  def self.module_info
    response = HTTParty.get(BASE_URL)
    return JSON.parse(response)
  end

  def self.default_comparison_params
    { threshold50: 0.44999998807907104, threshold99: 0.75 }
  end

  def self.compare_faces_by_descriptor(descr1, descr2)
    file = File.open('descr1.tmp', 'w')
    file.write(Base64.encode64(descr1))
    file.close

    file = File.open('descr2.tmp', 'w')
    file.write(Base64.encode64(descr2))
    file.close

    command = "curl -s -X PUT -F descr1=@descr1.tmp -F descr2=@descr2.tmp #{BASE_URL}/compare"
    r = IO.popen(command, "r+")
    result = JSON.parse(r.gets)["distance"].to_f
    result
  rescue JSON::ParserError => e
    0
  end

  class VideoCapture
    def initialize(path)
      # @path = path
      # command = "curl -s -X PUT -d url='rtsp://admin:1qaz!#{@path}' #{BASE_URL}/video_capture"
      # IO.popen(command, "r+")
    end

    def opened
      true
    end

    def read_frame
      response = JSON.parse(HTTParty.get('http://192.168.43.2:8080').body)['data'][0]
      Base64.decode64(response)
    end
  end

  class ImageAnalyzer
    def process_blob(blob)
      filename = "blob.tmp"
      file = File.open(filename, 'w')
      file.write(Base64.encode64(blob))
      file.close

      command = "curl -s -X PUT -F blob=@blob.tmp #{BASE_URL}/image_analyzer"

      r = IO.popen(command, "r+")

      faces = JSON.parse(r.gets)['faces']
      faces.each { |d| d['Descriptor'] = Base64.decode64(d['Descriptor']) }
    end
  end
end
