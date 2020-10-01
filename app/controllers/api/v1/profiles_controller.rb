class API::V1::ProfilesController < API::V1::BaseController
  authorize_resource class: User
  
  def me
    json_response(current_resource_owner, :ok, serializer: MeSerializer)
  end

  def others
    @users = User.where.not(id: current_resource_owner.id)
    json_response(@users, :ok, each_serializer: OthersSerializer)
  end
end
