--
-- habitats and species
--
SELECT system.raise_notice('Build: relevant_habitat_areas @ ' || timeofday());
{multithread on: SELECT assessment_area_id FROM nature.assessment_areas WHERE type = 'natura2000_area' ORDER BY assessment_area_id}

	SET search_path TO 'grid', 'nature', 'public';
	INSERT INTO nature.relevant_habitat_areas 
		(assessment_area_id, habitat_area_id, habitat_type_id, coverage, geometry)
	SELECT * FROM ae_build_relevant_habitat_areas({assessment_area_id});
	
{/multithread}
