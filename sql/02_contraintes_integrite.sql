-- 02 - Clés étrangères et contraintes d'intégrité

USE agence_de_voyage;

-- Clés étrangères
ALTER TABLE voiture
  ADD CONSTRAINT fk_voiture_proprietaire
  FOREIGN KEY (codeP) REFERENCES proprietaire(codeP)
  ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE location
  ADD CONSTRAINT fk_location_client
  FOREIGN KEY (CodeC) REFERENCES client(CodeC)
  ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE location
  ADD CONSTRAINT fk_location_voiture
  FOREIGN KEY (immat) REFERENCES voiture(Immat)
  ON UPDATE CASCADE ON DELETE SET NULL;

-- Nombre de places entre 1 et 9
ALTER TABLE voiture
  ADD CONSTRAINT chk_places CHECK (places BETWEEN 1 AND 9);

-- Prix journalier positif
ALTER TABLE voiture
  ADD CONSTRAINT chk_prixJ CHECK (prixJ > 0);

-- Année d'achat plausible
ALTER TABLE voiture
  ADD CONSTRAINT chk_achatA CHECK (achatA BETWEEN 1900 AND 2025);

-- Un email doit contenir un @
ALTER TABLE proprietaire
  ADD CONSTRAINT chk_email_format CHECK (email LIKE '%@%');
