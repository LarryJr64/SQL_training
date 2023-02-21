#1 Obtenir l’utilisateur ayant le prénom “Muriel” et le mot de passe “test11”, sachant que l’encodage du mot de passe est effectué avec l’algorithme Sha1.
SELECT  prenom, password
from client
where prenom like '%Muriel%' and password like sha1('test11');

#2 Obtenir la liste de tous les produits qui sont présent sur plusieurs commandes.
SELECT nom, COUNT(*) AS nbr_items 
FROM commande_ligne
GROUP BY nom 
HAVING nbr_items > 1
ORDER BY nbr_items DESC;

#3 Obtenir la liste de tous les produits qui sont présent sur plusieurs commandes et y ajouter une colonne qui liste les identifiants des commandes associées.
SELECT nom, COUNT(*) AS nbr_items , group_concat(commande_id)
FROM commande_ligne
GROUP BY nom 
HAVING nbr_items > 1
ORDER BY nbr_items DESC;

#4 Enregistrer le prix total à l’intérieur de chaque ligne des commandes, en fonction du prix unitaire et de la quantité
select commande_id, quantite, prix_unitaire, round(quantite*prix_unitaire,2) as prix_commande
from commande_ligne;


#5 Obtenir le montant total pour chaque commande et y voir facilement la date associée à cette commande ainsi que le prénom et nom du client associé
select cli.prenom, cli.nom,  c.date_achat, sum(round(quantite*prix_unitaire,2)) as prix_commande
from commande_ligne as cl
left JOIN commande as c ON cl.commande_id = c.id
left JOIN client as cli ON c.client_id = cli.id
group by commande_id;


