# Accès concurrents

Ces scripts se lancent dans deux sessions MySQL ouvertes en même temps, dans l'ordre indiqué en commentaire. Les tables doivent être en InnoDB (MyISAM ne gère pas les transactions).

- `mise_a_jour_perdue_*.sql` : deux employés modifient le compteur d'une même voiture, et une des deux modifications est écrasée.
- `correction_for_update_*.sql` : même scénario avec `SELECT ... FOR UPDATE`. La deuxième session attend que la première ait validé, et les deux ajouts sont pris en compte.
- `lecture_sale_*.sql` : la session 2 lit une valeur que la session 1 n'a pas encore validée.
