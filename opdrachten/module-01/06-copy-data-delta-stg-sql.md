# Doel
Doel van deze opdracht is om de bron data uit parquet ook naar een staging table op de dwh database te kopieren.

# Opdracht

 -   Maak een nieuwe data set ```ds_dwh_stg```
    - Link deze naar ls_sql_dwh
    - Geen geen table name op en import schama kan op None blijven.
    - Voer twee parameters toe
        1 schema
        2 table
    - gebruik de parameters om de tabel en schema in te zullen op tab connection.

- Ga naar je dwh database en maak de volgende schema aan.
```sql 
CREATE SCHEMA stg
```

Gaan naar pipeline 
-    Ga naar je naar de True Activities
    - plaats achter *cd_alwt_adls* nog een copy data activitie met als naam ```cd_adls_stg_full```
    - configureer de source zodat het de parquet file op pakt dat met cd_alwt_adls gemaakt is.
    - configureer de Sink gebruik de data set dat we net gemaakt hebben.
        - gebruik hier schema 'stg'
        - voor parameter table concat de pipeline parameters schema en table aan elkaar zodat de table naam er bijvoorbeeld so uit ziet. ```SalesLT_Customer```
        - Nu mag ook Auto create table aan gezet worden.
 
 -  Kopieer cd_adls_stg en plaats deze ook in de False Activiteit. ```cd_adls_stg_delta```


Voer de pipeline uit en controleer of je in het dwh nu ook stage tables krijgt. 