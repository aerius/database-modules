/*
 * pr_build_receptors_to_critical_deposition_areas
 * -----------------------------------------------
 * Procedure to fill the receptors_to_critical_deposition_areas table.
 *
 * The coverage of the habitat on each receptor is calculated by looking at the intersection of the habitat areas that intersect the receptor.
 * See {@link ae_determine_habitat_coverage_on_hexagon} for the calculation method.
 */
CREATE OR REPLACE PROCEDURE pr_build_receptors_to_critical_deposition_areas(v_assessment_area_id integer, v_critical_deposition_area_type text)
LANGUAGE 'plpgsql'
AS $BODY$

BEGIN

	RAISE NOTICE 'Appending data to receptors_to_critical_deposition_areas data table for assessment_area_id = %, and type = %, @ %', v_assessment_area_id, v_critical_deposition_area_type, timeofday();	

	EXECUTE $$

	INSERT INTO receptors_to_critical_deposition_areas_tolerance (assessment_area_id, type, critical_deposition_area_id, receptor_id, zoom_level, is_robust_intersect, surface, receptor_habitat_coverage)
	WITH habitat_original AS (
		SELECT
			assessment_area_id,
			type,
			critical_deposition_area_id,
			(ae_determine_hexagon_intersections(geometry)).receptor_id,
			(ae_determine_hexagon_intersections(geometry)).surface,
			(ae_determine_hexagon_intersections(geometry)).zoom_level
	
			FROM nature.critical_deposition_areas

			WHERE 
				assessment_area_id = $$ || v_assessment_area_id || $$
				AND type = '$$ || v_critical_deposition_area_type || $$'
	), habitat_reduced AS (
		SELECT
			assessment_area_id,
			type,
			critical_deposition_area_id,
			(ae_determine_hexagon_intersections(geometry_buffered)).receptor_id,
			(ae_determine_hexagon_intersections(geometry_buffered)).zoom_level
			
			FROM nature.critical_deposition_areas

			WHERE 
				assessment_area_id = $$ || v_assessment_area_id || $$
				AND type = '$$ || v_critical_deposition_area_type || $$'
	)
	SELECT
		assessment_area_id,
		type,
		critical_deposition_area_id,
		original.receptor_id,
		zoom_level,
		reduced.receptor_id IS NOT NULL AS is_robust_intersect,
		surface,
		ae_determine_habitat_coverage_on_hexagon(assessment_area_id, type, critical_deposition_area_id, receptor_id, zoom_level::integer) AS receptor_habitat_coverage
	
		FROM habitat_original AS original
			LEFT JOIN habitat_reduced AS reduced USING (assessment_area_id, type, critical_deposition_area_id, receptor_id, zoom_level)
	;
	$$;

COMMIT;
END;
$BODY$;
