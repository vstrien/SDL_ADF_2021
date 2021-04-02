# Inrichten van Azure DevOps voor ADF

Wide World Importers is momenteel bezig met het verplaatsen van hun systemen naar Microsoft Azure. Als onderdeel daarvan willen ze graag gebruik gaan maken van Azure Data Factory. Het data-team heeft recent in een demo gezien dat dit erg eenvoudig moest zijn, en wil daarom kijken of dit aan de praat te krijgen is.

Om dit voor elkaar te krijgen, volgt hier een globaal stappenplan:

* Maak een lege Data Factory aan. Dit wordt je Development-ADF
  * Naam bijvoorbeeld: `initialen-wwi-adf-d` (dus voor Koos van Strien: `kvs-wwi-adf-d`)
  * Koppel hier een Azure DevOps Repository aan
  * Cruciaal is dat je geen bestaande Data Factory neemt! Je wilt namelijk uitzoeken hoe je CI/CD wilt inrichten, en met een bestaande ADF krijg je in één klap heel veel randzaken zoals verbindingen met bestaande Linked Services. Die wil je liever stapsgewijs introduceren - kleine stapjes!
* Maak er een minimale ADF-instantie van:
  * Voeg één pipeline toe
  * Daarin één activity (copy data)
  * Laat de copy data-activity een bestand kopiëren van container/filesystem `ingest` naar container/filesystem `stg` op je Data Lake
  * Het maakt niet uit welk bestand het is - je kunt bijvoorbeeld het bestand [movies.csv](./movies.csv) hiervoor gebruiken. Upload deze in je Data Lake, in het filesystem `ingest`
* Sla deze op en publiceer de pipeline

Alle resources tot nu toe (ADF en Data Lake) waren je *development*-omgeving.

* Maak nu een nieuwe ADF-instantie aan voor je Test
  * Naam bijvoorbeeld: `initialen-wwi-adf-t`
  * Koppel hier GEEN Azure DevOps Repository aan
* Maak ook een tweede Data Lake aan (een "test-datalake")

Je hebt nu zowel je test als je ontwikkelomgeving staan. Uiteraard zou het aanmaken van deze omgevingen ook geautomatiseerd kunnen worden als onderdeel van je CI/CD-pipeline, maar we nemen kleine stapjes :-).

* Zet nu in de `adf_publish` branch een bestand met de naam `pipeline.yaml`. Hier kun je onderstaande tekst in zetten:

```yaml
# Deze pipeline moet automatisch worden uitgevoerd als er een commit plaatsvindt in de adf_publish branch 
trigger:
 branches:
   include:
     - adf_publish
 batch: true # Betekent: Als deze pipeline draait, en er komen drie achtereenvolgende nieuwe commits, hoef je alleen de laatste uit te voeren

stages:
# We hebben geen "echte" build stage, maar zetten in de build stage wel de *artifact* klaar.
# Dit is het "onveranderbare blokje" dat we door de release heen zullen gebruiken
- stage: CreateArtifact
  jobs:
    - job: CreateArtifact
      steps:
      - task: CopyFiles@2
        name: CopyADFArtifact
        inputs:
          SourceFolder: $(Pipeline.Workspace)/s/VUL_HIER_JE_DATAFACTORY_NAAM_IN
          TargetFolder: '$(build.artifactstagingdirectory)'

      - task: PublishPipelineArtifact@1
        inputs:
          targetPath: '$(build.artifactstagingdirectory)'
          artifact: 'drop'
          publishLocation: 'pipeline'

# Hier gaat het gebeuren! We doen een 'release' naar test
- stage: DeployToTest
  jobs:
    - deployment: DeployToTest
      pool:
        vmImage: windows-latest
      environment: Test
      
      strategy:
        runOnce:
          deploy:
            steps:
            # Klik in je YAML-editor hieronder op het grijze woordje 'settings'
            # Je zult namelijk nog een verbinding met Azure moeten maken: Pay-as-you-Go (22e46556-ee7f-4060-a7dd-c92391e5f82a)
            # Als dit niet lukt, heb je wellicht niet de juiste rechten. Roep even de trainer erbij!
              - task: AzureResourceManagerTemplateDeployment@3
                inputs:
                  deploymentScope: 'Resource Group'
                  azureResourceManagerConnection: 'Visual Studio Enterprise Subscription – MPN(c0c63d97-638d-4327-986c-f3b4a5e18215)'
                  subscriptionId: 'c0c63d97-638d-4327-986c-f3b4a5e18215'
                  action: 'Create Or Update Resource Group'
                  # Let op: ook je resource Group aanpassen!
                  resourceGroupName: 'sdla2021adf-koos'
                  location: 'West Europe'
                  templateLocation: 'Linked artifact'
                  csmFile: '$(Pipeline.Workspace)/drop/ARMTemplateForFactory.json'
                  csmParametersFile: '$(Pipeline.Workspace)/drop/ARMTemplateParametersForFactory.json'
                  # .. en natuurlijk je Data Factory naam
                  overrideParameters: '-factoryName "datafactory-test-koos"'
                  deploymentMode: 'Incremental'
```

Bestudeer de comments in de bovenstaande pipeline goed (en volg ze op :-)). 

* Kijk of je een deployment aan de praat krijgt
* Als volgende stap: kijk of je een extra parameter kunt toevoegen.
  * In je Azure Repos staat een bestand met parameters (`ARMTemplateParametersForFactory.json`)
  * Hierin staan de beschikbare parameters
  * Kijk of het lukt om hier de gegevens van je Test-Data Lake in te voeren, zodat de verbinding daarmee gemaakt wordt

Wanneer je dit werkend hebt, kun je twee kanten op:

1. Je maakt een Library aan voor Test. Hierin neem je alle zaken op die specifiek zijn voor je test-deployment:
   * Resource group (meestal)
   * Data Factory naam
   * Niet-geheime gegevens zoals de link naar je Data Lake
   * Secrets mogen er ook in (zoals de key voor je Data Lake), die beveilig je met een "slotje" naast het invoerveld
   * Vervolgens gebruik je de Library als een Variable Group. Zie voor meer info [Microsoft Docs: Add & use Variable Groups](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups?view=azure-devops&tabs=yaml)
   * Als je nog een stap verder hierin wilt kun je ook twee Key Vaults bijhouden: één voor Dev (met daarin bijv. de key voor je dev-data lake), en één voor Test
     * Beide hebben dezelfde naamgeving voor secrets (dus beide hebben een secret met de naam "DataLakeKey"), maar de inhoud is specifiek voor de omgeving
     * Zie ook de eerder genoemde documentatie
   * Om je nieuwe aanpak te bewijzen, maak je nu een derde omgeving (Acceptatie) aan, waarin je de deployment ook doorvoert én de bijbehorende verbindingen wijzigt.
2. Je breidt je Dev-pipeline uit met nieuwe verbindingen, bijvoorbeeld naar een database. Zoek uit hoe je deze bij deployment netjes omhangt van je Dev-database naar een Test- en eventueel Acceptatie.

Zie ook het artikel op [Microsoft Docs: Continuous Integration and Delivery in Azure Data Factory](https://docs.microsoft.com/en-us/azure/data-factory/continuous-integration-deployment)