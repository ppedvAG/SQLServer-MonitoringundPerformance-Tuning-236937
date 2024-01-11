/*
Hat die VM auch die Ressourcen, die sie auch ohne Virtualisierung hätte?
/*


Ziel Nr 1 (neben genug RAM)		 

HDD!!!!!!

IO reduzieren!!!
IO schneller machen


jeweniger IO desto weniger...RAM und desto weiger CPU
IO-->CPU

Virtualisierung--> Konsolidierung--> genug HDD Power?

Goldene Regel:

Trenne Log von Daten physikalisch!

CPU

! Bilde in der VM die reale Umgebung ab..

NUMA: 
NUMA Architektur...zu jedem RAM Sockel (Knoten) gehört ein bestimmter Prozessor
	Vorteil der ZUgriff ist sehr schnell
	Zugriff auf RAM eines anderen Sockel höhere Latenzzeit
      
Was, wenn die Architekur in VM was anderes sieht, als es in der realität ist..


RAMVERTEILUNG bei VMs
Beachte immer das Gast OS! Mind 4 GB gedanklich reservieren..

Aktuelle Ausstattung
16 GB RAM 1 Socket 1 CPU mit 2 Kernen und 4 log Prozessoren

Für das vorreservieren: 4 GB

16-4GB= 12GB zu verteilen

HV-DC:   dynamischer Speicher 1024 als Startwert bis max 2048 MB  2 CPU

12GB-2GB= 10GB

HV-SQL1: fixer Speicher im Fall von SQL Server 6 GB  4 CPUs

10-2048-6 = 4GB

HV-SQL2: fixer Speicher 4 GB    4 CPUs


NUMA Zuweisung beachten


*/