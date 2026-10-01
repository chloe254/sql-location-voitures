-- Session 1 : modification non validée
START TRANSACTION;
UPDATE voiture SET compteur = compteur + 200 WHERE Immat = '11FG62';
-- pas de COMMIT pour l'instant
