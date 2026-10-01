-- 06 - Procédures stockées

USE agence_de_voyage;

ALTER TABLE location ADD COLUMN note TINYINT NULL;
ALTER TABLE location ADD COLUMN avis VARCHAR(30) NULL;

-- Note de 1 à 5 selon le kilométrage et la durée de la location
DELIMITER $$
CREATE PROCEDURE attribuer_notes()
BEGIN
  UPDATE location
  SET note =
    CASE
      WHEN km IS NULL OR duree IS NULL OR duree = 1 THEN NULL
      WHEN km > 1000 AND duree > 50 THEN 5
      WHEN km > 500  AND duree > 20 THEN 4
      WHEN km > 100  AND duree > 7  THEN 3
      WHEN km <= 100 AND duree > 3  THEN 2
      ELSE 1
    END;
END$$
DELIMITER ;

-- Avis textuel déduit de la note
DELIMITER $$
CREATE PROCEDURE attribuer_avis()
BEGIN
  UPDATE location
  SET avis =
    CASE
      WHEN note >= 5 THEN 'Très satisfait'
      WHEN note = 4 THEN 'Satisfait'
      WHEN note = 3 THEN 'Assez satisfait'
      WHEN note = 2 THEN 'Peu satisfait'
      WHEN note = 1 THEN 'Insatisfait'
      ELSE 'Non évalué'
    END;
END$$
DELIMITER ;

-- Synthèse des locations d'un client : durée totale, nombre de véhicules différents, note moyenne
DELIMITER $$
CREATE PROCEDURE analyse_client(IN p_CodeC VARCHAR(4))
BEGIN
  DECLARE total_duree INT;
  DECLARE nb_voitures INT;
  DECLARE moyenne_note DECIMAL(4,2);

  SELECT SUM(duree) INTO total_duree
  FROM location WHERE CodeC = p_CodeC;

  SELECT COUNT(DISTINCT immat) INTO nb_voitures
  FROM location WHERE CodeC = p_CodeC;

  SELECT AVG(note) INTO moyenne_note
  FROM location WHERE CodeC = p_CodeC;

  SELECT
    p_CodeC                AS 'Code Client',
    total_duree            AS 'Durée totale (jours)',
    nb_voitures            AS 'Nb véhicules différents',
    ROUND(moyenne_note, 2) AS 'Moyenne des notes';
END$$
DELIMITER ;

-- Exemples
CALL attribuer_notes();
CALL attribuer_avis();
CALL analyse_client('C654');
