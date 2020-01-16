# frozen_string_literal: true
require 'httparty'
require 'json'
require 'base64'

module FaceSDK

  BASE_URL = 'http://192.168.33.174:4567'

  def self.GetModuleInfo
    response = HTTParty.get(BASE_URL)
    return JSON.parse(response)
  end

  def self.GetDefaultComparisonParameters()
    { "threshold50": 0.44999998807907104, "threshold99": 0.75 }
  end

  def self.CompareFacesByDescriptor(descr1, descr2, params)
    file = File.open('descr1.tmp', 'w')
    file.write(Base64.encode64(descr1))
    file.close

    file = File.open('descr2.tmp', 'w')
    file.write(Base64.encode64(descr2))
    file.close

    command = "curl -s -X PUT -F descr1=@descr1.tmp -F descr2=@descr2.tmp #{BASE_URL}/compare"
    r = IO.popen(command, "r+")
    JSON.parse(r.gets)["distance"].to_f
  #   return result
  # rescue JSON::ParserError => e
  #   0
  end

  class VideoCapture
    MOCK_FRAME = {
      X: 196.25697326660156,
      Y: 245.6751251220703,
      W: 424.1531677246094,
      H: 499.257568359375,
      Score: 0.9999901056289673,
      DescriptorNorm: 32.800621032714844,
      Descriptor: "\xFF\xD8\xFF\xE0\x00\x10JFIF\x00\x01\x01\x00\x00"
    }

    def initialize(path)
      @path = path
      command = "curl -s -X PUT -d url='rtsp://admin:1qaz!#{@path}' #{BASE_URL}/video_capture"
      IO.popen(command, "r+")
    end

    def IsOpened()
      true
    end

    def ReadFrame()
      response = JSON.parse(HTTParty.get(BASE_URL + "/video_capture"))
      Base64.decode64(response['frame'])
    end
  end

  class ImageAnalyzer
    def initialize;
    end

    def ProcessBlob(blob, input_params)
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
