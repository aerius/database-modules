SELECT system.raise_notice('Build: receptors_to_assessment_areas @ ' || timeofday());

{multithread on: SELECT assessment_area_id FROM nature.assessment_areas WHERE type = 'natura2000_area' ORDER BY assessment_area_id}

	-- For the executed multi thread code execution the import_common_into_schema search path schema is not set.
	-- This is the only way I could find to make this code work.
	SET search_path TO 'grid', 'public';

	INSERT INTO receptors_to_assessment_areas_tolerance (receptor_id, assessment_area_id, zoom_level, is_robust_intersect, surface)
	SELECT
		receptor_id,
		assessment_area_id,
		zoom_level,
		is_robust_intersect,
		surface

		FROM build_receptors_to_assessment_areas_view
		
		WHERE assessment_area_id = {assessment_area_id}
	;

{/multithread}


SELECT system.raise_notice('Build: critical_deposition_areas @ ' || timeofday());

{multithread on: SELECT assessment_area_id FROM nature.assessment_areas where type = 'natura2000_area' ORDER BY assessment_area_id}

	-- For the executed multi thread code execution the import_common_into_schema search path schema is not set.
	-- This is the only way I could find to make this code work.
	SET search_path TO 'grid', 'nature', 'public';
	INSERT INTO critical_deposition_areas 
		(assessment_area_id, type, critical_deposition_area_id, name, description, relevant, geometry, geometry_buffered)
	SELECT * FROM ae_build_critical_deposition_areas({assessment_area_id})

{/multithread}


SELECT system.raise_notice('Build: receptors_to_critical_deposition_areas @ ' || timeofday());

{multithread on: SELECT assessment_area_id, critical_deposition_area_type FROM nature.assessment_areas CROSS JOIN (SELECT unnest(enum_range(null::public.critical_deposition_area_type)) AS critical_deposition_area_type) AS types WHERE type = 'natura2000_area' ORDER BY assessment_area_id, critical_deposition_area_type }

	-- For the executed multi thread code execution the import_common_into_schema search path schema is not set.
	-- This is the only way I could find to make this code work.
	SET search_path TO 'grid', 'public';
	CALL pr_build_receptors_to_critical_deposition_areas({assessment_area_id}, '{critical_deposition_area_type}');

{/multithread}
