require "json"
require "aws_lambda_runtime"

AwsLambdaRuntime.run do
  {"my-example-response": "hi fellas"}
end
