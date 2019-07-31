docker build -t "$DOCKER_USERNAME"/multi-client:latest -t "$DOCKER_USERNAME"/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t "$DOCKER_USERNAME"/multi-server:latest -t "$DOCKER_USERNAME"/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t "$DOCKER_USERNAME"/multi-worker:latest -t "$DOCKER_USERNAME"/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push "$DOCKER_USERNAME"/multi-client:latest
docker push "$DOCKER_USERNAME"/multi-server:latest
docker push "$DOCKER_USERNAME"/multi-worker:latest

docker push "$DOCKER_USERNAME"/multi-client:$SHA
docker push "$DOCKER_USERNAME"/multi-server:$SHA
docker push "$DOCKER_USERNAME"/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server="$DOCKER_USERNAME"/multi-server:$SHA
kubectl set image deployments/client-deployment client="$DOCKER_USERNAME"/multi-client:$SHA
kubectl set image deployments/worker-deployment worker="$DOCKER_USERNAME"/multi-worker:$SHA