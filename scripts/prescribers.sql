-- 1.a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.
SELECT SUM(total_claim_count) AS total_claims, npi
FROM prescription
	LEFT JOIN prescriber 
	USING (npi)
GROUP BY npi
ORDER BY total_claims DESC
LIMIT 1;
--Answer Total claims 99707 Npi : 1881634483
-- b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, and the total number of claims.
SELECT nppes_provider_first_name AS first_name, nppes_provider_last_org_name AS last_name, specialty_description AS title, SUM(total_claim_count) AS total_claims
FROM prescription
LEFT JOIN prescriber
ON prescriber.npi = prescription.npi
GROUP BY first_name, last_name, title
ORDER BY total_claims DESC
LIMIT 1;
--Answer Bruce Pendley, Family Practice, 99707 claims and the npi is 1,881,634,483

-- 2.a. Which specialty had the most total number of claims (totaled over all drugs)?
SELECT specialty_description, SUM(total_claim_count) AS total_of_claims
FROM prescriber 
INNER JOIN prescription 
ON prescriber.npi =  prescription.npi
GROUP BY specialty_description
ORDER BY total_of_claims DESC;
--Answer is Family Practice with 9,752,347

-- b. Which specialty had the most total number of claims for opioids?
SELECT specialty_description,  SUM(total_claim_count) AS claim_amount
FROM prescription
INNER JOIN prescriber
USING(npi)
INNER JOIN drug
USING(drug_name)
WHERE opioid_Drug_flag ='Y'
GROUP BY specialty_description
ORDER BY claim_amount DESC;
--Answer is Nurse Practitioner with 900,845 total number of claims


-- c. Challenge Question: Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?

-- d. Difficult Bonus: Do not attempt until you have solved all other problems! For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?

-- 3.a. Which drug (generic_name) had the highest total drug cost?
SELECT SUM(total_drug_cost) AS drug_cost, generic_name
FROM drug
INNER JOIN prescription
USING(drug_name)
GROUP BY generic_name
ORDER BY drug_cost DESC;
--answer is Insulin with a cost of 104,264,066.35

-- b. Which drug (generic_name) has the hightest total cost per day? Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.
SELECT ROUND(SUM(total_drug_cost) / 365,2) AS prescript_cost, generic_name
FROM drug
INNER JOIN prescription 
USING(drug_name)
GROUP BY generic_name
ORDER BY prescript_cost DESC
--Answer Insulin with a cost of 285,654.98

-- 4.a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs.
SELECT  drug_name, 
CASE 
	WHEN opioid_drug_flag = 'Y' THEN 'opioid' 
	WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	ELSE 'neither' 
	END AS drug_type 
FROM drug;

-- b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision. 
SELECT  SUM(total_drug_cost), 
CASE 
	WHEN opioid_drug_flag = 'Y' THEN 'opioid' 
	WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
	ELSE 'neither' 
	END AS drug_type 
FROM drug
INNER JOIN prescription
USING (drug_name)
WHERE opioid_drug_flag = 'Y' 
OR antibiotic_drug_flag = 'Y'
GROUP BY antibiotic_drug_flag, opioid_drug_flag
--answer Much more was spent on opioids with the total as 105,080,626.37

-- 5.a. How many CBSAs are in Tennessee? Warning: The cbsa table contains information for all states, not just Tennessee.

-- b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.

-- c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.

-- 6.a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.

-- b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.

-- c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.

-- 7.The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. Hint: The results from all 3 parts will have 637 rows.

-- a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Managment') in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). Warning: Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.

-- b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).

-- c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.


--BONUS--
-- 1.How many npi numbers appear in the prescriber table but not in the prescription table?



-- 2.a. Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Family Practice.

-- b. Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Cardiology.

-- c. Which drugs are in the top five prescribed by Family Practice prescribers and Cardiologists? Combine what you did for parts a and b into a single query to answer this question.

-- 3.Your goal in this question is to generate a list of the top prescribers in each of the major metropolitan areas of Tennessee. a. First, write a query that finds the top 5 prescribers in Nashville in terms of the total number of claims (total_claim_count) across all drugs. Report the npi, the total number of claims, and include a column showing the city.

-- b. Now, report the same for Memphis.

-- c. Combine your results from a and b, along with the results for Knoxville and Chattanooga.

-- 4.Find all counties which had an above-average number of overdose deaths. Report the county name and number of overdose deaths.

-- 5.a. Write a query that finds the total population of Tennessee.

-- b. Build off of the query that you wrote in part a to write a query that returns for each county that county's name, its population, and the percentage of the total population of Tennessee that is contained in that county.