# CopyData Customer

## Doel
Doel van deze opdracht is het ophalen van de tabel Customer uit de awlt database en naar data lake te kopieren maar dan met eeen delta.

## Opdracht

Maak een clone van pipeline ```pl_awlt_adls_object``` en noem deze ```pl_awlt_stg_object```.

1. voeg een parameter toe aan de pipeline, ```strategy``` met als default ```Delta```
2. Doe een data analyse op de bron tabel en onderzoek welke kolumn gebruikt kan worden voor het bepalen van de delta. Maar een query waarmee je deze delta kunen op halen.
3. gebruik de parameter of een keuze te maken voor het de betreffende laat stratigy Full of Delta. Gebruik een ```If Condition``` activieit
    * bij de **Expression** maak een check en controleer of de pipeline een Full load moet uitvoeren op basis van de parameter van de pipeline.
    * By de true activities. plak daar dezelfde copydata activiteit uit ```pl_awlt_adls_object``` rename ```cd_alwt_adls_full``` 
    * ga terug en klik op de false activieis, plak daar dezelfde copydaat activiteit uit ```pl_awlt_adls_object```. Hernoem deze naa ```cd_awlt_adls_delta```. Bij deze copydate configureeren we de *Use query* Deze zetten we op Query. In het Query veld moet een  dynamic content content geplaats worden met de query uit de volgende stap, maar in de query moet de schema en tabel naam dynamische gekozen kunnen worden uit de parameters van de pipeline.
4.  Pas in pipeline in de foreach de execution pipeline aan naar de nieuwe pipeline en geef *Delta* Als default strategy paramter.

# Simulatie
Voor het simuleren van de delta zullen we in deze sample set de data moeten updaten.
Hier onder staan twee sets querys. Voor de eerste set uit en laat de pipeline in delta draaien.

```sql

UPDATE   [SalesLT].[Customer]
SET [Suffix] = NULL
, ModifiedDate = DATEADD(MONTH, -3 ,GETDATE())
WHERE [CustomerID] = 12

```

> Hoeveel recoorde worden er nu opgehaald?

Voer nu de volgende set querys uit. Laat vervolgens de pipeline weer in delta draaien.

```sql
UPDATE   [SalesLT].[Customer]
SET [Suffix] = 'Jr.'
, ModifiedDate = GETDATE()
WHERE [CustomerID] = 12
```

> Hoeveel recoorde worden er nu opgehaald?
