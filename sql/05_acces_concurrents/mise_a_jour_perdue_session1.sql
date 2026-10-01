-- Session 1 (étape 1)
START TRANSACTION;
SELECT compteur FROM voiture WHERE Immat = '11FG62';
UPDATE voiture SET compteur = 100180 WHERE Immat = '11FG62';
-- Étape 3 : valider après la session 2
COMMIT;
-- Résultat : 100180, la modification de la session 2 est perdue
