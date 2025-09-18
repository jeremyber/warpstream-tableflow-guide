# set all my instance variables
source set-your-variables-here.sh

docker network create warpstream-net


docker run --name warpstream-agent --network warpstream-net -d -v ~/.aws:/root/.aws:ro \
-p 9092:9092 \
-e GOMAXPROCS=3 \
public.ecr.aws/warpstream-labs/warpstream_agent:latest \
    agent \
    -bucketURL "s3://$S3_BUCKET?region=$S3_BUCKET_REGION" \
    -agentKey $AGENT_KEY \
    -defaultVirtualClusterID $YOUR_VIRTUAL_CLUSTER_ID \
    -region $CLUSTER_REGION


# run Tableflow

    docker run --name warpstream-tableflow --network warpstream-net -d \
    -v ~/.aws:/root/.aws:ro \
    -p 9093:9093 \
    -e GOMAXPROCS=12 \
    public.ecr.aws/warpstream-labs/warpstream_agent:latest \
    agent \
    -bucketURL s3://$S3_BUCKET \
    -agentKey $TFLOW_AGENT_KEY \
    -region $CLUSTER_REGION \
    -kafkaPort 9092 \
    -defaultVirtualClusterID $WARPSTREAM_DEFAULT_VIRTUAL_CLUSTER_ID