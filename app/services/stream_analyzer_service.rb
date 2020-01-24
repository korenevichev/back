# frozen_string_literal: true

require '/files/libfacesdk_ruby'
require 'frame_storage_service'
require 'image_analyzer_service'

class StreamAnalyzerService
  attr_reader :frame_storage_service

  CONFIGURATION = {
    FaceDetectionModelsFolder: '/facesdk/graphs/',
    FaceRecognitionModelsFolder: '/facesdk/graphs/',
    UseGPU: true,
    LogFilePath: '',
    ResetCount: 0
  }

  def initialize
    @frame_storage_service = FrameStorageService.new
    @image_analyzer_service = ImageAnalyzerService.new(CONFIGURATION)
    @compare_params = FaceSDK::GetDefaultComparisonParameters()
  end

  def start_frames_analyzing(descriptors)
    next_frame = frame_storage_service.fetch.first
    found_faces = []
    if next_frame
      frames = @image_analyzer_service.frames(blob: next_frame)
      frames.each do |frame|
        descriptors.each do |descriptor|
          comparison_result = FaceSDK::CompareFacesByDescriptor(frame['Descriptor'], descriptor.descriptor_values)
          person_is_found = comparison_result > @compare_params[:threshold99]
          found_faces << descriptor.person if person_is_found
        end
      end
    end
    { image: next_frame, employees: found_faces }
  end
end
