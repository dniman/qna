class NotifySubscribedUsersJob < ApplicationJob
  queue_as :default

  def perform(object)
    Services::NotifySubscribedUsers.notify(object)
  end
end
