module RequestSpecHelpers

  def response_json
    JSON.parse(response.body)
  end

  def response_data
    response_json["data"]
  end

  def response_data_attributes
    response_data["attributes"]
  end

end
