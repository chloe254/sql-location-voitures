-- 08 - Requêtes utilisées par l'onglet "Graphiques" de l'application

USE agence_de_voyage;

-- Distance totale par client
SELECT c.Nom, SUM(l.km) AS distance
FROM client c
JOIN location l ON c.CodeC = l.CodeC
GROUP BY c.Nom;

-- Répartition des voitures par état
SELECT etat, COUNT(*) AS n
FROM voiture
GROUP BY etat;

-- Nombre de locations par mois
SELECT DATE_FORMAT(dated, '%Y-%m') AS mois, COUNT(*) AS n
FROM location
GROUP BY mois
ORDER BY mois;

-- Distribution des durées de location
SELECT duree
FROM location
WHERE duree > 0;

-- Kilométrage moyen selon la durée
SELECT duree, AVG(km) AS km_moy
FROM location
WHERE duree > 0
GROUP BY duree;
