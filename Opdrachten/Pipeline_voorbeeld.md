# pipeline variable en parameters

## Doel
Doel van de opdracht is om te werken met parameters en variable in een pipeline. Door het gebruik van parameters en veriables wordt het mogelijk om controler te krijgen over de verschillende activiteiten van een pipeline.

## Opdracht

### situaltie
We gaan een deel contrle maken waarin we een loop simulieren door een download.


1. Maak een pipeline ```[pl_wait]```
2. Maak een variable ```[download]``` type String
3. Maak een variale ```[downloadCompleet]``` type Boolean met default waarde ```false```
4. Plaats een Until activiteit op het canvas
5. Klik op de configuration van de Until activiteit.
6. 





neem een activiteit dat een variable man setten.
in deze activiteit willen we de varible [downloadCompleet] met een random value setten met een range van (0,1) Dan wordt wille keurige een waarde 0 of 1 gezet.
daarna moet er een if conditie controleren of de veriable [downloadCompleet] gelijk is aan 1, als dat waar is kan de varibale [isPipelineCompleet] op (True) gezet worden, zo niet dan blijft deze op false en zal de pipeline opniew uitevoerd moeten worden.

Omdit goed te laten werken zullen we dit stuk in een while loop moeten zetten dat net zo lang loopt totde varibale [isPipelineComplete] = True


