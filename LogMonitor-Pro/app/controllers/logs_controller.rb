class LogsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_log, only: [:show, :destroy]
  
    def index
      @logs = current_user.logs.order(created_at: :desc)
    end
  
    def show
      authorize @log
      respond_to do |format|
        format.html
        format.json { render json: @log }
      end
    end
  
    def new
      @log = Log.new
    end