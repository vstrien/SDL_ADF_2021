
# Doel
Onsluiten van een simple api.


# Opdracht

Ontsluit nu de volgende web api van buienradar.

https://data.buienradar.nl/2.0/feed/json

en laat de data landen in data lake.
Kijk hier goed hoe wel de data netjes gearchiveerd kunnen laden.
De data set wordt namelijk elke 10 minuten ververste.
Zouden hier een trigger op willen zetten van dat elke uur deze pipeline draaid.
Dus zouden we morgen 24 data set in een dag van buienradar moeten hebben.


Om de dataset in de adls te laten landen heb je een data set nodig dat verwijst naar de adls en heeft het bestands type json.

De dataset moet in de volgende folder structuur terecht gaan komen. 
stg / buienradar / yyyy / mm / dd / 
Daarnaast zul je de filename ook een sufix moeten meegeven zodat je weer van de dan welke uur deze data zet is.