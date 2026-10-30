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
		(ae_determine_hexagon_intersections(geometry_buffered)).receptor_id,
		(ae_determine_hexagon_intersections(geometry_buffered)).zoom_level

		FROM nature.assessment_areas

		WHERE assessment_areas.type = 'natura2000_area'
)
SELECT
	assessment_area_id,
	original.receptor_id,
	reduced.receptor_id IS NOT NULL AS is_robust_intersect,
	zoom_level,
	surface

	FROM n2k_original AS original
		LEFT JOIN n2k_reduced AS reduced USING (assessment_area_id, receptor_id, zoom_level)
;
