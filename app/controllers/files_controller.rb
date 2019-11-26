class FilesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment, only: %w[ destroy ]

  def destroy
    if current_user.author_of?(@attachment.record)
      if @attachment.blob.attachments.count > 1
        @attachment.purge
      else
        @attachment.purge_later
      end
    end
  end

  private

  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
