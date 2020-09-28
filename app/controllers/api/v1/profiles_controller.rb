class API::V1::ProfilesController < API::V1::BaseController
  authorize_resource class: User
  
  def me
    render json: current_resource_owner
  end

  def others
    @users = User.where.not(id: current_resource_owner.id)
    render json: @users
  end
end
