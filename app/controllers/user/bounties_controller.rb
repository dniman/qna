class User::BountiesController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def index
  end
end
