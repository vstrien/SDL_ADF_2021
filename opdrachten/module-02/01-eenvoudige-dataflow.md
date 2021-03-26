# Lab: Eenvoudige dataflow

In dit lab gaan we de Data Flow functionaliteit van Azure Data Factory zelf ervaren. Het doel is met name om alle componenten om de Data Flow heen een keer goed op het netvlies te hebben.

Zorg er daarom voor dat de volgende zaken ingericht worden:

* Een nieuwe Data Flow, met daarin:
  * Als source: het bestand `SalesLT.Product.parquet` op je Data Lake (container `stg`, map `awlt`)
  * Er moet een extra kolom met ranking bijkomen, waarin aangegeven wordt welke productcategorie in totaal de meeste producten heeft.
    * Als productcategorie volstaat voor nu `ProductCategoryID` (er hoeft geen koppeling gemaakt naar tabel ProductCategory)
    * Maak het jezelf niet te moeilijk, denk in kleine stapjes (hint: wat moet je weten voordat je de ranking kunt doen?)
    * Gebruik de Data preview om te kijken of je in de goede richting werkt.
  * Alleen de producten in de grootste drie productcategorieën moeten weggeschreven worden
    * Schrijf het resultaat weg op twee plaatsen:
      * In je Data Lake (container `bronze`, map `analysis`, bestand `productcategories.parquet`)
      * In je SQL Database (`dwh`). Laat een tabel aan met de naam `dbo.product_verrijkt` aanmaken door je **Sink** destination.
* Maak een bijbehorende pipeline die deze Data Flow ook uitvoert
* Publiceer alle resources, en test de pipeline

