#!/bin/bash

iam="$(readlink -f "${BASH_SOURCE[0]}")"
startdir="$(dirname "$iam")"
iam="$(basename "$iam")"

# exec 3>&1 4>&2
# trap 'exec 2>&4 1>&3' 0 1 2 3
# exec 1>$(cut -d'.' -f1 <<<"$iam").log

abort()
{
  ## handles printing error iamssages and exiting ##
  ## XXX this is really *just* a convenience function ##
  ## it saves you the effort of maybe typing about a couple dozen characters or so ##

  # FIXME introduce the __mkme__ alias so we can use $iam
  local name=''
  local noname=''
  local silent=''
  local err=1
  local argv="$(getopt -o 'e:n:Ns' -n "abort" -- "$@")"

  if [[ $? -ne 0 ]]; then
    exit $err
  fi

  eval set -- "$argv"

  while :; do
    case "$1" in
      -e)
        shift
        err="$1"
        shift
        ;;
      -n)
        shift
        name="$1: "
        shift
        ;;
      -N)
        shift
        noname=' '
        ;;
      -s)
        shift
        silent=' '
        ;;
      --)
        shift
        break
        ;;
    esac
  done

  [[ -z $name ]] && [[ -z $noname ]] && name="$iam: "

  for y in "$@"; do
    printf "$name$y\n";
  done
  [[ $silent ]] || exit $err
}

# isvar()
# {
#   mod_isnum() {
#     local re='^[0-9]+$'
#     if [[ -n $1 ]]; then
#       [[ $1 =~ $re ]] && return 0
#       return 1
#     else
#       return 2
#     fi
#   }
#
#   if mod_isnum "$1"; then
#     return 1
#   fi
#
#   local arr="$(eval eval -- echo -n "\$$1")" # FIXME a number will always return as a var
#   if [[ -n ${arr[@]} ]]; then
#     return 0
#   fi
#   return 1
# }
#
# pop()
# {
#   mod_srev()
#   {
#     awk <<<"$@" '{ for (i=NF; i>1; --i) printf("%s ",$i); print $1; }' # TODO maybe rewrite this in a do-while loop?
#   }
#
#   local var=
#   local isvar=0
#   local arr=()
#
#   if [[ -z $@ ]]; then return 2; fi
#
#   if isvar "$1"; then
#     var="$1"
#     isvar=1
#     arr=($(eval eval -- echo -n "\${$1[@]}"))
#   else
#     arr=($@)
#   fi
#
#   arr=($(mod_srev "${arr[@]}"))
#   eval set -- "${arr[@]}"
#   shift
#   arr=($(mod_srev "${arr[@]}"))
#   echo "${arr[@]}"
#
#   if [[ $isvar -eq 1 ]]; then
#     eval -- "$var=(${arr[@]})"
#   fi
# }

# main()
# {
#   local argv="$(getopt -l 'help' -o 'h' -n "$iam" -- "$@")"
#   local argv_err="$?"
#
#   if [[ $argv_err -ne 0 ]]; then
#     main -h
#     return 1
#   fi
#
#   eval set -- "$argv"
#
#   local optc=0
# }
#

getcontext()
{
  aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name) || abort 'failed to get kubectl context'
}

################################
# HELM and Applications
# * Prometheus
#   * Alert Manager
#   *
# * Cert-Manager
# * Ingress
# * Node Problem Detector
# * Grafana
################################
repos=(
  https://charts.bitnami.com/bitnami
  bitnami
  https://charts.jetstack.io
  jetstack
  https://kubernetes.github.io/ingress-nginx
  ingress-nginx
  https://charts.deliveryhero.io
  deliveryhero
  https://prometheus-community.github.io/helm-charts
  prometheus-community
  https://grafana.github.io/helm-charts
  grafana
)

for ((idx=0; idx < ${#repos[@]}; ++idx)); do
  helm repo add ${repos[$(($idx + 1))]} ${repos[$idx]}
  ((idx++))
done

helm repo update

# aws ec2 allocate-address | tee eip.txt || abort 'failed to allocate ip address for ingress'
# ipid=$(jq -r '.AllocationId' eip.txt)
# ipaddr=$(jq -r '.PublicIp' eip.txt)

getcontext

helm install prometheus prometheus-community/prometheus --namespace watcher --create-namespace || abort 'failed to install prometheus'
helm install prometheus prometheus-community/prometheus --namespace watcher --create-namespace || abort 'failed to install prometheus'
helm install alert-manager prometheus-community/alertmanager --namespace watcher || abort 'failed to install alert-manager'
helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress --create-namespace \
helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress --create-namespace \
  --set controller.metrics.enabled=true \
  --set controller.metrics.serviceMonitor.enabled=true \
  || abort 'failed to deploy ingress'
  # --set controller.config.proxy-body-size=301m \
  # --set controller.service.loadBalancerIP=$ipaddr \
# kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.9.1/cert-manager.crds.yaml
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace \
  --version v1.9.1 \
  --set installCRDS=true \
  || abort 'failed to deploy cert-manager'
helm install node-problem-detector deliveryhero/node-problem-detector --namespace watcher \
  --set metrics.enabled=true \
  || abort 'failed to deploy node-problem-detector'
  # --set metrics.serviceMonitor.enabled=true \
helm install grafana grafana/grafana --namespace watcher \
  --set serviceMonitor.enabled=true \
  || abort 'failed to deploy grafana'
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml
