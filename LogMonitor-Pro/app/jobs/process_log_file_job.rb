class ProcessLogFileJob < ApplicationJob
    queue_as :default
  
    def perform(log_id)
      log = Log.find_by(id: log_id)
      return unless log&.file&.attached?
  
      processor = FileProcessor.new(log)
      result = processor.process
      
      log.update(status: 'processed', processed_data: result)
    rescue => e
      log&.update(status: 'error', error_message: e.message)
      Rails.logger.error("Error processing log #{log_id}: #{e.message}")
    end
  end