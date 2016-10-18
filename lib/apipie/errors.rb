module Apipie

  class Error < StandardError
  end

  class ParamError < Error
  end

  # abstract
  class DefinedParamError < ParamError
    attr_accessor :param, :param_description

    def initialize(param, param_description)
      @param = param
      @param_description = param_description
    end

    def parameter_path
      param_description.parents_path
    end
  end

  class ParamMissing < DefinedParamError
    def to_s
      unless @param.options[:missing_message].nil?
        if @param.options[:missing_message].kind_of?(Proc)
          @param.options[:missing_message].call
        else
          @param.options[:missing_message].to_s
        end
      else
        "Missing parameter #{@param.name}"
      end
    end

    def parameter_path
      [param.name] + param_description.parents_path
    end
  end

  class UnknownParam < DefinedParamError
    def to_s
      "Unknown parameter #{@param}"
    end
  end

  class ParamInvalid < DefinedParamError
    attr_accessor :value, :error

    def initialize(param, value, error, param_description)
      super param, param_description
      @value = value
      @error = error
    end

    def to_s
      "Invalid parameter '#{@param}' value #{@value.inspect}: #{@error}"
    end
  end

end
