# stg loop 

## Doel
Doel van de opdracht is om deze handmatige actie om te zetten naar een for loop.

## Opdracht

- Maak een dataset ```ds_awlt```
    - Voeg hier twee parameters aan toe 
        1. schema
        2. tabel
    - Zorg er voor dat bij connections op de plek van table dat daar de parameters worden toegepast schema en tabel 

- Maak een data set ```ds_adls_awlt```
    - maak bij deze een parameter ```filename```
    - vul bij file system ```stg```
    - vul bij Directory ```awlt```
    - vul bij file ```parameter filename```

- Maak een generieke pipeline voor het ophalen van de tabellen in AWLT  ```pl_awlt_adls_object```
    - voeg een parameter toe aan de pipeline
        1. schema 
        2. tabel
    - plaats een copydata op het canvas ```cd_alwt_stg```
    - selecteer bij de srouce de dataset dat we net aangemaakt hebben en geeft de paremeters van de pipeline door aan de dataset.

- Maak een nieuwe pipeline ``` pl_awlt_stg```
    - voeg een loopup activiteit toe
        - laat de lookup een een Query uitvoeren 
``` sql
select 
	o.name
from 
	sys.objects o
	inner join sys.schemas s
		on o.schema_id = s.schema_id
where 1=1
and o.[type] = 'U'
and s.name = 'SalesLT' 

```

- voeg een ForEach toe aan het canvas
    - Laat deze foreach lopen over de output van de lookupt.
    - Klik de activiteit in de foreach open. 
        - voeg hier een execute pipeline toe ```pl_awlt_adls_object``` een geef deze de juiste parameters mee voor het uitvoeren van de pipeline.
