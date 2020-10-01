module Response
  def json_response(object, status = :ok, options={})
    if options.is_a?(Hash)
      if options.has_key?(:serializer) || options.has_key?(:each_serializer)
        return render json: object, status: status, **options
      end
    end
    render json: object, status: status
  end
end
