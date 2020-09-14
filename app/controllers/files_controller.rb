class FilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attachment, only: %w[destroy]
  
  def destroy
    authorize!(params[:action].to_sym, @attachment)
    @attachment.purge if current_user.author_of?(@attachment.record)
  end

  private
    
    def set_attachment
      @attachment = ActiveStorage::Attachment.find(params[:id])
    end
end
