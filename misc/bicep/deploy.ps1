#Clear-Host
$file = 'main'
bicep build ./$file.bicep # generates main.json
#22e46556-ee7f-4060-a7dd-c92391e5f82a

#bicep build ./main.bicep # generates main.json

#$password = ($file | Format-Hex).GetHashCode().ToString() + '-' + ("$", "^", "@" | Get-Random).ToString() + '-' + $file+ '-' + ($file | Format-Hex).GetHashCode()*1299
#$password = ConvertFrom-SecureString -SecureString $password

#$var_User = 'rik'
#$var_User = 'anissa'
#$var_User = 'arjan'
#$var_User = 'bavo'
#$var_User = 'luuk'
#$var_User = 'alexander'
$var_User = 'koos'

$rgName = 'sdla2021adf-'+$var_User
New-AzResourceGroup -Name $rgName  -Location westeurope 


$rgName 
$deploy = New-AzResourceGroupDeployment -TemplateFile ./$file.json -ResourceGroupName $rgName -pUser $var_User #-pEnv $var_Env #-sercertValueSQLsa $password
$deploy
write-host $deploy.ProvisioningState

<#
Remove-AzResourceGroup -name SDC_PCPronk_Bicep



//Celan up soft deletede kvs
$vault = Get-AzKeyVault -InRemovedState
$vault[0]
Remove-AzKeyVault -VaultName kvsdla2021adfppronk -InRemovedState -Location westEurope

#>