docker build -t "$DOCKER_ID"/multi-client:latest -t "$DOCKER_ID"/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t "$DOCKER_ID"/multi-server:latest -t "$DOCKER_ID"/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t "$DOCKER_ID"/multi-worker:latest -t "$DOCKER_ID"/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push "$DOCKER_ID"/multi-client:latest
docker push "$DOCKER_ID"/multi-server:latest
docker push "$DOCKER_ID"/multi-worker:latest

docker push "$DOCKER_ID"/multi-client:$SHA
docker push "$DOCKER_ID"/multi-server:$SHA
docker push "$DOCKER_ID"/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server="$DOCKER_ID"/multi-server:$SHA
kubectl set image deployments/client-deployment client="$DOCKER_ID"/multi-client:$SHA
kubectl set image deployments/worker-deployment worker="$DOCKER_ID"/multi-worker:$SHA