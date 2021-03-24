param pUser string = 'ppronk'
var vProjectName = 'sdla2021adf${pUser}'
var vLocation = 'westeurope'

param keysPermissions array {
  default: [
    'list'
    'get'
  ]
  metadata: {
    description: 'Specifies the permissions to keys in the vault. Valid values are: all, encrypt, decrypt, wrapKey, unwrapKey, sign, verify, get, list, create, update, import, delete, backup, restore, recover, and purge.'
  }
}

param secretsPermissions array {
  default: [
    'list'
    'get'
  ]
  metadata: {
    description: 'Specifies the permissions to secrets in the vault. Valid values are: all, get, list, set, delete, backup, restore, recover, and purge.'
  }
}

param sercertNameSQLsa string = 'superSecretPassword'
param sercertValueSQLsa string {
  default:'GkiVkXRPl9OyL8LCmTFKDeHKutKFV6wKE7BCrxleipR5NsbEWiTGT5Z98LEv7lGL'
  secure: true
}

resource adf1 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: 'adf${vProjectName}'
  location: vLocation
  identity: {
    type: 'SystemAssigned'
  }
}

//  Storage Account
resource sa1 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: 'sa${vProjectName}'
  location: vLocation
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

resource c1 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01'={
  name: '${sa1.name}/default/dwh' 
}

// Key Vault
resource kv1 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: 'kv${vProjectName}'
  location: vLocation
  properties: {
    tenantId: subscription().tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
    accessPolicies: [
      {
        objectId: adf1.identity.principalId
        tenantId: subscription().tenantId
        permissions: {
          keys: keysPermissions
          secrets: secretsPermissions
        }
      }
    ]
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}


resource kvs1 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${kv1.name}/${sercertNameSQLsa}'
  properties: {
    value: sercertValueSQLsa
  }
}



// SQL Server

resource sqls 'Microsoft.Sql/servers@2014-04-01' = {
  name: 'sqls${vProjectName}'
  location: vLocation
  properties: {
    administratorLogin: 'SDCAdmin'
    administratorLoginPassword: sercertValueSQLsa
  }
}

resource sqldb1 'Microsoft.Sql/servers/databases@2020-08-01-preview' = {
  name: '${sqls.name}/awlt'
  location: vLocation
  sku: {
    name: 'GP_S_Gen5_1'
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 1073741824
    sampleName: 'AdventureWorksLT'
  }
}

resource sqldb2 'Microsoft.Sql/servers/databases@2020-08-01-preview' = {
  name: '${sqls.name}/dwh'
  location: vLocation
  sku: {
    name: 'GP_S_Gen5_1'
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 1073741824
  }
}
