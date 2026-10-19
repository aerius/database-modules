--
-- habitats and species
--
SELECT system.raise_notice('Build: relevant_habitat_areas @ ' || timeofday());
DO
$$
DECLARE v_assessment_area_id integer;
BEGIN

	FOR v_assessment_area_id IN (SELECT assessment_area_id FROM nature.assessment_areas WHERE type = 'natura2000_area' ORDER BY assessment_area_id desc)
	LOOP
		CALL pr_build_relevant_habitat_areas(v_assessment_area_id);
	END LOOP;

END
$$;