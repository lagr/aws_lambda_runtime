require "./aws_lambda_runtime/*"

# Ensure that logs are flushed immediately.
STDOUT.sync = true

module AwsLambdaRuntime
  VERSION = "0.1.0"

  def self.run(&block : (String, Invocation) -> T) forall T
    client = Client.new

    loop do
      invocation = client.get_next_invocation

      aws_request_id = invocation.aws_request_id
      ENV["_X_AMZN_TRACE_ID"] = invocation.trace_id

      handler_response = yield(invocation.event, invocation)

      client.send_response(aws_request_id, handler_response)
    end
  end
end
