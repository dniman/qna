module ApiHelper
  HEADERS = { 
    headers: {
      #'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }
  }
  
  def json
    @json ||= JSON.parse(response.body)
  end

  def do_request(method, path, options={})
    options.merge!(HEADERS)
    send(method, path, options)
  end
end
