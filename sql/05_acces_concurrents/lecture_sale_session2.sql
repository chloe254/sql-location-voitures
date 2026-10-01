-- Session 2 : lecture pendant que la session 1 n'a pas validé
-- En READ UNCOMMITTED, on lit la valeur non validée (lecture sale).
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT compteur FROM voiture WHERE Immat = '11FG62';

-- Avec READ COMMITTED (ou REPEATABLE READ, le niveau par défaut d'InnoDB),
-- on lit la dernière valeur validée.
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT compteur FROM voiture WHERE Immat = '11FG62';
