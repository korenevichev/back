# frozen_string_literal: true

require 'mock/mock_stream_service'

class ImageAnalyzerService

  INPUT_PARAMETERS = {
    pThresh: 0.9,
    rThresh: 0.9,
    oThresh: 0.7
  }

  DEFAULT_CONFIGURATION = {
    # Path to face detection model files
    FaceDetectionModelsFolder: "/home/ganchenkovv/work/facesdk/modules/detector/graphs/",
    # Path to face recognition model files -- for face descriptor extraction
    FaceRecognitionModelsFolder: "/home/ganchenkovv/work/facesdk/modules/detector/graphs/",
    # Flag of GPU usage enabling
    UseGPU: true,
    # Path to log file. If empty then logs would be printed to stdout
    LogFilePath: 'logpath',
    # Each 'ResetCount' of detection detector would be reset (if 'Runt' == 0 then reseting would not be used)
    ResetCount: 0
  }

  def initialize
    @image_analyzer = FaceSDK::ImageAnalyzer.new
  end

  def frames(blob: true, path: false)
    blob = IO.binread(path) if path
    @image_analyzer.ProcessBlob(blob, INPUT_PARAMETERS)
  end

  def add_employee(file_path, name, surname, position)
    frames = frames(path: file_path)
    raise StandardError('More than one face') if frames.count > 1
    params = { name: name, surname: surname, job_position: position }
    params = { name: 'Angelina', surname: 'Jolie', job_position: 'Actress' }
    frame = frames.first
    descriptor = Descriptor.new(descriptor_values: frame['Descriptor'])
    descriptor.save
    person = descriptor.build_person(params)
    person.save
  end
end
