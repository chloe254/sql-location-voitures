-- 01 - Nettoyage et typage des données
-- Les tables client, proprietaire, voiture et location ont été importées depuis
-- des fichiers CSV avec phpMyAdmin (séparateur virgule, première ligne en en-tête).

USE agence_de_voyage;

-- Les dates étaient importées en VARCHAR : on les passe en DATE
ALTER TABLE location
  MODIFY dated DATE,
  MODIFY datef DATE;

-- Dates de fin manquantes ou égales à la date de début.
-- Données d'exercice : elles ont été complétées aléatoirement pour les besoins du TP.
-- Sur de vraies données, on laisserait NULL ou on recalculerait datef = dated + duree.
UPDATE location
SET datef = DATE_ADD(dated, INTERVAL FLOOR(RAND() * 30 + 1) DAY)
WHERE datef = dated OR datef IS NULL;

-- Clé primaire technique sur location
ALTER TABLE location ADD id INT AUTO_INCREMENT PRIMARY KEY FIRST;

-- Emails de propriétaires en double : on garde le premier (plus petit codeP)
-- et on met les autres à NULL, pour pouvoir rendre la colonne unique
UPDATE proprietaire
SET email = NULL
WHERE codeP NOT IN (
    SELECT codeP_min FROM (
        SELECT MIN(codeP) AS codeP_min
        FROM proprietaire
        WHERE email IS NOT NULL AND email <> ''
        GROUP BY email
    ) AS uniques
)
AND email IN (
    SELECT email FROM (
        SELECT email
        FROM proprietaire
        WHERE email IS NOT NULL AND email <> ''
        GROUP BY email
        HAVING COUNT(*) > 1
    ) AS doublons
);

ALTER TABLE proprietaire ADD UNIQUE (email);
