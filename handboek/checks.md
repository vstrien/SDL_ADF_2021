* Hoe verhoudt ETL zich tot het nieuwe paradigma van:
  * Connect & Collect (Ingest)
  * Transform & Enrich (Prep, Transform & Analyze)
  * Publish
  * Monitor
* Wat is het onderscheid tussen de vier componenten?
  * Linked Service
  * Activity
  * Pipeline
  * Data Set
* Wat is ...
  * Integration Runtime?
  * Parameters?
  * Control flow?
* Hoe zit Security?
  * RBAC-idee van Azure: duidelijk?
  * Heeft een *reader* voldoende rechten?
* Integration Runtimes

## De vier componenten van ADF

### Linked Service

Data Factory supports a wide variety of data sources that you can connect to through the creation of an object known as a **Linked Service**, which enables you to ingest the data from a data source in readiness to prepare the data for transformation and/or analysis. In addition, Linked Services can fire up compute services on demand. For example, you may have a requirement to start an on-demand HDInsight cluster for the purpose of just processing data through a Hive query. So Linked Services enables you to define data sources, or compute resource that is required to ingest and prepare data.

### Datasets

With the linked service defined, Azure Data Factory is made aware of the datasets that it should use through the creation of a **Datasets** object. Datasets represent data structures within the data store that is being referenced by the Linked Service object. Datasets can also be used by an ADF object known as an Activity.

### Activities & Pipeline

**Activities** typically contain the transformation logic or the analysis commands of the Azure Data Factory’s work. Activities includes the Copy Activity that can be used to ingest data from a variety of data sources. It can also include the Mapping Data Flow to perform code-free data transformations. It can also include the execution of a stored procedure, Hive Query, or Pig script to transform the data. You can push data into a Machine Learning model to perform analysis. It is not uncommon for multiple activities to take place that may include transforming data using a SQL stored procedure and then perform analytics with Databricks. In this case, multiple activities can be logically grouped together with an object referred to as a **Pipeline**, and these can be scheduled to execute, or a trigger can be defined that determines when a pipeline execution needs to be kicked off. There are different types of triggers for different types of events.

## Control flow, parameters, integration runtime

### Control flow

Control flow is an orchestration of pipeline activities that includes chaining activities in a sequence, branching, defining parameters at the pipeline level, and passing arguments while invoking the pipeline on-demand or from a trigger. It also includes custom-state passing and looping containers, and For-each iterators.

### Parameters

Parameters are key-value pairs of read-only configuration.  Parameters are defined in the pipeline. The arguments for the defined parameters are passed during execution from the run context that was created by a trigger or a pipeline that was executed manually. Activities within the pipeline consume the parameter values.

### Integration Runtime

Azure Data Factory has an integration runtime that enables it to bridge between the activity and linked Services objects. It is referenced by the linked service, and provides the compute environment where the activity either runs on or gets dispatched from. This way, the activity can be performed in the region closest possible. There are three types of Integration Runtime, including Azure, Self-hosted, and Azure-SSIS.

## Security

### Welke rollen er zijn

* Azure Administrators (subscription level) mogen sowieso alles
* Om iets te kunnen doen in ADF moet je *contributor* of *owner* zijn
* Om child resources aan te maken en beheren via de portal te doen moet je *Data Factory Contributor* zijn *op resource-group niveau*
* Via PowerShell of de SDK is *contributor* voldoende.

### Data Factory Contributors

When you are added as a member of this role, you have the following permissions:

* Create, edit, and delete data factories and child resources including datasets, linked services, pipelines, triggers, and integration runtimes.
* Deploy Resource Manager templates. Resource Manager deployment is the deployment method used by Data Factory in the Azure portal.
* Manage App Insights alerts for a data factory.
* At the resource group level or above, lets users deploy Resource Manager template.
* Create support tickets.

## Integration Runtimes

### Wat een IR is

* activity defines the action to be performed.
* linked service defines a target data store or a compute service
* integration runtime provides the infrastructure for the activity and linked services

The *compute environment* where the activity either runs or gets dispatched from

Mogelijkheid om taken zo dicht mogelijk bij hun data store of compute store uit te voeren (locality)

Kortom, IR is de *compute infrastructure*. Geeft de volgende DI capabilities:

* **Data Flow** in een beheerde Azure compute omgeving
* **Data movement** copy data activity
* **Activity dispatch** dispatch & monitor externe compute services als:
  * Databricks
  * HDInsight
  * Machine Learning
  * SQL Database
  * SQL Server
  * etc.

Omdat *alle* uitvoer op *een machine* moet gebeuren, wordt er standaard een *default Integration Runtime* aangemaakt. Dit is de IR die gebruikt wordt wanneer de IR op *Auto-resolve* staat.

(laten zien in settings van ADF)

### Welke types IR er zijn

Drie types:

* Azure
* Self-hosted
* Azure-SSIS

*Self-hosted* en *Azure-SSIS* bieden ook de mogelijkheid om binnen een Private network te werken.

### Voorbeeld: Copy activity

Source en Sink linked services nodig voor de actie
* Wanneer twee cloud data sources:
  * Beide source & sink Azure gebruiken, dan ook de Azure IR
    * regionaal wat ik specificeer of
    * auto-resolve
  * source & sink = cloud & private (of vice versa)
    * één van beide op self-hosted IR -> dan copy op self-hosted IR
  * source & sink = private
    * dan de linked services van source & sink *moeten* ook dezelfde IR gebruiken
    * deze IR wordt ook gebruikt door de Copy activity

