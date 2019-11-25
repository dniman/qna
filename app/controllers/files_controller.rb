class FilesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment, only: %w[ destroy ]

  def destroy
    @attachment.purge if current_user.author_of?(@attachment.record)
    
    respond_to do |format|
      format.js
    end
  end

  private

  def find_attachment
    file = ActiveStorage::Blob.find_signed(params[:id])
    @attachment = ActiveStorage::Attachment.where(blob: file).first
  end
end
