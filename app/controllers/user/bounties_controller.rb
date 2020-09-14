class User::BountiesController < ApplicationController
  before_action :authenticate_user!
  skip_authorization_check

  def index
  end
end
