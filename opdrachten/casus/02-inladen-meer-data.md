# Inlezen in Data Factory, verkennen van nieuwe functionaliteit

Er zijn binnen Wide World Importers talloze verzoeken binnengekomen om te testen. Meer dan we vandaag kunnen uitproberen. Daarom een keuzemenu:

* Lift and Shift van SSIS (SSIS naar de cloud)
* Nested JSON met arrays ontsluiten
* Vertalen van SSIS naar ADF
* Web services ontsluiten

Lees de opdrachten hieronder door, en bepaal zelf wat je het meest interessant vindt.
Voor de onderdelen met SSIS heb je Visual Studio (SQL Server Data Tools) en SQL Server Management Studio nodig.

## Lift and Shift van SSIS

Lift & Shift is een term die veel gebruikt wordt om bestaande workloads zoveel mogelijk "as-is" over te brengen naar een cloud-omgeving. Zonder dat het systeem van de grond af aan opnieuw opgebouwd hoeft te worden, heb je dan voordelen van de cloud als:

* Uitgebreide performance-metrics (waar zit de bottleneck?)
* Schaalbaarheid ("doe mij even een grotere server")
* Betalen naar gebruik
* Backups en beveiliging

Vanuit beheer wordt er daarom met veel interesse in deze richting gekeken.
De vraag is nu: kunnen we onze bestaande SSIS packges eenvoudig migreren naar ADF?

Er draait inmiddels al een kopie van onze brondatabase in de cloud:

* Server: `sqlssdla2021adfkoos.database.windows.net`
* Username: `SDCAdmin`
* Password: `GkiVkXRPl9OyL8LCmTFKDeHKutKFV6wKE7BCrxleipR5NsbEWiTGT5Z98LEv7lGL`
* Database: WideWorldImporters

Om elkaar niet in de weg te zitten, zul je daarnaast een kopie van het Wide World Importers DW op je eigen Azure SQL Server neerzetten. Het stappenplan hiervoor staat op [Install & configure DW WideWorldImporters sample database](https://docs.microsoft.com/en-us/sql/samples/wide-world-importers-dw-install-configure?view=sql-server-ver15#download). (Overigens suggereert de pagina dat het hier over Synapse zou gaan, maar alle instructies gaan over Azure SQL Database).

Tevens hebben de ETL-ontwikkelaars hun `ispac` (de artifact van de laatste SSIS-ontwikkeling) klaargezet. Meer informatie hierover is te vinden op [Microsoft Docs: WideWOrldImportersDW ETL Workflow](https://docs.microsoft.com/en-us/sql/samples/wide-world-importers-perform-etl?view=sql-server-ver15). Voor bronbestanden kun je ook kijken naar [GitHub: WideWOrldImporters Sample Database for SQL Server and Azure SQL Database](https://github.com/Microsoft/sql-server-samples/tree/master/samples/databases/wide-world-importers)

Het doel is nu eenvoudig: het ETL-project moet in de cloud terecht komen. Niet IaaS (dus geen VM inrichten en daarop draaien), maar PaaS (je doet de deployment naar een SSIS-IR in Azure Data Factory).

Zie voor meer informatie ook [Deploy and run SSIS Packges in Azure](https://docs.microsoft.com/en-us/sql/integration-services/lift-shift/ssis-azure-lift-shift-ssis-packages-overview?view=sql-server-ver15)

## Nested JSON met Arrays ontsluiten

We hebben eerder deze week al een JSON-bestand ontsloten. Dat was een eenvoudig JSON-bestand: er zat weliswaar een *nesting* in, maar elk order kon altijd maar één OrderDetail bevatten:

```json
[
    {
        "salesOrderID": 43659,
        "customerID": 29825,
        "salesPersonID": 279,
        "orderDate": "2011-05-31T00:00:00",
        "dueDate": "2011-06-12T00:00:00",
        "shippedDate": "2011-06-07T00:00:00",
        "shipVia": 5,
        "freight": 616.0984,
        "shipAddress": {
            "street": "42525 Austell Road",
            "city": "Austell",
            "state": "GA ",
            "postalCode": "30106",
            "country": "US"
        },
        "details": { // <-- Een "{" is een object - er kan maar één detail in zitten
            "productID": 776,
            "unitPrice": 2024.9940,
            "quantity": 1,
            "discount": 0.0000
        }
    }
//  (...)
]
```

Dit voorbeeld heeft ons Data Engineering-team ook gezien, maar het blijkt dat sommige API's nog complexere data aanbieden, waarbij er meerdere "detail"-regels onder een order vallen (wanneer je een bestelling doet, kunnen er meerdere producten inzitten, dus meerdere orderregels). Hieronder een voorbeeld van die grotere order-json:

```json
{
    "orders": [
        {
            "Order": {
                "SalesOrderID": 71774,
                "RevisionNumber": 2,
//              (...)
                "ModifiedDate": "2008-06-08T00:00:00",
                "OrderDetails": [ // <-- een blokhaak "[" geeft aan dat er een lijst volgt met meerdere objecten. Meerdere orderregels dus in dit geval
                    { // Orderregel 1
                        "OrderQty": 1,
                        "ProductID": 836,
                        "UnitPrice": 356.8980,
                        "UnitPriceDiscount": 0.0000,
                        "LineTotal": 356.898000,
                        "rowguid": "E3A1994C-7A68-4CE8-96A3-77FDD3BBD730",
                        "ModifiedDate": "2008-06-01T00:00:00"
                    },
                    { // Orderregel 2
                        "OrderQty": 1,
                        "ProductID": 822,
                        "UnitPrice": 356.8980,
                        "UnitPriceDiscount": 0.0000,
                        "LineTotal": 356.898000,
                        "rowguid": "5C77F557-FDB6-43BA-90B9-9A7AEC55CA32",
                        "ModifiedDate": "2008-06-01T00:00:00"
                    }
                ]
            }
        },
// (...)
    ]
}
```

De vraag is nu: kunnen we deze data ook correct inladen, naar twee verschillende tabellen?

1. Tabel "OrderHeader", met daarin alle order-gegevens
2. Tabel "OrderDeail", met daarin de details (van `OrderQty` t/m `ModifiedDate`, maar óók `SalesOrderID`)

Upload het bestand [orders.json](./orders.json) naar je Data Lake, en zorg ervoor dat de data in een database terecht komt.

## Vertalen van SSIS naar ADF

Het ETL-team heeft een bestaande SSIS-oplossing staan op [GitHub: ETL Process for WideWorldImporters](https://github.com/microsoft/sql-server-samples/tree/master/samples/databases/wide-world-importers/wwi-ssis). Dit is een oplossing die werkt, maar die niet helemaal volgens de ontwikkelstandaarden is.

De vraag is of we dit kunnen vertalen naar een Azure Data Factory "native" manier.
Daarnaast wil men graag weten of het haalbaar is om de huidige Type 2 Slowly Changing Dimensions (met "ValidFrom" en "ValidTo") direct te gaan vullen vanuit ADF. Met het oog op toekomstige Data Lineage wil de afdeling Data Management namelijk verkennen of dit een haalbare strategie is. Momenteel gebeurt dit in de stored procedures binnen WideWorldImportersDW. Dit is een procedure die naar behoren werkt, maar waarmee

Er draait inmiddels al een kopie van onze brondatabase in de cloud:

* Server: `sqlssdla2021adfkoos.database.windows.net`
* Username: `SDCAdmin`
* Password: `GkiVkXRPl9OyL8LCmTFKDeHKutKFV6wKE7BCrxleipR5NsbEWiTGT5Z98LEv7lGL`
* Database: WideWorldImporters

Om elkaar niet in de weg te zitten, zul je daarnaast een kopie van het Wide World Importers DW op je eigen Azure SQL Server neerzetten. Het stappenplan hiervoor staat op [Install & configure DW WideWorldImporters sample database](https://docs.microsoft.com/en-us/sql/samples/wide-world-importers-dw-install-configure?view=sql-server-ver15#download). (Overigens suggereert de pagina dat het hier over Synapse zou gaan, maar alle instructies gaan over Azure SQL Database).

Deze nieuwe database wordt het doel waar je heen gaat schrijven.

Tip hier: begin klein! Breng zaken eerst naar Staging, niet direct naar het dimensionele model.

## Web services ontsluiten

Onder de nieuwe zaken die uitgezocht moeten worden, is ook het eenvoudig ontsluiten van webservices.
Voordat we dat met onze productiesystemen gaan proberen, is de vraag eerst of dit überhaupt handig kan in ADF.

Daarom willen we als test een ontsluiting doen van de [Buienradar JSON feed](https://data.buienradar.nl/2.0/feed/json)

Probeer deze data direct te ontsluiten en in te laden richting je Data Lake.
