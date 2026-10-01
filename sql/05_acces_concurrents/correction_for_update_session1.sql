-- Session 1 : on verrouille la ligne avant de la modifier
START TRANSACTION;
SELECT compteur FROM voiture WHERE Immat = '11FG62' LIMIT 1 FOR UPDATE;
-- (LIMIT 1 ajouté car phpMyAdmin ajoute sinon sa propre limite après le FOR UPDATE)
UPDATE voiture SET compteur = compteur + 100 WHERE Immat = '11FG62';
COMMIT;
