module ControllerHelper
  def paramExists?(param, message)
    unless !param.nil? &&
      !param.empty?
      userError(message)
    end
  end

  def validateParam(param, message)
    unless !param.nil? &&
            yield(param)
      userError(message)
    end
  end


  def userError(message)
    {
      status: 400,
      body: error_body(message)
    }
  end

  def success(body)
    {
      status: 200,
      body: body
    }
  end

  def notFound(message)
    {
      status: 404,
      body: error_body(message)
    }
  end

  private
    def error_body(message)
      { message: message }.to_json
    end
end
