# Example project

## Prerequisites
- You'll need an (ECR) container repository

## Building the image
1. navigate to project root
2. use the release script, passing the required ENVs
    ```shell
    TAG_NAME=crystal-test \
    REPOSITORY_URL=<your-account-id>.dkr.ecr.eu-central-1.amazonaws.com \
    AWS_PROFILE=... \
    bin/release
   ```

## Setting up the lambda
1. On the lambda home view click 'Create Function'
2. choose 'Container Image'
3. give the function a name
4. click 'Browse images'
5. Select repository => choose the repository of your image
6. Select image tagged with 'latest'
7. Save

## Updating the lambda
0. Release a new image
1. On the lambda page click 'Deploy new image'
2. click 'Browse images'
3. Select repository => choose the repository of your image
4. Select image 'latest'
5. Save
