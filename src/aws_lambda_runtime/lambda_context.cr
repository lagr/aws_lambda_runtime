module AwsLambdaRuntime
  struct LambdaContext
    getter function_name : String
    getter function_version : String
    getter memory_limit_in_mb : UInt32
    getter log_group_name : String
    getter log_stream_name : String

    def initialize
      @function_name = ENV["AWS_LAMBDA_FUNCTION_NAME"]
      @function_version = ENV["AWS_LAMBDA_FUNCTION_VERSION"]
      @memory_limit_in_mb = UInt32.new(ENV["AWS_LAMBDA_FUNCTION_MEMORY_SIZE"])
      @log_group_name = ENV["AWS_LAMBDA_LOG_GROUP_NAME"]
      @log_stream_name = ENV["AWS_LAMBDA_LOG_STREAM_NAME"]
    end
  end
end
