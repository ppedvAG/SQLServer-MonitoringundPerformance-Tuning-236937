/*

INDIZES

CLUST IX
=Tabelle in sortierter Form
nur 1x pro Tabelle
gut bei Bereichsabfragen, weil sortiert
gut bei eindeutigen Werten 
per SSMS wird immer beim PK ein CL IX gesetzt.. in vielen Fälle dumm


NON CLUST IX
= Kopie von Daten in sortierter Form
ca 1000 mal Tabelle
gut bei geringen Resultset (id)

--------------------------
eindeutiger IX
zusammengesetzter IX
max 16 Spalten/32 und max 900 Schlüssellänge
meist nicht mehr als 4 notwendig

gefilterter IX
nicht alle Datensätze
Vorsicht: evtl ist ungefiltert genauso gut (Anzahl der Ebenen entscheidend)

IX mit eingeschlossenen Spalten
1023 Spalten
belastet den Baum nicht

partitionierter IX
entspricht gefilteren IX auf phsysikalischer Ebene
im Gegensatz zum gefilterten , wird der part IX jedoch alle Spaltenwerte in best Bereiche einordnen

Der Gefilterte dagegen betrachten nur die Datensätze, die sich durch den Filter ergeben
(zb USA)

----DE------FR-------IT-----UK-------------------------
Tabelle selbst kann/muss aber nicht / auf einer Partitionierung liegen
IX kann getrennt davon auf eine Partition gelegt werden..und muss nach der gleichen Spalte partitioniert werden



abdeckender IX
= idealer IX..reinen SEEK, kein Lookup , kein Scan


realer hypothetischer IX-- diese erstellt der Database Tuning Advisor ... unsichtbar im Hintergrun und löscht sie nach getaner Arbeit wieder
das Tool: Datenbankoptimierungsratgeber erstellt diese, um effiziente IX zu finden
diese sind "unsichtbar" und werden für Bneutzerabfragen nicht eingesetzt.
Also real und dennoch hyptothetisch...
Den Datenbankoptimierungsratgeber unbedingt seine Analyse zu Ende bringen lassen.
Sonst belieben die unsichtbaren IX Vorschläge in der DB hängen. ..
Stört, dann, wenn man keine neue mehr anlegen kann, weil zu viele IX existieren (Limit 1000)


ind Sicht
generiert auf das Ergebnis der Sicht einen gruppierten IX
unterliegt jedich sehr vielen Randbedingungen
(	Eindeutigkeit,deterministisch, 
	With schemabinding,Basistabelle und Sicht derselbe Besitzer, 
	bei group by muss count_big(*), kein AVG, sondern errechnen lassen ..usw..)

-------------------------------
Columnstore (Gruppiert und nicht gruppiert)
stark komprimiertes spaltenweises Ablegen der Daten
CPU optimiert
kommt, wie "normale" Seiten 1:1 in RAM
Aber: neue Datensätze kommen in einen zeileorientierte Heap (deltastore)
erst ab einer Million werden die Daten des Heap in die kompr Segmente übergeführt
Ausnahme: bei Massenimporten (ab ca 100000) werden die DS direkt in den Columntore übergeführt






--Vorsicht: Index Scan ist nicht schlecht-- weniger Aufwand als Table Scan, aber SEEK wäre besser

--Optimierer entscheidet sich für einen Scan , wenn dieser weniger Kosten als ein Seek verursacht
--der Optimierer entscheidet sich für einen IX Scan, wenn dieser günstiger als ein Table Scan ist.

-- user_scan, index_scan  ..nie gebrauchte Indizes evtl löschen
-- user_scan, index_scan  .. besser als table scan

--Kann man unnütze IX finden: DMVs...!
sys.dm_db_index_usage_Stats

toDO mit Indizes: Defragmentieren , überflüssige entfernen und fehlende erstellen
--Wartungsplan

-- Brent Ozar SP_blitzIndex-- First Responder Kit 0 Euro

--Wartung--> Wartungsplan: IX Rebuild IX Reorg Statistiken

--Stat:  akt nach 20% Änderung plus 500  zu spät, weil ab  ca 1% -- jeden Tag aktualisieren

--IX Reorg ab 10% 
--Rebuild ab 30%

exec sp_updatestats


TIPP:

IX mit eingeschlossenen Spalten
Die Schlüsselspalten blden sich aus den Spalten der where Bedingung
Die eingeschlossenen Spalten entnimmt man aus dem SELECT 


CLUSTERED INDEX.. als Primäschlüssel oft pure Verschwendung
CL spielt seine Vorteile bei Berecihsabfragen aus und wird nie Lookup Vorgänge erzeugen... 
allerdings gibt es diesen nur 1 mal pro Tabellen... Also gut vorher überlegen
--über die Entwurfsansicht der Tabelle--> rechte Maus--> Indizes und Schlüssel-- als Clustered erstellen (Ja / Nein) läßt sich das ändern.




*/

select * into ku2 from ku1

dbcc showcontig('ku2') -- 40455

alter table ku2 add id int identity

dbcc showcontig('ku2') -- 41092

set statistics io, time on
select * from ku2 where id =  100 --  57210,  vs  41092

select * from sys.dm_db_index_physical_stats(db_id(), object_id('ku2'),NULL,NULL, 'detailed')

--forward record counts muss NULL sein
--wenn man einen HEAP kann das passieren (neue Spalten)
--ID sind im "Anhang gelandet" und verbrauchen deutlich mehr Platz als notwendig
--CL IX = Lösung


alter table ku1 add id int identity


--CL IX auf Orderdate ist fix

--Welcher Plan? -- T SCAN
select id from ku1 where id = 100  --57206
--Tab Scan

--besser durch: NIX_ID  --IX SEEK
select id from ku1 where id = 100  --3
--Plan   IX Seek + Lookup       Seiten: 4

select id, freight from ku1 where id = 100
--Nun kommt ein Lookup dazu... = teuer. Je mehr Lookups desto teuerer
--Lookup unbedingt vermeiden!!!!
select id, freight from ku1 where id < 10500 --ab 11500 ca Table scan


--besser mit: NIX_ID_FR (zusammengesetzter IX)
select id, freight from ku1 where id < 900500 --ab 10500 ca Table scan

--Achtung: nun haben wir mehrer Indizes , die gleiches leisten
-- das bedeutet nicht nur überflüssig, sondern extra Kosten bei INS UP DEL
-- I U D ist erst dann "zu Ende" , wenn alle betroffenen IX aktualisiert wurden


select * from ku1
where country = 'USA' and freight < 1
--NIX_CYFR


select country, city,Sum(UnitPrice*quantity)
from ku1
where employeeid = 2
group by country, city
--NIX_EID_inkl_cy_ci_up_qu

--where  = Schlüsselspalte
--select = eingeschlossene Spalten



--NIX_EMPID_SCY_incl_CnameLname_Pname
select companyname, lastname, productname
from ku1
where EmployeeID= 2 and Shipcountry = 'USA'

--kein Vorschlag mehr, aber es sollten 2 sein
select companyname, lastname, productname
from ku1
where EmployeeID= 2 or Shipcountry = 'USA'


--Ind. Sicht

select country, count(*) from ku1
group by country


create view vdemo
as
select country, count(*) as ANz from ku1
group by country

select * from vdemo

select country, count(*) from ku1
group by country

create or alter view vdemo  with schemabinding
as
select country, count_big(*) as ANz from dbo.ku1
group by country


--COLUMNSTORE
select * into ku3 from ku


select Companyname, avg(quantity), min(quantity)
from ku1
where
		country = 'germany'
group by CompanyName


select Companyname, avg(quantity), min(quantity)
from ku3
where
		country = 'germany'
group by CompanyName


--Warum schneidet die KU3 bei jeder Abfrage , gleich oder besser ab

--Größe der KU und Größe der KU3
-- 600MB vs 4 MB
--Stimmt das oder nicht?

--es stimmt!!!!
--und das genauso im RAM



select Companyname, avg(quantity), min(quantity)
from ku3
where
		city = 'Berlin'
group by CompanyName


--INDIZES müssen gewartet werden



--Wartung der Indizes
--rebuild reorg

--rebuild ab Fragmentierung 30%
--reorg darunter
--unter 10 % nix

--Fehlende IX finden
--überflüssige IX entfernen

select * from sys.dm_db_index_usage_stats

--1 = CL IX
--0 = Heap
--> 1   NCL IX




































