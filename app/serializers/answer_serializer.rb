class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :created_at, :updated_at
  belongs_to :user
  has_many :files
  has_many :links
  has_many :comments

  def files
    object.files.map { |file| rails_blob_path(file, only_path: true) }
  end
end
