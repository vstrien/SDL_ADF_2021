# Linked Services

## Doel

Azure Data Factory heeft in de basis twee belangrijke taken in het data-landschap:

* Orchestratie (het aansturen van services)
* Data Movement (het kopiëren van data tussen je services)

Een *service* zoals hierboven twee keer benoemd, is in feite elke dienst die ADF kan aansturen of waar ADF data tussen kan kopiëren. Met andere woorden:

* SQL Databases
  * Als bron waar je data leest
  * Als doel waar je data wegschrijft
  * Als *compute engine* die je *stored procedures* laat uitvoeren
* Storage Accounts
  * Als bron waar je data leest
  * Als doel waar je data wegschrijft
* Key Vault
  * Als nette integratie om je wachtwoorden centraal in te beheren
* Etc.

De registratie van hoe er verbinding gemaakt kan worden met één van deze services heet een *Linked Service* - en die gaan we hier aanmaken.

## Opdracht

Open Azure Data Factory. Om Linked Services eenvoudig aan te maken gaan we naar het tabblad **Manage**, waar de Linked Services te vinden zijn.

Maak hier de volgende Linked Services aan: *let op de namen van linked services!!*

1. Linked service met storage account `ls_adls`
1. Linked service met KeyVault `ls_kv`

Voordat je nu verder gaat, zijn er twee zaken die geregeld moeten zijn:

* De zojuist geconfigureerde Linked Services (Storage account én KeyVault) moeten gepubliceerd zijn
* De Azure SQL Server in jouw resource group moet toestaan dat andere Azure Resources de server kunnen benaderen. Dit kun je instellen in de Azure Portal:
  * Open de resource group met alle informatie voor de ADF training
  * Open de databaseserver (`sqlssdla2021adf` gevolgd door je naam)
  * Selecteer aan de linkerzijde van het scherm **Firewalls and virtual networks**
  * Zet het schuifje bij **Allow Azure services and resources to access this server** op **Yes**

Nu kun je binnen ADF twee nieuwe Linked Services toevoegen naar je databases. Test de connectie voordat je ze aanmaakt.

3. Linked service met sql database `awlt` (noem deze `ls_sql_awlt`)
3. Linked service met SQL Database `dwh` (noem deze `ls_sql_dwh`)
   * User `SDCAdmin`
   * Wachtwoord uit Key Vault met secret `superSecretPassword`

Waar je eerder de Key Vault moest *publiceren*, hoef je dat bij een SQL Database momenteel niet. Ook Storage Accounts hoef je niet te publiceren in een Data Factory zonder versiebeheer.
