#TODO do we actually need this?
module AppHelper
    def param_exists(param, message)
      unless params && params.respond_to?(:has_key?) &&
              params.has_key?(param.to_s) &&
              !params[param].nil? &&
              !params[param].empty?
        halt 400, error_body(message)
      end
    end
    def validate_param(param, message)
      unless params && params.respond_to?(:has_key?) &&
              params.has_key?(param.to_s) &&
              !params[param].nil? &&
              yield(params[param])
        halt 400, error_body(message)
      end
    end
  
    def processControllerReturn(controllerReturn)
        status controllerReturn[:status]
        body controllerReturn[:body]
    end

    def user_error_400(message)
      status 400
      body error_body(message)
    end
  
    private
      def error_body(message)
        { message: message }.to_json
      end
  end
  