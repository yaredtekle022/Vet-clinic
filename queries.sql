/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE NAME IN ('Agumen', 'Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;
SELECT * FROM animals WHERE neutered = true;
SELECT * FROM animals WHERE name <> 'Gabumon';
SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;

BEGIN;
UPDATE animals SET species = 'unspecified';
ROLLBACK;
SELECT species from animals;

BEGIN;
UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';

UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;
SELECT species from animals;
COMMIT;

BEGIN;
DELETE FROM animals WHERE ;
SELECT COUNT(*) FROM ANIMALS;

ROLLBACK;
SELECT COUNT(*) FROM ANIMALS;


BEGIN;
DELETE FROM animals
WHERE date_of_birth > '2022-01-01';
COMMIT;

BEGIN;
SAVEPOINT transaction_savepoint;

UPDATE animals
SET weight_kg = weight_kg * -1;
ROLLBACK TO  transaction_savepoint;
COMMIT;

BEGIN;
UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;
COMMIT;

SELECT COUNT(*) FROM animals;
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) FROM animals;

SELECT neutered, SUM(escape_attempts) AS total_escape_attempts
FROM animals
GROUP BY neutered
ORDER BY total_escape_attempts DESC;

SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight
FROM animals
GROUP BY species;

SELECT species, AVG(escape_attempts) FROM animals
GROUP BY species
WHERE  date_of_birth >= '1990/01/01' AND date_of_birth <= '2000/12/31';

-- What animals belong to Melody Pond

SELECT animals.name
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

-- type "Pokemon," 

SELECT animals.name
FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

-- list of animal owners:
SELECT owners.full_name, animals.name AS animal_name
FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id
ORDER BY owners.full_name, animals.name;

-- number of animals per species:
SELECT species.name AS species_name, COUNT(*) AS animal_count
FROM animals
JOIN species ON animals.species_id = species.id
GROUP BY species.name;

-- list of animals owned by Jennifer Orwell

SELECT animals.name AS digimon_name
FROM animals
JOIN species ON animals.species_id = species.id
JOIN owners ON animals.owner_id = owners.id
WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';

-- list of animals owned by Dean Winchester that havent tried to escape.

SELECT animals.name AS animal_name
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Dean Winchester';

-- Who owns the most animals

SELECT o.id, o.full_name, COUNT(*) AS animal_count
FROM owners o
JOIN animals a ON o.id = a.owner_id
GROUP BY o.id, o.full_name
ORDER BY animal_count DESC
LIMIT 1;

-- last animal seen by Vet William Tatcher

SELECT a.name AS animal_name
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN vets t ON v.vet_id = t.id
WHERE t.name = 'Vet William Tatcher'
ORDER BY v.visit_date DESC
LIMIT 1;

-- number of animals seen by Stephanie Mendez:
SELECT COUNT(DISTINCT v.animal_id) AS num_animals_seen
FROM visits v
JOIN vets t ON v.vet_id = t.id
WHERE t.name = 'Vet Stephanie Mendez';

-- list all vets and their specialties, including vets with no specialties.
SELECT v.name AS vet_name, s.name AS specialty_name
FROM vets v
LEFT JOIN specializations sp ON v.id = sp.vet_id
LEFT JOIN species s ON sp.species_id = s.id
ORDER BY v.id;
-- animals that visited Stephanie(April 1st and August 30th, 2020)
SELECT a.name AS animal_name, v.visit_date
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN vets t ON v.vet_id = t.id
WHERE t.name = 'Vet Stephanie Mendez'
AND v.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

-- animal with the most visits
SELECT a.name AS animal_name, COUNT(v.animal_id) AS visit_count
FROM visits v
JOIN animals a ON v.animal_id = a.id
GROUP BY a.name
ORDER BY visit_count DESC
LIMIT 1;

-- maseys first visit
SELECT a.name AS animal_name, MIN(visit_date) AS first_visit_date
FROM visits AS vis
JOIN animals AS a ON vis.animal_id = a.id
JOIN vets AS v ON vis.vet_id = v.id
WHERE v.name = 'Vet Maisy Smith'
GROUP BY a.name
ORDER BY first_visit_date
LIMIT 1;

-- recent visit details
SELECT a.name AS animal_name, v.name AS vet_name, vis.visit_date AS date_of_visit
FROM visits AS vis
JOIN animals AS a ON vis.animal_id = a.id
JOIN vets AS v ON vis.vet_id = v.id
WHERE vis.visit_date = (SELECT MAX(visit_date) FROM visits)
LIMIT 1;

-- unspecialized visits

SELECT COUNT(*) AS num_visits_not_specialized
FROM visits AS vis
JOIN animals AS a ON vis.animal_id = a.id
JOIN vets AS v ON vis.vet_id = v.id
LEFT JOIN specializations AS s ON v.id = s.vet_id AND a.species_id = s.species_id
WHERE s.vet_id IS NULL;

-- maseys specialty
SELECT s.name AS species_name, COUNT(*) AS num_visits
FROM visits AS vis
JOIN animals AS a ON vis.animal_id = a.id
JOIN species AS s ON a.species_id = s.id
JOIN vets AS v ON vis.vet_id = v.id
WHERE v.name = 'Vet Maisy Smith'
GROUP BY s.name
ORDER BY num_visits DESC
LIMIT 1;
