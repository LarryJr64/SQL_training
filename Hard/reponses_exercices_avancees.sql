#1 Enregistrer le montant total de chaque commande dans le champ intitulé “cache_prix_total”
UPDATE commande as c 
INNER JOIN 
    ( SELECT commande_id, sum(round(quantite*prix_unitaire,2))  AS p_total 
      FROM commande_ligne as cl
      GROUP BY commande_id ) cl
          ON  c.id = cl.commande_id 
SET c.cache_prix_total = cl.p_total;

#2 Obtenir le montant global de toutes les commandes, pour chaque mois
select round(sum(cache_prix_total),2), year(date_achat), month(date_achat)
from commande
group by year(date_achat), month(date_achat);

#3 Obtenir la liste des 10 clients qui ont effectué le plus grand montant de commandes, et obtenir ce montant total pour chaque client.
select cli.prenom, cli.nom, round(sum(c.cache_prix_total),2) as total_achat_client
from commande as c
left join client as cli on c.client_id = cli.id
group by c.client_id
order by total_achat_client desc
limit 10;

#4 Obtenir le montant total des commandes pour chaque date
select date_achat, round(sum(cache_prix_total),2) as achat_par_date
from commande
group by date_achat;

#5 Ajouter une colonne intitulée “category” à la table contenant les commandes. Cette colonne contiendra une valeur numérique
ALTER TABLE commande
ADD category NUMERIC;

#6 Enregistrer la valeur de la catégorie, en suivant les règles suivantes :
# “1” pour les commandes de moins de 200€
# “2” pour les commandes entre 200€ et 500€
# “3” pour les commandes entre 500€ et 1.000€
# “4” pour les commandes supérieures à 1.000€
update commande
set category = (
case
	when cache_prix_total < 200 then "1"
    when cache_prix_total > 200 and  cache_prix_total < 500 then "2"
    when cache_prix_total > 500 and  cache_prix_total < 1000 then "3"
    when cache_prix_total > 1000 then "4"
end
);

#7 Créer une table intitulée “commande_category” qui contiendra le descriptif de ces catégories
CREATE TABLE commande_category (
numero int,
descriptif VARCHAR(100));

#8 Insérer les 4 descriptifs de chaque catégorie au sein de la table précédemment créée
INSERT INTO commande_category (numero, descriptif)
 VALUES
 ('1', 'commandes de moins de 200€'),
 ('2', 'commandes entre 200€ et 500€'),
 ('3', 'commandes entre 500€ et 1.000€'),
 ('4', 'commandes supérieures à 1.000€');

#9 Supprimer toutes les commandes (et les lignes des commandes) inférieur au 1er février 2019. Cela doit être effectué en 2 requêtes maximum
DELETE FROM commande_ligne 
WHERE commande_id IN ( SELECT id FROM commande WHERE date_achat < '2019-02-01' );

delete from commande
where date_achat < '2019-02-01';

