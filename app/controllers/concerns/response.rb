module Response
  def json_response(object, status = :ok, options={})
    return render json: object, status: status, each_serializer: options[:serializer] if options.has_key?(:serializer)
    render json: object, status: status
  end
end
