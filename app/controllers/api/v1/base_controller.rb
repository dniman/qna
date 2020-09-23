class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!
  
  def current_ability
    @current_ability ||= Api::V1::Ability.new(current_resource_owner)
  end
 
  private

    def current_resource_owner
      @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end
end
