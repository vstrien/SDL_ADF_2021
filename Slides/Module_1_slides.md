---
marp: true
theme: sdl-theme
header: ![image](https://sigmadatalearning.nl/wp-content/uploads/2020/06/sigmadatalearninglogo-300x77.jpg) 
footer: 2021 | [Sigma Data Learning](https://www.sigmadatalearning.nl)

---
<!-- paginate: false -->

#  Azure data Factory
## Sigma Data Academy 2021

---
<!-- paginate: true -->


# Introductie
* Wie ben je?
* Wat is je achtergrond/ervaring ELT?
* Wat verwacht je van de training?
---
# Training tot nu tot?

- Breakout rooms? werkt dat goed voor jullie?
- Zijn en nog vast moment dat iemand even weg moet?

--- 
# Module 1
* Voorbereiding
* ETL
* Wat is Azure Dafa Factory (ADF)
* ADF onderdelen

---
#  Voorbereiding
- Azure Portal
- Github of Azure Devops repository
- SQL Server Firewall
	- Azure Services
	- Home IPAdres
- KeyVault - Access policies ADF / User


---
#  Data van A naar B
Wat doen we eigenlijk met ETL
Waar in de architectuur zijn we bezig.

---
![image](https://docs.microsoft.com/en-us/azure/architecture/solution-ideas/media/modern-data-warehouse.png)

---
![image](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/data/images/enterprise-bi-adf.png)

---
# ETL vs ELT
* Wat is ETL vs ELT?
<!--
	> **Vraag**: Wat is het verschil?
-->
* Waarom ETL?
<!--
	> **Opdracht**: Onderzoek waarom ETL?
-->

---
# ETL vs ELT
* Waarom ETL?
	* Organisatie breed
	* Beheerbaarheid
	* Perfomance
	* Automatiseren van de dataflow
---

# Azure Dafa Factory (ADF)
* ADF		<!--	* > **Docs**: https://docs.microsoft.com/en-us/azure/data-factory/introduction-->
* Interface
	* > **URL**: https://adf.azure.com/
* Documentatie
	* > **Docs**: https://docs.microsoft.com/en-us/azure/data-factory

---
# Link Services
* Type verbinding
* Authentication
* Authorization 

---
# Get started with ADF Project
* Git
> **Opdracht:** Configuratie

---
# Project Links Services

> **Opdracht**:  Maken van een Linked Services naar:
> * Key Vault
> * Storage Containter
> * Database

https://github.com/pcpronk/SDL_ADF_2021/blob/main/Opdrachten/linked_services.md

---
# Pipelines

![image](https://docs.microsoft.com/en-us/azure/data-factory/media/concepts-datasets-linked-services/relationship-between-data-factory-entities.png)

---
# Pipelines
* Activiteiten 
	* data movement activities
	* data transformation activities
	* control activities
* Control flow 
	* Status van een activiteit
* Parameters & Variables

---
# Data Set	
* Wat is een data set
* Hoe op te zetten
* Kolommen & Data types
* Maken van een Data set
* Parameters

---
# Opdrachten
> Bron > Datalake (CopyDate)	
We gaan verder door een tabel Customer uit een database AdventureWorksLite (awlt) op te halen en te kopieren naar ADLS. Het bestands type in ADLS is parquet.

---

# Integration runtime	
*	Waar draait het dan
	* Best effort voor Locatie
* Drie spaken
	* Azure
	* Self-hosted
	* Azure-SSIS


---
# Update 
Lookup query en paramaters aansturing.


--- 
# Opdracht
Delta laden van de bron.


--- 
# Opdracht
Laden data van ADLS > STG


---
# Execution & Triggers
* Onces
* Schedule trigger
* Tumbling window trigger
* Event-based trigger

> **Docs**: https://docs.microsoft.com/en-us/azure/data-factory/concepts-pipeline-execution-triggers
---
# Monitoring/ Logging	

---
# Recap Module 1
* Wat is er allemaal besproken.
* Zijn er nog vragen?
---

# Traning

Zijn er nog ding dat je graag anders zou willen zien in deze training?
Gaat het snel of langzaam?
Genoeg pauze?

