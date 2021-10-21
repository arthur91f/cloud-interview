current_path="$(pwd)"

## LAUNCH MINIKUBE ------------------------------------------------------------
minikube start --driver=docker && \
minikube status && \
echo "minikube started" || (echo "minikube failed to start" ; exit 1 )

## GET APPS SOURCE CODE -------------------------------------------------------
git clone https://github.com/arthur91f/cloud-interview.git && \
git checkout proposition && \
echo "sources getted" || (echo "fail to get sources" ; exit 1 )

## ADD TRAEFIK AS INGRESS CONTROLLER ------------------------------------------
helm repo add traefik https://helm.traefik.io/traefik &&
helm repo update &&
cd cloud-interview/host &&
helm install -f traefik.yml --set service.externalIPs[0]=$(minikube ip) traefik traefik/traefik &&
echo "helm started" || (echo "traefik failed to install" ; exit 1 )

## DEPLOY APP  ----------------------------------------------------------------
function install_app {
  app="$1"
  cd "$current_path/cloud-interview/apps/$app" && 
  docker build -t ornikar-$app . && 
  echo "$app image builded" || 
  (echo "fail to build $app image" ; cd "$current_path" ; exit 1 )

  minikube image load ornikar-$app:latest && 
    echo "$app image loaded in minikube" || 
    (echo "fail to load $app image in minikube" ; exit 1 )

  cd "$current_path/cloud-interview/host"
  helm install -f helm_values/ornikar-$app.yml ornikar-$app charts/front &&
    echo "front $app deployed" || 
    (echo "fail to deploy $app" ; cd "$current_path" ; exit 1)
  
  cd "$current_path"
}

for app in hello world ; do
  install_app $app
  echo "----------"
done

helm upgrade -f traefik.yml --set service.externalIPs[0]=$(minikube ip) traefik traefik/traefik

# helm upgrade -f helm_values/traefik.yml traefik traefik/traefik
# helm upgrade -f helm_values/ornikar-hello.yml ornikar-hello charts/front
# helm upgrade -f helm_values/ornikar-world.yml ornikar-world charts/front

# helm uninstall traefik
# helm uninstall ornikar-hello
# helm uninstall ornikar-world
