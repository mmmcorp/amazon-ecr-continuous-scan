#!/bin/sh
env GOOS=linux GOARCH=amd64 go build -v -ldflags '-d -s -w' -a -tags netgo -installsuffix netgo -o bin/configs ./configs
env GOOS=linux GOARCH=amd64 go build -v -ldflags '-d -s -w' -a -tags netgo -installsuffix netgo -o bin/start-scan ./start-scan
env GOOS=linux GOARCH=amd64 go build -v -ldflags '-d -s -w' -a -tags netgo -installsuffix netgo -o bin/summary ./summary
env GOOS=linux GOARCH=amd64 go build -v -ldflags '-d -s -w' -a -tags netgo -installsuffix netgo -o bin/findings ./findings

sam package \
--template-file template.yaml \
--output-template-file current-stack.yaml \
--s3-bucket ${ECR_SCAN_SVC_BUCKET} \
--s3-prefix ${ECR_SCAN_SVC_S3_PREFIX}

sam deploy \
--template-file current-stack.yaml \
--stack-name ${ECR_SCAN_STACK_NAME} \
--capabilities CAPABILITY_IAM \
--parameter-overrides ConfigBucketName="${ECR_SCAN_CONFIG_BUCKET}" AllowIPAddress="${ALLOW_IP_ADDRESS}"
