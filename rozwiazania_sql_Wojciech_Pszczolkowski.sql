--1. Proszę napisać zapytanie, które zlicza ile spraw zostało otwartych i na jaką kwotę w  2015 roku

SELECT COUNT(ID_SPRAWY) AS liczba_spraw, SUM([KWOTAPOCZATKOWA]) AS suma_kwot, YEAR(DATA_OTWARCIA) AS Rok FROM TAB_SPRAWA 
WHERE YEAR(DATA_OTWARCIA) = 2015 
GROUP BY YEAR(DATA_OTWARCIA);

--2.Proszę napisać zapytanie, które, zlicza ile spraw zostało otwartych i na jaką kwotę w 2016 roku w poszczególnych miesiącach

SELECT COUNT(ID_SPRAWY) AS liczba_spraw, SUM([KWOTA POCZATKOWA]) AS suma_kwot, MONTH(DATA_OTWARCIA) AS Miesiac FROM TAB_SPRAWA 
WHERE YEAR(DATA_OTWARCIA) = 2016 
GROUP BY MONTH(DATA_OTWARCIA);

--3.Proszę napisać zapytanie, które zlicza ile wpłat zostało dokonanych i na jaką kwotę takich, dla których otwarcie sprawy nastąpiło w 2014 roku

SELECT COUNT(w.ID_WPLATY) AS liczba_wplat, SUM(w.KWOTA_WPLATY) AS suma_wplat, YEAR(s.DATA(OTWARCIA) AS Rok_otwarcia FROM TAB_WPLATY w 
JOIN TAB_SPRAWA s ON w.ID_SPRAWY_OG=s.ID_SPRAWY 
WHERE YEAR(s.DATA_OTWARCIA) = 2014 AND w.TYP_WPLATY NOT IN (3,5) 
GROUP BY YEAR(s.DATA_OTWARCIA);

--4.Proszę napisać zapytanie, które zlicza ile spraw zostało otwartych i na jaką kwotę takich, dla których wystąpiła wpłata w 2016 roku

SELECT COUNT(s.ID_SPRAWY) AS liczba_spraw, SUM([s.KWOTA POCZATKOWA]) AS suma_kwot FROM TAB_SPRAWA s 
JOIN TAB_WPLATA w ON s.ID_SPRAWY=w.ID_SPRAWY_OG 
WHERE YEAR(w.DATA_WPLATY) = 2016 AND w.TYP_WPLATY NOT IN (3,5) 
GROUP BY YEAR(w.DATA_WPLATY);

--5.Proszę napisać zapytanie, które zlicza kwotę wpłat po miesiącach w podziale na rok otwarcia sprawy (czyli osobno suma wpłat w styczniu dla spraw otwartych w 2014 i osobno suma wpłat w styczniu dla spraw otwartych w 2015 itd...)

SELECT YEAR(s.DATA_OTWARCIA) AS Rok_otwarcia, MONTH(w.DATA_WPLATY) Miesiac_wplaty, SUM(w.KWOTA_WPLATY) AS Suma_wplat FROM TAB_SPRAWY s 
JOIN TAB_WPLATA w ON s.ID_SPRAWY=w.ID_SPRAWY_OG 
WHERE YEAR(s.DATA_OTWARCIA) = YEAR(w.DATA_WPLATY) AND w.TYP_WPLATY NOT IN (3,5) 
GROUP BY YEAR (s.DATA_OTWARCIA), MONTH(w.DATA_WPLATY);

--6.Proszę napisać zapytanie, które wskaże jeszcze jaka kwota pozostała na sprawach (można założyć, że kwota jest to kwota startowa pomniejszona o wszystkie wpłaty które miały miejsce PO dacie otwarcia)

SELECT s.ID, ([s.KWOTA POCZATKOWA] – COALESCE(SUM(w.KWOTA_WPLATY),0) AS Pozostala_kwota FROM TAB_SPRAWY s 
LEFT JOIN TAB_WPLATY w ON s.ID_SPRAWY=w.ID_SPRAWY_OG AND w.DATA_WWPLATY > DATA_OTWARCIA 
WHERE w.TYP_WPLATY NOT IN (3,5) 
GROUP BY s.ID;

--7.Proszę napisać zapytanie, które zliczy sprawy oraz zsumuje kwotę początkową spraw, dla których co najmniej raz w historii wykonaliśmy dwa połączenia następujące po sobie w czasie mniejszym niż  pięć minut

SELECT COUNT(s.ID_SPRAWY) AS LiczbaSpraw, SUM(s.[KWOTA POCZATKOWA]) AS SumaKwotPoczatkowych FROM TAB_SPRAWA s  
WHERE s.ID_SPRAWY IN  
	(SELECT DISTINCT(t1.ID_SPRAWY) FROM TAB_TELEFON t1          
	JOIN TAB_TELEFON t2 ON t1.ID_SPRAWY = t2.ID_SPRAWY  
		AND t1.DATA_TELEFON < t2.DATA_TELEFON  
		AND DATEDIFF(MINUTE, t1.DATA_TELEFON, t2.DATA_TELEFON) < 5 
		AND t1.TYP_TELEFON = 'W'
		) 
