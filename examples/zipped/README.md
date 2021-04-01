# Example project for provisioning via direct code upload

## Prerequisites
- You'll need lambda configured to provide its own runtime

## Building the and updating the lambda
1. navigate to project root
2. use the release script, passing the required ENVs, e.g.
    ```shell
    LAMBA_ARN=crystal-zipped-test \
    AWS_DEFAULT_REGION=...\
    AWS_PROFILE=... \
    bin/release
   ```
