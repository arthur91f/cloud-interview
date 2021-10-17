current_path="$(pwd)"

## LAUNCH MINIKUBE ------------------------------------------------------------
minikube start --driver=docker && \
minikube status && \
echo "minikube started" || (echo "minikube failed to start" ; exit 1 )

## ADD TRAEFIK AS INGRESS CONTROLLER ------------------------------------------
helm repo add traefik https://helm.traefik.io/traefik && \
helm repo update && \
helm install traefik traefik/traefik && \
echo "helm started" || (echo "minikube failed to start" ; exit 1 )

## GET APPS SOURCE CODE -------------------------------------------------------
git clone git@github.com:arthur91f/cloud-interview.git && \
git checkout proposition && \
echo "sources getted" || (echo "fail to get sources" ; exit 1 )

## BUILD APPS -----------------------------------------------------------------
cd "$current_path/cloud-interview/apps/hello" && \
docker build -t ornikar-hello . && \
echo "hello image builded" || \
(echo "fail to build hello image" ; cd "$current_path" ; exit 1 )

cd "$current_path/cloud-interview/apps/world" && \
docker build -t ornikar-world . && \
echo "world image builded" || 
(echo "fail to build world image" ; cd "$current_path" ; exit 1 )

## DEPLOY APPS ----------------------------------------------------------------

