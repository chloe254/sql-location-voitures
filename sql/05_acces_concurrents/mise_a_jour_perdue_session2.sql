-- Session 2 (étape 2, pendant que la session 1 n'a pas validé)
START TRANSACTION;
SELECT compteur FROM voiture WHERE Immat = '11FG62';
UPDATE voiture SET compteur = 10200 WHERE Immat = '11FG62';
COMMIT;
