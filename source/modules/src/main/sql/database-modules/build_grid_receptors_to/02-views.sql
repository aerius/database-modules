/*
 * build_receptors_to_assessment_areas_view
 * ----------------------------------------
 * View to fill the receptors_to_assessment_areas table.
 */
CREATE OR REPLACE VIEW build_receptors_to_assessment_areas_view AS
WITH n2k_original AS (
	SELECT
		assessment_area_id,
		(ae_determine_hexagon_intersections(geometry)).receptor_id,
		(ae_determine_hexagon_intersections(geometry)).surface,
		(ae_determine_hexagon_intersections(geometry)).zoom_level

		FROM nature.assessment_areas

		WHERE assessment_areas.type = 'natura2000_area'
), n2k_reduced AS (
	SELECT
		assessment_area_id,
		(ae_determine_hexagon_intersections(ST_Buffer(geometry, system.constant('INTERSECTION_TOLERANCE')::numeric))).receptor_id,
		(ae_determine_hexagon_intersections(ST_Buffer(geometry, system.constant('INTERSECTION_TOLERANCE')::numeric))).zoom_level

		FROM nature.assessment_areas

		WHERE assessment_areas.type = 'natura2000_area'
)
SELECT
	assessment_area_id,
	original.receptor_id,
	CASE WHEN reduced.receptor_id IS NOT NULL AND original.zoom_level = reduced.zoom_level THEN TRUE
		WHEN reduced.receptor_id IS NULL THEN FALSE
	ELSE NULL END AS is_robust_intersect,
	zoom_level,
	surface

	FROM n2k_original AS original
		LEFT JOIN n2k_reduced AS reduced USING (assessment_area_id, receptor_id, zoom_level)
;
