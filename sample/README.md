# Introduction 
Project : Kernel API Server to provision KernelStack Elements.

# Build and Upload
docker login appsdkcontainerregistry.azurecr.io
  id: AppSdkContainerRegistry
  api-password : xxxx   # available in ACR : Access-keys : password
docker build . -t kernel/apiserver:vX # where vX is version like v2
docker tag kernel/apiserver:vX  appsdkcontainerregistry.azurecr.io/kernel/apiserver:vX  # where vX is version like v2
docker push appsdkcontainerregistry.azurecr.io/kernel/apiserver:vX

# Test
# Using current dev cluster.
docker run -p 5000:5000 appsdkcontainerregistry.azurecr.io/kernel/apiserver:v1  # replace v1 with proper version
# using own cluster k8s config
docker run -p 5000:5000 --mount type=bind,source=/opt/<cluster>/aks.dev.config,target=/opt/api/config/aks.dev.config  appsdkcontainerregistry.azurecr.io/kernel/apiserver:v1  # replace v1 with proper version
# swagger
open browser and http://docker_host_ip:5000
 
# Author
Gagan.Mandava@AssetMark.com
Apr 16, 2022
