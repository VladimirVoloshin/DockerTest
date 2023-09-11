param location string
param imageWebApiName string

//var random = uniqueString('utcnow()')
var random = 'd0ck8r'
var acrSku = 'Basic'
var webAppSku = 'F1'

resource acrResource 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: '${random}dockerregistry'
  location: location
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: true
  }
}

resource plan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: '${random}-web-plan'
  location: location
  sku: {
    name: webAppSku
    capacity: 1
  }
  properties: {
    reserved: true
  }
  kind: 'app,linux,container'
}

resource webApi 'Microsoft.Web/sites@2020-06-01' = {
  name: '${random}-webapi'
  location: location
  kind: 'app,linux,container'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      minTlsVersion: '1.2'
      linuxFxVersion: 'DOCKER|${acrResource.name}.azurecr.io/${imageWebApiName}:latest'
      appSettings: [
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: 'Development'
        }
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
        {
          name: 'DOCKER_ENABLE_CI'
          value: 'true'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: listCredentials(resourceId('Microsoft.ContainerRegistry/registries', acrResource.name), '2020-11-01-preview').passwords[0].value
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://${acrResource.name}.azurecr.io'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: acrResource.name
        }
      ]
    }
  }
}

output dockerContainerRegistryName string = acrResource.name
output webAppApiName string = webApi.name
