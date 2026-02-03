class UploadsController < ApplicationController
    before_action :authenticate_user!
  
    def create
      @log = current_user.logs.build(log_params)
      
      if @log.save
        # Process the uploaded file asynchronously
        ProcessLogFileJob.perform_later(@log.id)
        redirect_to logs_path, notice: 'Log file uploaded successfully!'
      else
        render 'logs/new'
      end
    end
  
    private
  
    def log_params
      params.require(:log).permit(:name, :description, :file)
    end