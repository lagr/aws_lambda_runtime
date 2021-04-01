module AwsLambdaRuntime
  # `Invocation` provides the event payload, the context and meta information of a lambda invocation.
  struct Invocation
    getter aws_request_id : String
    getter client_context : JSON::Any
    getter context : LambdaContext
    getter deadline_ms : Int64
    getter event : String
    getter identity : JSON::Any
    getter invoked_function_arn : String
    getter trace_id : String

    def initialize(next_invocation_response)
      headers = next_invocation_response.headers
      @event = next_invocation_response.body

      @context = LambdaContext.new
      @start_time = Time.monotonic

      @aws_request_id = headers["Lambda-Runtime-Aws-Request-Id"]
      @deadline_ms = Int64.new(headers["Lambda-Runtime-Deadline-Ms"])
      @invoked_function_arn = headers["Lambda-Runtime-Invoked-Function-Arn"]

      @client_context = JSON.parse(headers.fetch("Lambda-Runtime-Client-Context", "null"))
      @identity = JSON.parse(headers.fetch("Lambda-Runtime-Cognito-Identity", "null"))
      @trace_id = headers.fetch("Lambda-Runtime-Trace-Id", "")
    end

    # FIXME: not correct, deadline ms is a date
    def get_remaining_time_in_millis
      elapsed_time = Time.monotonic - @start_time
      remaining_time = @deadline_ms - elapsed_time
      remaining_time.positive? ? remaining_time.total_milliseconds : 0
    end
  end
end
