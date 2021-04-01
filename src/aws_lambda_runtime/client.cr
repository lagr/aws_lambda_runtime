require "http/client"
require "json"

module AwsLambdaRuntime
  class Client
    NEXT_INVOCATION_PATH      = "/2018-06-01/runtime/invocation/next"
    INVOCATION_RESPONSE_PATH  = "/2018-06-01/runtime/invocation/%s/response"
    INITIALIZATION_ERROR_PATH = "/2018-06-01/runtime/init/error"
    INVOCATION_ERROR_PATH     = "/2018-06-01/runtime/invocation/%s/error"

    def initialize
      host, port = ENV["AWS_LAMBDA_RUNTIME_API"].split(':')
      @client = HTTP::Client.new(host, port)
    end

    def get_next_invocation
      response = @client.get(NEXT_INVOCATION_PATH)
      raise "Fetching next invocation failed: #{response.status_code}" unless response.success?

      Invocation.new(response)
    end

    def send_response(aws_request_id, response_data)
      raise "Cannot serialize response" unless response_data.responds_to?(:to_json)

      response = @client.post(INVOCATION_RESPONSE_PATH % aws_request_id, body: response_data.to_json)
      raise "Sending result failed: #{response.status_code}" unless response.success?
    end

    def send_error_response(aws_request_id : String, exception : Exception)
      @client.post(
        INVOCATION_ERROR_PATH % aws_request_id,
        headers: HTTP::Headers{
          "Lambda-Runtime-Function-Error-Type" => "Unhandled",
        },
        body: {
          errorMessage: exception.message,
          errorType:    exception.class.to_s,
          stacktrace:   exception.backtrace.first(100),
        }.to_json
      )
    end
  end
end
