module ApplicationHelper
  def vote_rating(resource)
    resource.votes.positive_votes.size - resource.votes.negative_votes.size
  end
end
