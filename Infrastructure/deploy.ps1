$location = 'westeurope'
$resourceGroupName = 'DockerDeployAppServiceRG'
$imageWebApiName = 'webapidockertest'
$gitRepoUrl = 'https://github.com/VladimirVoloshin/WebApiDockerTest.git'
$gitBranch = 'main'
$webAppDockerFilePath = 'src'
$gitAccessToken = $Env:GITHUB_TOKEN

# CREATE RESOURCE GROUP
az group create --name $resourceGroupName --location $location 

# CREATE RESOURCES
$result = (az deployment group create `
        --resource-group $resourceGroupName `
        --template-file ./infrastructure/main.bicep `
        --parameters location=$location imageWebApiName=$imageWebApiName) | ConvertFrom-Json
$dockerContainerRegistryName = $result.properties.outputs.dockerContainerRegistryName.value
$webAppApiName = $result.properties.outputs.webAppApiName.value

#BUILD AND PUSH CONTAINER TO ACR
# docker build --pull --rm -f "src\Dockerfile" -t $imageWebApiName .
# docker tag "$imageWebApiName" "$dockerContainerRegistryName.azurecr.io/$($imageWebApiName):latest"
# az acr login -n $dockerContainerRegistryName
# docker push "$dockerContainerRegistryName.azurecr.io/$($imageWebApiName):latest"


# # CREATE TASKS FOR CONTAINERS IN ORDER TO BUILD A UPLOAD A NEW DOCKER IMAGE 
# # ONCE A NEW PUSH WILL BE EXECUTED TO GIT REPO
# az acr task create `
#     --registry $dockerContainerRegistryName `
#     --name buildwebApp `
#     --image "$($imageWebApiName):latest" `
#     --context "$($gitRepoUrl)#$($gitBranch)" `
#     --file $webAppDockerFilePath `
#     --git-access-token $gitAccessToken

# # CREATE WEBHOOKS FOR CONTAINERS WHICH WILL UPDATE CONTAINER 
# # ONCE A NEW IMAGE WOULD BE PUSHED TO CONTAINER REGISTRY
# az acr webhook create `
#     --name "$($imageWebApiName)cd" `
#     --registry $dockerContainerRegistryName `
#     --resource-group $resourceGroupName `
#     --actions push `
#     --uri $(az webapp deployment container config --name $webAppApiName --resource-group $resourceGroupName --enable-cd true --query CI_CD_URL --output tsv) `
#     --scope "$($imageWebApiName):latest"