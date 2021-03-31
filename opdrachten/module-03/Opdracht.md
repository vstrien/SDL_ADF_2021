# Opdracht - module 3

We gaan opnieuw aan de slag met Azure Data Factory (verrassing!). We hebben deze keer een grotere diversiteit aan bronnen die ingeladen moet worden. We zijn een PoC aan het uitvoeren om te kijken of ADF een goede tool is om onze data processing in op te lossen.

Er zijn een aantal bronnen die we willen kunnen inladen:

* Verkopen (JSON)
* Informatie over personen (CSV)
* Sales quota (Excel)
* Informatie over producten (SQL Server Database - AW2019)

## Verkopen (JSON)

Centraal in ons proces staan de verkopen. Deze zijn geëxporteerd door ons bronsysteem in JSON-formaat.

Voor de PoC die we momenteel uitvoeren in ons team alleen geïnteresseerd of deze JSON ingeladen kan worden - dynamische velden, incrementeel laden etc. zijn hier even buiten beschouwing.

Wel is er overigens sprake van een geneste JSON: er zitten order-detailregels in de JSON verstopt.
Upload dit bestand ([orders-aw.json](./orders-aw.json)) in je Data Lake.

Bedenk in je aanpak wat de eerste stap is die je kunt doen, zonder dat je het voor jezelf direct te complex maakt!

## Informatie over personen (CSV)

De informatie over personen hebben we al op een Data Lake staan. Gelukkig komen de identifiers wel overeen, maar per wijzigingsdatum is een aparte map aangemaakt. Dat zijn dus zo'n 1283 mappen, die samengevoegd moeten worden.

Ook hier geldt: incrementeel laden is niet ons eerste probleem, het gaat er vooral om dat we al deze bestanden netjes in één dataset krijgen.

## Sales quota (Excel)

De controllers hebben daarnaast een sales target voor de verschillende verkopers aangeleverd. In Excel 💁‍♂️.

Deze sales quota horen bij de verkopers, én bij de regio's. Uiteindelijk zullen ze als een type 2 dimensie moeten worden ingeladen, maar de eerste zorg is om ze überhaupt in te laden.

## Informatie over producten (SQL Server Database - AW2019)

Ten slotte hebben we toegang gekregen tot een brondatabase - AdventureWorks2019.

* server: `sqlssdla2021adfkoos.database.windows.net`
* database: `AdventureWorks2019`
* login: `SDCAdmin`
* password: `GkiVkXRPl9OyL8LCmTFKDeHKutKFV6wKE7BCrxleipR5NsbEWiTGT5Z98LEv7lGL`

Uit deze database halen we de productinformatie: producten, categorieën en subcategorieën. Deze moeten in één product-dimensie samengevat gaan worden.

## Aanpak

We starten vandaag met een nieuwe Azure Data Factory, we bouwen dus niet verder in de Data waar we eerder in werkten
Verder is het belangrijk dat je eerst een globaal plan maakt, en een schets van hoe je oplossing eruit komt te zien. Bedenk daarbij:

* Welke technieken ga je inzetten op welke plek?
* Welke bron is het eenvoudigste? Pak deze eerst (dan heb je het raamwerk staan om verder te werken)
* Zijn er nog zaken die je nog niet weet? / moet uitzoeken?
* Wat moet je nog valideren qua technische werking? Hoe doe je dat op de meest eenvoudige / laagdrempelige manier?
