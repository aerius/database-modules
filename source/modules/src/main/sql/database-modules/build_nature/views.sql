/*
 * designated_habitats_view
 * ------------------------
 * View to determine the designated habitat types per assessment area.
 * Relationships based on the habitat_type_relations are taken into account.
 */
CREATE OR REPLACE VIEW designated_habitats_view AS
SELECT
	assessment_area_id,
	habitat_type_id

	FROM habitat_properties
 		INNER JOIN habitat_type_relations USING (goal_habitat_type_id)

	WHERE NOT (quality_goal = 'none' AND extent_goal = 'none')
;


/*
 * habitat_type_sensitivity_view
 * -----------------------------
 * View returning the (nitrogen) sensitiveness of a habitat type.
 */
CREATE OR REPLACE VIEW habitat_type_sensitivity_view AS
SELECT
	habitat_type_id,
	bool_or(sensitive) AS sensitive

	FROM habitat_type_critical_levels

	GROUP BY habitat_type_id
;


/*
 * designated_species_to_habitats_view
 * -----------------------------------
 * View to determine the designated (bird) species per habitat type and assessment area.
 * Relationships based on the habitat_type_relations are taken into account.
 */
CREATE OR REPLACE VIEW designated_species_to_habitats_view AS
SELECT
	species_id,
	assessment_area_id,
	habitat_type_id

	FROM species_to_habitats
		INNER JOIN habitat_type_relations USING (goal_habitat_type_id)
		INNER JOIN designated_species USING (species_id, assessment_area_id)
;
