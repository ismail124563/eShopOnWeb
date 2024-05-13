param webAppName string = uniqueString(resourceGroup().id) // Générer une chaîne unique pour le nom de l'application web
param sku string = 'S1' // SKU du Plan App Service
param location string = resourceGroup().location

var appServicePlanName = toLower('AppServicePlan-${webAppName}')

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: sku
  }
  kind: 'app'
}
resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: webAppName
  kind: 'app'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|8.0'
      appSettings: [
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: 'Development'
        }
        {
          name: 'UseOnlyInMemoryDatabase'
          value: 'true'
        }
      ]
    }
  }
}

// Déclencheur d'événement pour déployer l'infrastructure lorsqu'un commit est poussé sur la branche principale
target scope = 'resourceGroup'
output deploymentTrigger on typeof(string) = resourceGroup().id
