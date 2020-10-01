Last login: Thu Sep 24 11:27:34 on ttys004

The default interactive shell is now zsh.
To update your account to use zsh, please run `chsh -s /bin/zsh`.
For more details, please visit https://support.apple.com/kb/HT208050.
oawofolu-a01:build-service oawofolu$ ls -ltr
total 152
-rw-r--r--@ 1 oawofolu  staff    136 Aug 27 11:31 values.yaml
drwxr-xr-x@ 8 oawofolu  staff    256 Aug 27 11:31 manifests
-rw-r--r--@ 1 oawofolu  staff   3153 Aug 27 11:31 images.lock
-rw-r--r--@ 1 oawofolu  staff   3459 Sep 30 18:22 descriptor-100.0.20.yaml
-rw-------  1 oawofolu  staff  51682 Sep 30 18:25 kubeconfig
-rw-r--r--@ 1 oawofolu  staff   1537 Sep 30 18:25 ca.crt
-rw-r--r--  1 oawofolu  staff    248 Sep 30 18:26 credentials.yaml
-rwxr-xr-x  1 oawofolu  staff      0 Sep 30 20:45 temp.09.30.2020.sh
-rwxr-xr-x  1 oawofolu  staff   1470 Oct  1 12:58 temp.10.01.2020.sh
oawofolu-a01:build-service oawofolu$ cd ..
oawofolu-a01:tbs oawofolu$ ls -ltr
total 0
drwxr-xr-x  11 oawofolu  staff  352 Oct  1 12:57 build-service
oawofolu-a01:tbs oawofolu$ cd ..
oawofolu-a01:v7k8s oawofolu$ ls -ltr
total 112
-rw-r--r--  1 oawofolu  staff    988 Sep 29 12:04 guest_cluster.yaml
-rw-r--r--  1 oawofolu  staff    280 Sep 29 15:47 test.yaml
-rw-r--r--  1 oawofolu  staff    598 Sep 29 15:55 podsecuritypolicy.yaml
-rw-r--r--  1 oawofolu  staff    197 Sep 29 15:59 networkpolicy.yaml
-rw-r--r--  1 oawofolu  staff  15995 Sep 29 18:09 contour.yaml
-rwxr-xr-x  1 oawofolu  staff   2336 Sep 29 20:23 copy-cert.sh
-rwxr-xr-x  1 oawofolu  staff   3755 Sep 29 21:05 temp.09.29.2020.sh
-rw-r--r--  1 oawofolu  staff    814 Sep 30 15:38 README.txt
-rwxr-xr-x  1 oawofolu  staff      0 Sep 30 16:07 temp.09.30.2020.sh
-rwxr-xr-x  1 oawofolu  staff    592 Sep 30 16:22 download-container-images.sh
drwxr-xr-x  3 oawofolu  staff     96 Sep 30 16:35 harbor
-rwxr-xr-x  1 oawofolu  staff    673 Sep 30 17:24 download-helm-images.sh.old
drwxr-xr-x  4 oawofolu  staff    128 Sep 30 17:29 contour
drwxr-xr-x  3 oawofolu  staff     96 Sep 30 18:20 tbs
-rwxr-xr-x  1 oawofolu  staff   1295 Oct  1 12:58 download-helm-images.sh
oawofolu-a01:v7k8s oawofolu$ vi download-helm-images.sh 
oawofolu-a01:v7k8s oawofolu$ vi download-container-images.sh 
oawofolu-a01:v7k8s oawofolu$ vi download-container-images.sh 





#############################################################################################################################
#
# Usage: ./download-container-images.sh [URL | TAR] [TARGET-REGISTRY] <TARGET-REGISTRY-USERNAME> <TARGET-REGISTRY-PASSWORD>
# Example:
#         ./download-container-images.sh nginx localhost:5000
#         ./download-container-images.sh nginx.tar myregistry/projectred admin pw123
#
#############################################################################################################################


[[ -z $1 ]] && echo "Error: A valid container image is required. Usage: download-container-images.sh [URL | TAR] [TARGET-REGISTRY] <TARGET-REGISTRY-USERNAME> <TARGET-REGISTRY-PASSWORD>" && exit;

[[ -z $2 ]] && echo "Error: A valid target registry is required. Usage: download-helm-images.sh [URL | TAR] [TARGET-REGISTRY] <TARGET-REGISTRY-USERNAME> <TARGET-REGISTRY-PASSWORD>" && exit;

[[ -z $3 ]] && user=administrator@vsphere.local || user=$3

[[ -z $4 ]] && pw=dummy || pw=$4

# Parse the target registry variable
IFS=/ read -a target <<< "$2"

temp_script_name=temp.$(date +'%m.%d.%Y').sh

case ${#target[@]} in
   2) echo $1 | sed -r "s/([^/]*)\/(.*)/echo \"copying \1\/\2 to ${target}\"; skopeo copy --dest-tls-verify=false docker:\/\/\1\/\2 docker:\/\/${target[0]}\/${target[1]}\/\2/" > $temp_script_name
   *) echo $1 | sed -r "s/([^/]*)\/(.*)/echo \"copying \1\/\2 to ${target}\"; skopeo copy --dest-tls-verify=false docker:\/\/\1\/\2 docker:\/\/${target[0]}\/\2/" > $temp_script_name
esac

chmod +x $temp_script_name

./$temp_script_name
