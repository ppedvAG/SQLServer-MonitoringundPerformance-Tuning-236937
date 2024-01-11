--> für SQL 2014 und früher empfiehlt sich statt Wartungsplan
--das Script von Ola Hallengren zu verwenden
--hier werden Fragmentierungen berücksichtigt

-- > 30 % --> Rebuild
-- < 10 %       kein Defrag notwendig
-- 10 bis 30  ---> Reorg


/*

zu einer Wartung gehört auch das Aktualisieren von Statistiken.
Statistiken: SQL prüft  -vor Ausführung von Abfragen - wieviele Zeilen zurückkommen.
Diese Anzahl wird aus einem Histogramm gebildet, das der SQL Server automatisch erstellt.

Tipp aus der Praxis: 
Statistiken auf mind 70% der Daten aktualisieren lassen. 
Das scheint ausreichend genug zu sein

Histogramm: Verteilung der Daten innerhalb einer Spalte (oder auch mehr Spalten)
Werden nicht bei jedem I U D aktualisiert und können somit im Laufe der Zeit falsch sein..

-->Plan muss aber aufgrund der zu erwartenden Menge für SEEK oder SCAN entscheiden...
liegt die Statistik falsch, dann auch der Plan


Je "korrekter" diese sind, desto exakter kann ein Ausführungsplan eingeschätzt werden...



--Wartungsplan
-- Statistiken aktualisieren, Indizes Rebuilden und Reorg
--am besten täglich
--Indizes könne fragemntieren--> unter 10% nichts zu tun
							  --> zw 10 bis 30 % Reorg
							  -- > ab 30% Rebuild
--der Wartungsplan deckt dies ab (aber erst seit SQL 2016)


Alternative:
Script von Ola Hallengren







*/
