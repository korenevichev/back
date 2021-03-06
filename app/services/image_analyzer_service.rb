# frozen_string_literal: true

require '/files/libfacesdk_ruby'
require 'singleton'

class ImageAnalyzerService
  include Singleton

  DEFAULT_INPUT = {
    pThresh: 0.9,
    rThresh: 0.9,
    oThresh: 0.7
  }

  DEFAULT_CONFIG = {
    FaceDetectionModelsFolder: '/facesdk/graphs/',
    FaceRecognitionModelsFolder: '/facesdk/graphs/',
    UseGPU: true,
    LogFilePath: '',
    ResetCount: 0
  }


  def initialize(config = DEFAULT_CONFIG)
    @image_analyzer = FaceSDK::ImageAnalyzer.new(config)
  end

  def frames(blob: true, path: false)
    blob = IO.binread(path) if path
    @image_analyzer.ProcessBlob(blob, DEFAULT_INPUT)
  end

  def add_employee(file_path, name, surname, position)
    frames = frames(path: file_path)
    raise StandardError('More than one face') if frames.count > 1
    params = { name: name, surname: surname, job_position: position }
    frame = frames.first

    Person.transaction do
      person = Person.create(params)
      person.build_descriptor(descriptor_values: frame['Descriptor'])
      person.save
    end
  end
end
