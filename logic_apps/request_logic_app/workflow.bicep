@description('Name of the workflow to create based on this template.')
param workflow_name string

@description('location')
param location string = resourceGroup().location

resource logic_app 'Microsoft.Logic/workflows@2019-05-01' = {
  name: workflow_name
  location: location
  properties: {
    definition: loadJsonContent('./workflow_definition.json').definition
    parameters: {
      '$connections': {
        value: {}
      }
    }       
  }
}
