-- Refresh buffered materialized views correlated to assessment_areas
SET search_path TO 'nature', 'public';
BEGIN; REFRESH MATERIALIZED VIEW assessment_areas_buffered; COMMIT;


-- build
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

		FROM build_receptors_to_assessment_areas_tolerance_view
		
		WHERE assessment_area_id = {assessment_area_id}
	;

{/multithread}


-- Fill the original table with the data where tolerance has been taken into account
BEGIN;
	SET search_path TO 'grid', 'public';
	INSERT INTO receptors_to_assessment_areas (receptor_id, assessment_area_id, zoom_level, surface)
	SELECT
		receptor_id,
		assessment_area_id,
		zoom_level,
		surface

		FROM receptors_to_assessment_areas_tolerance

		WHERE is_robust_intersect IS TRUE

		ORDER BY
			receptor_id,
			assessment_area_id,
			zoom_level
	;
COMMIT;


SELECT system.raise_notice('Build: critical_deposition_areas @ ' || timeofday());
BEGIN;
	SET search_path TO 'nature', 'public';
	INSERT INTO critical_deposition_areas_buffered (assessment_area_id, type, critical_deposition_area_id, name, description, relevant, geometry)
	SELECT 
		assessment_area_id,
		type,
		critical_deposition_area_id,
		name,
		description,
		relevant,
		geometry,
		ae_get_buffered_geometry(geometry)

		FROM critical_deposition_areas_view 
	;
COMMIT;


SELECT system.raise_notice('Build: receptors_to_critical_deposition_areas @ ' || timeofday());
{multithread on: SELECT assessment_area_id, critical_deposition_area_type FROM nature.assessment_areas CROSS JOIN (SELECT unnest(enum_range(null::public.critical_deposition_area_type)) AS critical_deposition_area_type) AS types WHERE type = 'natura2000_area' ORDER BY assessment_area_id, critical_deposition_area_type }

	-- For the executed multi thread code execution the import_common_into_schema search path schema is not set.
	-- This is the only way I could find to make this code work.
	SET search_path TO 'grid', 'public';
	INSERT INTO receptors_to_critical_deposition_areas_tolerance (assessment_area_id, type, critical_deposition_area_id, receptor_id, zoom_level, is_robust_intersect, surface, receptor_habitat_coverage)
	SELECT 
		assessment_area_id,
		type,
		critical_deposition_area_id,
		receptor_id,
		zoom_level,
		is_robust_intersect,
		surface,
		receptor_habitat_coverage

		FROM build_receptors_to_critical_deposition_areas_tolerance_view 
		
		WHERE 
			assessment_area_id = {assessment_area_id}
			AND type = '{critical_deposition_area_type}'
	;

{/multithread}


-- Fill the original table with the data where tolerance has been taken into account
BEGIN;
	SET search_path TO 'grid', 'public';
	INSERT INTO receptors_to_critical_deposition_areas (assessment_area_id, type, critical_deposition_area_id, receptor_id, zoom_level, surface, receptor_habitat_coverage)
	SELECT
		assessment_area_id,
		type,
		critical_deposition_area_id,
		receptor_id,
		zoom_level,
		surface,
		receptor_habitat_coverage

		FROM receptors_to_critical_deposition_areas_tolerance

		WHERE is_robust_intersect IS TRUE

		ORDER BY
			assessment_area_id,
			type,
			critical_deposition_area_id,
			receptor_id,
			zoom_level
	;
COMMIT;
