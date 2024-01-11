--Monitoring


--live Problem
---- Reihenfolge für Monitoring
--1.  Taskmanager: Ausschluss andere Dinge (Anitvirentool, Viren, Trojaner..)
---    zB mslaugh.exe   teakids.exe mit Admin acount
--> nix gefunden...-->SQL Server 

--2 SQL Server genauer anschauen
-->   Aktivitätsmonitor  
----> Wartezustände.. worauf warten aktuell. innerhalb der letzten Sekunden bzw in der letzten Zeit
-------> damit haben wir schon mal die Richtung , in der wir weitersehen müssen.

--für genauere Infos: auch der Aktivitätsmonitor wertet Systemsichetn aus, wie zB:

select * from sys.dm_os_wait_stats

--wait_time = gesamte Wartezeit
--signal_time = Wartezeit auf Ressource  (= ein Teil der gesamt Wartezeit)
--alle Zeiten sind kummulierend

--alle Sessions mit SID > 50 sind User (auch Agent)


select * from sys.dm_os_wait_stats
--eigtl müssten wir folgendes tun
-- wenn man alle Wartezeiten addiert = gemsamte  Laufzeit des Servers
--Wartezeit einer Ressource im Vergleich zur gesamt Laufzteit

--sammlet alle Wartezeiten kummulierend seit Neustart


--Wenn wir alle zB 10min die Wartenzeiten speichern, 

LCK_M_S	   242	5894499	1855310	33    um 10 Uhr
LCK_M_S	   242	5894499	1855310	33   um 10:10 
LCK_M_S	   242	8745766	1855310	33  um 10:20

--------------DMVs Data Management Views-------------
-- siehe im Projekt Z_SQL_Server_2019_Diagnostic Information Queries.sql
--eine ganze Sammlung von nützlichen DMvs

select * from sysprocesses --alle Prozesse der User haben ein SPID > 50

---------------Für eine historische Betrachtung--------------------
--ist der SQL neugestartet , sind die DMVs zurückgestzt worden. Somit wertvolle Infos weg...
--also evtl Aufzeichnen



---per TSQL ----------------------------------------
-- set statistics io, time on 
--sowie Abfragepläne

--Diese bieten wertvolle Hinweise, erfordern aber aktives Monitoring
set statistics io,time on

select * from orders where freight > 10


select * from custorders where id = 100
--250ms CPU .. 128ms Dauer... 60240 Seiten

--nach QueryStore und IX Vorschlag aus dem QueryStore
--, CPU-Zeit = 0 ms, verstrichene Zeit = 0 ms.
--Seiten : 4 






----Meldung: Problem SQL langsam


/*

--Aktivitätsmonitor------------------------------
Was geht .. auf Server--> Taskmanager +  Ressourcemonitor

==> wo geht die Leistung hin?  --> ? Antivirentool, Trojanerquark, andere Tools, Software

--Was wenn keine Engpässe erkennbar oder deutlich auf SQL Server hinweist?
--> Taskmanager für SQL Server: Aktivitätsmonitor

--Dort kann man die aktiven Prozesse der Benutzer mitverfolgen

select * from sysprocesses  where spid <= 50.. alles andere = User

wir finden hier also : aktive Prozessen, die Wartezeiten und Warteressourcen, die IO Aktivtäten,  Die teruersten aktiven bzw vergangenen Abfragen 

--------------------------------------------------------------



---jedes Tool im SQL Server basiert eigtl auf 
----------------DMV  DataManagement Views---------------

Systemsichten.. die nach dem Neustart des SQL Server geleert
--daher Systemsichten evtl wegsichern.. bzw best Abfragen

oder Tools zum Aufzeichnen verwenden wie Datensammler oder QueryStore


--TOOL  DATENSAMMLER-----------------------------

--kann man alles per rechter Maustaste konfigurieren

--1: Anlegen der DatawarehouseDB
--2: Konfigurieren der DAtensammlersätze

--TOOL: QueryStore (Abfragespeicher)----------------
--sammlet pro DB Messdaten und Abfragen. Daten stehen auch nach Neustart noch zur  Verfügung
--grafische Auswertung in Form von Berichten
.--muss pr DB aktiviert werden
--> Sehr cool...daher: Query Store merkt sich , fast unscheinbar - die Messwerte und Pläne, und bereitet die grafisch auf... auf Dauer
--> muss alerdings aktiviert werden

--QueryStore Abfragespeicher: sammlet Abfragen der DB plus rel viele Messungen
			--> aber nicht wer


--TOOL Perfmon (NT): Messwerte einer SQLInstanz und Windows Messwerte------------------------------
---------> Grafische Auswertung.. sehr leicht um Problem zu erkennen

--TOO Profiler: Tool um Abfragen aufzuzeichen--------------------------------------------------



*/

--Wie findet man Systemsichten?.. Aber es gibt auch viele, die nicht dm beginnen..:-(
select * from sys.dm_os...    --SQL Server
select * from sys.dm_db... --rund um Datenbanken

--zB
select * from sys.dm_db_index_usage_stats



*/


select * from sys.dm_os_wait_stats



--Query--Postkasten(Fifo)--> Worker(Analyse)-- Ressourcen!!

--                    supended  |runnable    |RUNNING
---(LCK_M_S)|........................|........................| 70ms bis das Ding läuft
--          0                 50ms CPU 20ms

--wait_time_ms: Gesamte Dauer: 70ms
--              Signal_time_ms: Anteil der CPU: 70-20=50

--leider sind die Werte kummilierend seit Neustart :-(
--wenn der Anteil der signaltime > 25% sein sollte, dann CPU Engpass

select * from sys.dm_os_wait_stats order by 3 desc

--oder auch Daten des Perfmon abfragbar
select * from sys.dm_os_performance_counters


