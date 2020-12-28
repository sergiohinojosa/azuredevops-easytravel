#!/bin/bash


# http://easytravel-staging.northeurope.cloudapp.azure.com/easytravel/home
#DeploymentURI=easytravel-staging.northeurope.cloudapp.azure.com ; EasyTravelDeployment=None; 

#curl -v "${DEPLOYMENTURI}:8091/services/ConfigurationService/setPluginEnabled?name=${EASYTRAVELDEPLOYMENT}&enabled=true"


EASYTRAVELDEPLOYMENT=$(cat easytravel.image)

echo "Read and set deployment: $EASYTRAVELDEPLOYMENT"
echo "##vso[task.setvariable variable=EASYTRAVELDEPLOYMENT]$EASYTRAVELDEPLOYMENT"

doDeployment() {
    echo "Doing deployment via REST to ${DEPLOYMENTURI} for image tag:${EASYTRAVELDEPLOYMENT}"
    curl -v "${DEPLOYMENTURI}:8091/services/ConfigurationService/setPluginEnabled?name=${EASYTRAVELDEPLOYMENT}&enabled=true"

}

undoDeployment(){
    echo "UnDoing deployment via REST to ${DEPLOYMENTURI} for image tag:${EASYTRAVELDEPLOYMENT}"
    curl -v "${DEPLOYMENTURI}:8091/services/ConfigurationService/setPluginEnabled?name=${EASYTRAVELDEPLOYMENT}&enabled=false"
}

doDeployment