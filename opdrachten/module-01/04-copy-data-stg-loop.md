# Lab: data laden met behulp van een for loop

## Doel

In het vorige lab hebben we handmatig data geladen in ons Data Lake. Maar na de zoveelste identieke pipeline vraag je je toch af: kan dat niet geautomatiseerd?

In dit lab gaan we deze handmatige actie daarom veranderen in een geautomatiseerde. Daar gebruiken we een *for loop* voor.

## Opdracht

1. Maak een nieuwe dataset met de naam `ds_awlt`
   * Type: SQL Database
   * Linked Service: `ls_sql_awlt`
   * Laat **Table Name** leeg
1. Voeg aan deze nieuwe dataset twee *parameters* toe
   * Dit doe je in het tabblad **Parameters**
   * Voeg de volgende parameters toe:
     * schema (type: String)
     * tabel (type: String)
   * Vink nu op het tabblad **Connection**, bij **Table** de instelling **Edit** aan
     * Dit geeft je de mogelijkheid om het schema en de tabelnaam in te vullen, of dynamisch te maken
     * Zodra je op één van de vakjes klikt, zie je de blauwe tekst **Add Dynamic Content [Alt+P]** verschijnen.
     * Zorg ervoor dat de parameters voor `schema` en `tabel` hier worden toegepast

![Zodra je op een vakje klikt, zie je "Add Dynamic Content"](./img/edit-table.png)

3. Maak een tweede dataset met de naam `ds_adls_awlt`
   * Type: Azure Blob Storage
   * Format: Parquet
   * Linked Service: `ls_adls`
   * File system / Container: `stg`
   * Directory: `awlt`
   * Importeer nu geen schema
3. Als de dataset is aangemaakt, kun je ook hier parameters aan toevoegen.
   * Voeg een parameter met de naam `filename` toe
   * Gebruik deze in je **File Path** instelling voor het laatste component (de filename dus)
3. Publiceer de datasets


![File Path zoals het moet worden](img/filename-parameter.png)

We hebben nu twee datasets gemaakt die niet aan één bestand of tabel gekoppeld zijn, maar die hun tabellen en bestanden *dynamisch* beschikbaar hebben. Een goed gebruik is om deze taak (het kopiëren) ook in een pipeline te gieten die in zichzelf parameters heeft: net als de dataset een "schema", "tabel" en "filename" had, zal deze pipeline ook twee parameters hebben - en deze gebruiken om ervoor te zorgen dat de bestanden uniform op het Data Lake terecht komen.

6. Maak een nieuwe pipeline met de naam `pl_awlt_adls_object`
   * Geef deze pipeline twee parameters:
     * schema
     * tabel
   * Voeg een **Copy Data** activity toe
     * Naam: `cd_alwt_adls`
     * Source dataset: `ds_awlt`
       * Configureer de parameters van de source dataset nu zo, dat ze de gelijknamige parameters uit de pipeline overnemen
     * Sink dataset: `ds_adsls_awlt`
       * Geef de parameter **filename** van de sink dataset een bestandsnaam die als volgt is opgebouwd:
       * `(schemanaam).(tabelnaam).parquet`
       * Je kunt dit oplossen met *dynamic content* (hint: kijk eens bij de [string functions van de Data Factory expressions](https://docs.microsoft.com/en-us/azure/data-factory/control-flow-expression-language-functions#string-functions))

> ## Expression Language
>
> De expressie-taal die je zojuist gebruikt hebt, is een relatief eenvoudig JSON-gebaseerd taaltje waarmee in diverse Microsoft-producten dynamische waarden kunnen worden toegevoegd. Naast Data Factory kom je het ook bijvoorbeeld tegen in [Logic Apps en Power Automate](https://docs.microsoft.com/en-us/azure/logic-apps/workflow-definition-language-functions-reference).

We hebben nu een dynamische pipeline gemaakt: zolang we aan deze pipeline vertellen wat de staging- en tabelnaam zijn, zorgt de pipeline ervoor dat er een nette export wordt neergezet op de juiste plek. Met dat onderdeel gebouwd kunnen we een stapje hoger gaan kijken: kunnen we deze pipeline nu automatisch aanroepen voor een dataset met staging- en tabelnamen?

Om dat voor elkaar te krijgen zullen we twee zogenaamde *system tables* uitvragen uit SQL Database: 

* `sys.objects` bevat alle objecten (tabellen, procedures, etc.) in een database
* `sys.schemas` bevat de namen van schemas

7. Maak een nieuwe pipeline, met de naam `pl_awlt_stg`
8. Voeg in deze pipeline een Lookup activity toe
   * Naam: `lkp_all_tables`
   * Source Dataset (onder het tabje Settings): `ds_awlt`
   * Use Query: **Query**
   * Query:

```sql
select 
    o.name AS table_name
    , s.name AS schema_name
from 
    sys.objects o
    inner join sys.schemas s
    on o.schema_id = s.schema_id
where 
    o.[type] = 'U'
    and s.name <> 'dbo'
```

9. Klik nu op **Validate** om de pipeline te valideren.
   * Welke meldingen krijg je?
   * Waarom krijg je deze?

We hebben zojuist de **Dataset** gebruikt die ons een lijstje met tabellen aanlevert. De dataset die de verbinding levert die we nodig hebben (`ds_awlt`, die verbindt met SQL Database) hebben we echter uitgevoerd met *parameters*. Deze parameters gebruiken we normaal gesproken om aan een specifieke schema en tabel te refereren. Maar nu dus niet!

Om dit op te lossen zijn er twee opties:

* Optie 1: We vullen een onzin-waarde in bij de parameters, bijvoorbeeld `FULL`. We gebruiken de parameter namelijk toch niet
* Optie 2: We maken een aparte dataset aan, zónder parameters, specifiek voor het uitvragen van de benodigde tabellen. We zouden deze dataset kunnen laten definiëren door de bovenstaande query

Kies zelf welke optie je hier het netst vindt: beide opties zijn mogelijk.

- voeg een ForEach toe aan het canvas
    - Laat deze foreach lopen over de output van de lookup.
    - Klik de activiteit in de foreach open. 
        - voeg hier een execute pipeline toe ```pl_awlt_adls_object``` een geef deze de juiste foreach item as parameters mee voor het uitvoeren van de pipeline.
