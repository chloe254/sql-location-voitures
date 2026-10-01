-- 03 - Vues

USE agence_de_voyage;

-- Distance totale parcourue par chaque client (0 s'il n'a jamais loué).
-- LEFT JOIN pour garder les clients sans location.
CREATE OR REPLACE VIEW V_client AS
SELECT
  c.CodeC,
  c.Prenom,
  c.Nom,
  c.age,
  IFNULL(SUM(l.km), 0) AS distance
FROM client c
LEFT JOIN location l ON c.CodeC = l.CodeC
GROUP BY c.CodeC, c.Prenom, c.Nom, c.age;

-- Cette vue n'est pas modifiable : distance est une colonne calculée (agrégat).
-- UPDATE V_client SET distance = 0 WHERE CodeC = 'C654';  -- renvoie une erreur

-- Clients de plus de 55 ans
CREATE OR REPLACE VIEW V_Client55 AS
SELECT CodeC, Prenom, Nom, age
FROM client
WHERE age > 55;

-- Test : une vue simple est modifiable, l'insertion passe dans la table client,
-- mais la ligne n'apparaît pas dans V_Client55 car le client a moins de 55 ans.
INSERT INTO V_Client55 (CodeC, Prenom, Nom, age)
VALUES ('C999', 'Louis', 'Martin', 50);
