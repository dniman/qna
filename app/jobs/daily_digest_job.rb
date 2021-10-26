class DailyDigestJob < ApplicationJob
  queue_as :mailers

  def perform(*args)
    Services::DailyDigest.new.send_digest
  end
end
