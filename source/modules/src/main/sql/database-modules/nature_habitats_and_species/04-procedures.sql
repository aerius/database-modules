/*
 * pr_build_critical_deposition_areas
 * ----------------------------------
 * Procedure to fill the critical_deposition_areas table.
 */
CREATE OR REPLACE PROCEDURE pr_build_critical_deposition_areas(v_assessment_area_id integer)
LANGUAGE 'plpgsql'
AS $BODY$

BEGIN

	RAISE NOTICE 'Appending data to critical_deposition_areas data table for assessment_area_id = %, @ %', v_assessment_area_id, timeofday();	

	EXECUTE $$
	INSERT INTO critical_deposition_areas 
		(assessment_area_id, type, critical_deposition_area_id, name, description, relevant, geometry, geometry_buffered)
	SELECT
		assessment_area_id,
		'habitat'::public.critical_deposition_area_type AS type,
		habitat_type_id AS critical_deposition_area_id,
		name,
		description,
		FALSE AS relevant, -- These are NOT the relevant_habitats
		geometry,
		ST_buffer(geometry, system.constant('INTERSECTION_TOLERANCE')::numeric)

		FROM nature.habitats
			INNER JOIN nature.habitat_types USING (habitat_type_id)

		WHERE assessment_area_id = $$ || v_assessment_area_id || $$
	UNION ALL
	SELECT
		assessment_area_id,
		'relevant_habitat'::public.critical_deposition_area_type AS type,
		habitat_type_id AS critical_deposition_area_id,
		name,
		description,
		TRUE AS relevant, -- These are the relevant_habitats
		geometry,
		ST_buffer(geometry, system.constant('INTERSECTION_TOLERANCE')::numeric)

		FROM nature.relevant_habitats
			INNER JOIN nature.habitat_types USING (habitat_type_id)

		WHERE assessment_area_id = $$ || v_assessment_area_id || $$
	;
	$$;

COMMIT;
END;
$BODY$;
