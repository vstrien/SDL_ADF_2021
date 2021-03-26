# Lab: Data integratie flow

In het vorige lab hebben we de context neergezet voor een "eenvoudige" (qua structuur) dataflow. We gaan deze kennis nu gebruiken om meerdere bronnen te integreren.
We gaan nu met een iets grotere database aan de slag, waarin we een meer typische Data Warehouse-aanpak nemen.

Je zult voor deze data integratie flow meerdere componenten moeten laten samenkomen:

* ontsluiting van een brondatabase naar het Data Lake
  * server: `sqlssdla2021adfkoos.database.windows.net`
  * login: `SDCAdmin`
  * password: `GkiVkXRPl9OyL8LCmTFKDeHKutKFV6wKE7BCrxleipR5NsbEWiTGT5Z98LEv7lGL`
  * database: `AdventureWorks2019`
  * zet deze data in de `ingest` container
* Laden van het Data Lake naar het Data Warehouse
  * Als start: alleen dim_product. Combineer deze op basis van drie achterliggende tabellen die je in het Data Lake hebt (zie tabel hieronder)
  * Zorg ervoor dat er een nieuwe *dimensiesleutel* wordt gegenereerd (`Dim_Product_ID`). De oorspronkelijke sleutel hernoem je naar `ProductAlternateKey`

| Tabel in DW | Achterliggende tabellen       |
|-------------|-------------------------------|
| Dim_Product | production.ProductCategory    |
|             | production.ProductSubcategory |
|             | production.Product            |

* Als vervolg: laad ook fact_sale. Deze is gebaseerd op `sales.SalesOrderDetail` gecombineerd met `sales.SalesOrderHeader`
  * Zorg ervoor dat er een extra kolom komt met een verwijzing naar `Dim_Product_Id`, en dat deze voor elke rij correct gevuld is
  * Neem alleen nuttige kolommen mee (vuistregel: meetwaarden, datums en verwijzingen naar dimensies)

## Extra uitdaging

Let op! Deze opgaven zijn niet per sé voor iedereen. Je kunt ze los van elkaar uitvoeren, en allemaal bieden ze een extra uitdaging

* Elke *ingest* moet in een eigen map met timestamp terechtkomen (bijv. 2021-03-26-13-44-03)
  * Bedenk goed waar dit allemaal impact heeft
  * Kun je een manier bedenken waarop je eenvoudig een specifieke datum kunt inlezen?
* Wanneer je data nu twee keer inlaadt, gaan er twee dingen mis:
  1. ADF maakt twee keer dezelfde dimensiesleutels aan (want begint elke keer weer bij 1 te tellen)
  2. ADF probeert data dubbel in te laden (want doet geen check op welke data er al of niet is)
* Probeer een manier te bedenken om beide gevallen op te lossen.

* maak een kleine Synapse SQL Pool-omgeving (DW100c), en zorg dat de data daar in het Data Warehouse terecht komt