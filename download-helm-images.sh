#############################################################################################################################
#
# Usage: ./download-helm-images.sh [CHART | URL | TAR] [TARGET-REGISTRY] <TARGET-REGISTRY-USERNAME> <TARGET-REGISTRY-PASSWORD>
# Example:  
#         ./download-helm-images.sh bitnami/mychart localhost:5000 
#         ./download-helm-images.sh bitnami/mychart myregistry/projectred admin pw123
# Pre-reqs: 
#       On Mac, may require gnu-sed library (brew install gnu-sed)
#
#############################################################################################################################


[[ -z $1 ]] && echo "Error: A valid URL, tar, or path to a helm chart is required. Usage: download-helm-images.sh [CHART | URL | TAR]" && exit;

[[ -z $2 ]] && echo "Error: A valid target registry is required. Usage: download-helm-images.sh [CHART | URL | TAR] [TARGET_REGISTRY]" && exit;

[[ -z $3 ]] && user=administrator@vsphere.local || user=$3

[[ -z $4 ]] && pw=dummy || pw=$4

# Parse the target registry variable
IFS=/ read -a target <<< "$2"

temp_script_name=temp.$(date +'%m.%d.%Y').sh

case ${#target[@]} in
   2) helm template $1 | grep 'image:' | sed -r "s/(image: )([^/]*)\/(.*)/echo \"copying \2\/\3 to ${target}\"; skopeo copy --dest-creds=${user}:${pw} --dest-tls-verify=false docker:\/\/\2\/\3 docker:\/\/${target[0]}\/${target[1]}\/\3/" > $temp_script_name;;
   *) helm template $1 | grep 'image:' | sed -r "s/(image: )([^/]*)\/(.*)/echo \"downloading \2\/\3\"; skopeo copy --dest-creds=${user}:${pw} --dest-tls-verify=false docker:\/\/\2\/\3 docker:\/\/${target[0]}\/\3/" > $temp_script_name;;
esac

chmod +x $temp_script_name

./$temp_script_name
