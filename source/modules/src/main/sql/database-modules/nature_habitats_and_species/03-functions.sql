/*
 * ae_critical_deposition_classification
 * -------------------------------------
 * Function to determine the critical deposition classification based on critical deposition value (KDW).
 * Current classification:
 * - Highly sensitive: < 1400
 * - Sensitive: 1400 <= KDW < 2400
 * - Lowly/not sensitive: >= 2400
 */
CREATE OR REPLACE FUNCTION ae_critical_deposition_classification(critical_deposition posnum)
	RETURNS text AS
$BODY$
	SELECT (SELECT CASE 
		WHEN (critical_deposition < 1400) THEN 'high_sensitivity'::critical_deposition_classification
		WHEN (critical_deposition >= 2400) THEN 'low_sensitivity'::critical_deposition_classification
		ELSE 'normal_sensitivity'::critical_deposition_classification
	END CASE)::text;
$BODY$
LANGUAGE sql IMMUTABLE;


/*
 * ae_build_critical_deposition_areas
 * ----------------------------------
 * Function to fill the critical_deposition_areas table.
 */
CREATE OR REPLACE FUNCTION ae_build_critical_deposition_areas(v_assessment_area_id integer)
	RETURNS TABLE (assessment_area_id integer, type public.critical_deposition_area_type, critical_deposition_area_id integer, name text, description text, relevant boolean, geometry geometry(MultiPolygon), geometry_buffered geometry(MultiPolygon) )
AS $BODY$

BEGIN
	
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
$BODY$
LANGUAGE sql VOLATILE;
