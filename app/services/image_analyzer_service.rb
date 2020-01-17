# frozen_string_literal: true

require 'mock/mock_stream_service'

class ImageAnalyzerService
  def initialize
    @image_analyzer = FaceSDK::ImageAnalyzer.new
  end

  def frames(blob: true, path: false)
    blob = IO.binread(path) if path
    @image_analyzer.process_blob(blob)
  end

  def add_employee(file_path, name, surname, position)
    frames = frames(path: file_path)
    raise StandardError('More than one face') if frames.count > 1
    params = { name: name, surname: surname, job_position: position }
    frame = frames.first
    descriptor = Descriptor.new(descriptor_values: frame['Descriptor'])
    descriptor.save
    person = descriptor.build_person(params)
    person.save
  end
end
