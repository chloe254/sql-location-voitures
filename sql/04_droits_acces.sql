-- 04 - Gestion des droits d'accès

USE agence_de_voyage;

-- Table applicative des accès : L = lecture, E = écriture, U = update, D = delete, T = total
CREATE TABLE ACCESS (
  user_id      INT AUTO_INCREMENT PRIMARY KEY,
  login        VARCHAR(50)  NOT NULL UNIQUE,
  password     VARCHAR(100) NOT NULL,
  access_level ENUM('L', 'E', 'U', 'D', 'T') DEFAULT 'L'
);

-- Les clients ont un accès en lecture.
-- Remarque : MD5 n'est pas adapté au stockage de mots de passe. En production,
-- on utiliserait un hachage fait pour ça (bcrypt, argon2) côté application.
INSERT INTO ACCESS (login, password, access_level)
SELECT LOWER(CONCAT(Nom, '.', Prenom)), MD5(CONCAT(Nom, Prenom)), 'L'
FROM client;

-- Les propriétaires qui ont un email ont un accès en écriture
INSERT INTO ACCESS (login, password, access_level)
SELECT email, MD5(email), 'E'
FROM proprietaire
WHERE email IS NOT NULL AND email <> '';

-- Utilisateurs MySQL (les mots de passe sont des exemples à remplacer)

-- a) lecture seule sur quelques tables
CREATE USER 'lecteur'@'localhost' IDENTIFIED BY 'changer_moi';
GRANT SELECT ON agence_de_voyage.client  TO 'lecteur'@'localhost';
GRANT SELECT ON agence_de_voyage.voiture TO 'lecteur'@'localhost';

-- b) lecture, ajout et modification, sans suppression
CREATE USER 'editeur'@'localhost' IDENTIFIED BY 'changer_moi';
GRANT SELECT, INSERT, UPDATE ON agence_de_voyage.client   TO 'editeur'@'localhost';
GRANT SELECT, INSERT, UPDATE ON agence_de_voyage.location TO 'editeur'@'localhost';

-- c) tous les droits, avec possibilité de les transmettre
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'changer_moi';
GRANT ALL PRIVILEGES ON agence_de_voyage.* TO 'admin'@'localhost' WITH GRANT OPTION;

FLUSH PRIVILEGES;
