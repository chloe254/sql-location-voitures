-- 07 - État des véhicules et historique, gérés par triggers

USE agence_de_voyage;

ALTER TABLE voiture
  ADD COLUMN etat ENUM('Disponible', 'En location', 'En réparation', 'Indisponible')
  DEFAULT 'Disponible';

-- Table d'historique des changements d'état
CREATE TABLE historique_etat (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  immat           VARCHAR(10) NOT NULL,
  ancien_etat     VARCHAR(20),
  nouvel_etat     VARCHAR(20),
  date_changement DATETIME DEFAULT CURRENT_TIMESTAMP,
  commentaire     VARCHAR(255)
);

-- Avant une nouvelle location : refuser si la voiture n'est pas disponible,
-- sinon la passer "En location"
DELIMITER //
CREATE TRIGGER trg_verif_voiture_avant_location
BEFORE INSERT ON location
FOR EACH ROW
BEGIN
  DECLARE v_etat VARCHAR(20);

  SELECT etat INTO v_etat
  FROM voiture
  WHERE Immat = NEW.immat;

  IF v_etat <> 'Disponible' THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Erreur : cette voiture n''est pas disponible pour la location.';
  ELSE
    UPDATE voiture SET etat = 'En location' WHERE Immat = NEW.immat;
  END IF;
END //
DELIMITER ;

-- Quand une location est terminée (date de fin atteinte), la voiture redevient disponible
DELIMITER //
CREATE TRIGGER trg_voiture_disponible_apres_location
AFTER UPDATE ON location
FOR EACH ROW
BEGIN
  IF NEW.datef <= CURDATE() THEN
    UPDATE voiture SET etat = 'Disponible' WHERE Immat = NEW.immat;
  END IF;
END //
DELIMITER ;

-- Chaque changement d'état d'une voiture est enregistré dans historique_etat
DELIMITER //
CREATE TRIGGER trg_historique_etat_voiture
AFTER UPDATE ON voiture
FOR EACH ROW
BEGIN
  IF OLD.etat <> NEW.etat THEN
    INSERT INTO historique_etat (immat, ancien_etat, nouvel_etat, commentaire)
    VALUES (NEW.immat, OLD.etat, NEW.etat, CONCAT('Changement automatique depuis trigger à ', NOW()));
  END IF;
END //
DELIMITER ;

-- Test
INSERT INTO location (numloc, CodeC, immat, duree, km, dated, datef)
VALUES ('L9999', 'C654', '11FG62', 7, 850, '2025-11-01', '2025-11-08');
SELECT Immat, etat FROM voiture WHERE Immat = '11FG62';   -- En location

UPDATE location SET datef = CURDATE() WHERE numloc = 'L9999';
SELECT Immat, etat FROM voiture WHERE Immat = '11FG62';   -- Disponible

SELECT * FROM historique_etat WHERE immat = '11FG62';
