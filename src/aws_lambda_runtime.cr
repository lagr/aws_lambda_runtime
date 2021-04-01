require "./aws_lambda_runtime/*"
require "json"

# Ensure that logs are flushed immediately.
STDOUT.sync = true

# An AWS Lambda runtime for crystal.
#
# ## Installation
#
# 1. Add the dependency to your `shard.yml`:
#
#     ```yaml
#     dependencies:
#       aws_lambda_runtime:
#         github: lagr/aws_lambda_runtime
#     ```
#
# 2. Run `shards install`
module AwsLambdaRuntime
  VERSION = "0.2.2"

  # Permits the runtime to be invoked with a block, parses the event.
  #
  # ```
  # AwsLambdaRuntime.run do |event, invocation|
  #   puts "event is a #{event.class.name}."
  #   # => event is a JSON::Any.
  #   {"serialize-this": "my friend"}
  # end
  # ```
  def self.run(&block : (JSON::Any, Invocation) -> T) forall T
    self.listen(&->(event : String, invocation : Invocation) { block.call(JSON.parse(event), invocation) })
  end

  # Permits the runtime to be passed a handler as a proc, parses the event.
  #
  # ```
  # def handler(event, invocation)
  #   puts "event is a #{event.class.name}."
  #   # => event is a JSON::Any.
  #   {"serialize-this": "my friend"}
  # end
  #
  # AwsLambdaRuntime.run(->handler(JSON::Any, AwsLambdaRuntime::Invocation))
  # ```
  def self.run(handler : Proc(JSON::Any, Invocation, T)) forall T
    self.listen(&->(event : String, invocation : Invocation) { handler.call(JSON.parse(event), invocation) })
  end

  # Permits the runtime to be passed a handler as a proc, does not parse the event.
  #
  # This comes handy if the event context is not of interest or should be parsed in a more specialized manner.
  #
  # ```
  # def handler(event, invocation)
  #   puts "event is a #{event.class.name}."
  #   # => event is a String.
  #   {"serialize-this": "my friend"}
  # end
  #
  # AwsLambdaRuntime.run(->handler(String, AwsLambdaRuntime::Invocation))
  # ```
  def self.run(handler : Proc(String, Invocation, T)) forall T
    self.listen(&handler)
  end

  private def self.listen(&block : (String, Invocation) -> T) forall T
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
