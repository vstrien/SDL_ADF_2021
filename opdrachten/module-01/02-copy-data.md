# CopyData Customer

## Doel
Doel van deze opdracht is het ophalen van de tabel Customer uit de awlt database en naar data lake te kopieren.

## Opdracht

Maak een Data set ```ds_awlt_Customer``` 
- Kies azure sql database
- Selecteer de linked sevices naar ```ls_sql_awlt```
- Selecteer de table ```Customer```

Maak een Data Set ```ds_adls_awlt_Customer```
- Kies Azure Data Lake Storage Gen2
- Kies format ```Parquet```
- Kies linkes Services ```ls_adls```
- Vul in File path ```stg```


Maak pipeline ```pl_alwt_adls_Customer```

1. Plaats een copy data activiteit op het canvas
2. Configureer in de Srouces tab de data set Customer uit awlt
3. Confirugeeer in de Sink tab de data set van Costomer naar adls

* Gebruik Debug om de pipeline uit te voeren.

## Debug de pipeline

Contoleer of de er een bestand is bij gekomen in data adls container.