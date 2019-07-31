docker build -t karthdz/multi-client:latest -t karthdz/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t karthdz/multi-server:latest -t karthdz/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t karthdz/multi-worker:latest -t karthdz/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push karthdz/multi-client:latest
docker push karthdz/multi-server:latest
docker push karthdz/multi-worker:latest

docker push karthdz/multi-client:$SHA
docker push karthdz/multi-server:$SHA
docker push karthdz/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=karthdz/multi-server:$SHA
kubectl set image deployments/client-deployment client=karthdz/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=karthdz/multi-worker:$SHA