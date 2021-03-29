require "./aws_lambda_runtime/*"
require "json"

# Ensure that logs are flushed immediately.
STDOUT.sync = true

module AwsLambdaRuntime
  VERSION = "0.2.2"

  def self.run(&block : (JSON::Any, Invocation) -> T) forall T
    self.listen(&->(event : String, invocation : Invocation) { block.call(JSON.parse(event), invocation) })
  end

  def self.run(handler : Proc(JSON::Any, Invocation, T)) forall T
    self.listen(&->(event : String, invocation : Invocation) { handler.call(JSON.parse(event), invocation) })
  end

  def self.run(handler : Proc(String, Invocation, T)) forall T
    self.listen(&handler)
  end

  def self.listen(&block : (String, Invocation) -> T) forall T
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
