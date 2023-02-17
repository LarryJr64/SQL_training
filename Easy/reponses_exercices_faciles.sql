#1 Obtenir la liste des 10 villes les plus peuplées en 2012
SELECT ville_nom, ville_population_2012
FROM villes_france_free 
ORDER BY ville_population_2012 desc 
Limit 10;

#2 Obtenir la liste des 50 villes ayant la plus faible superficie
SELECT ville_nom,  ville_surface
FROM villes_france_free
order by  ville_surface asc
limit 50;

#3 Obtenir la liste des départements d’outres-mer, c’est-à-dire ceux dont le numéro de département commencent par “97”
select ville_nom, ville_departement
from villes_france_free
WHERE ville_departement LIKE '97%';

#4 Obtenir le nom des 10 villes les plus peuplées en 2012, ainsi que le nom du département associé
SELECT v.ville_nom, d.departement_nom,  v.ville_population_2012
FROM villes_france_free as v
INNER JOIN departement as d ON v.ville_departement = d.departement_code
ORDER BY ville_population_2012 desc 
Limit 10;

#5 Obtenir la liste du nom de chaque département, associé à son code et du nombre de commune au sein de ces département, en triant afin d’obtenir en priorité les départements qui possèdent le plus de communes
select d.departement_nom, d.departement_code, count(v.ville_nom) as villes_par_departement
from departement as d
inner join villes_france_free as v ON v.ville_departement = d.departement_code
group by d.departement_nom
order by villes_par_departement desc;

#6 Obtenir la liste des 10 plus grands départements, en terme de superficie
select d.departement_nom, sum(v.ville_surface) as departement_superficie
from departement as d
inner join villes_france_free as v ON v.ville_departement = d.departement_code
group by d.departement_nom
order by departement_superficie desc
limit 10;

#7 Compter le nombre de villes dont le nom commence par “Saint”
select count(ville_nom) as villes_commencant_par_Saint
from villes_france_free
where ville_nom like 'Saint%';

#8 Obtenir la liste des villes qui ont un nom existants plusieurs fois, et trier afin d’obtenir en premier celles dont le nom est le plus souvent utilisé par plusieurs communes
select ville_nom, count(ville_nom) as nbr_ville_meme_nom
from villes_france_free
group by ville_nom
order by nbr_ville_meme_nom desc;

#9 Obtenir en une seule requête SQL la liste des villes dont la superficie est supérieur à la superficie moyenne
select ville_nom, ville_surface
from villes_france_free
where ville_surface > (select avg(ville_surface) from villes_france_free)
order by ville_surface desc;

#10 Obtenir la liste des départements qui possèdent plus de 2 millions d’habitants
select sum(v.ville_population_2012) as nbr_habitant, d.departement_nom
from villes_france_free as v
INNER JOIN departement as d ON v.ville_departement = d.departement_code
group by d.departement_nom
HAVING nbr_habitant > 2000000;

#11 Remplacez les tirets par un espace vide, pour toutes les villes commençant par “SAINT-” (dans la colonne qui contient les noms en majuscule)
SELECT REPLACE(ville_nom, '-', ' ') AS ville_nom2
FROM villes_france_free
WHERE ville_nom LIKE 'SAINT-%'