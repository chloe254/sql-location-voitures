-- Session 2 : bloquée sur le SELECT ... FOR UPDATE tant que la session 1 n'a pas validé
START TRANSACTION;
SELECT compteur FROM voiture WHERE Immat = '11FG62' LIMIT 1 FOR UPDATE;
UPDATE voiture SET compteur = compteur + 100 WHERE Immat = '11FG62';
COMMIT;
-- Résultat : les deux +100 sont appliqués (100200 -> 100400)
