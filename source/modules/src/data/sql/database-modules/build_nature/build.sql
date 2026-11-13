--
-- habitats and species
--
--  Refresh buffered materialized view for habitat_areas
BEGIN; REFRESH MATERIALIZED VIEW habitat_areas_buffered; COMMIT;

SELECT system.raise_notice('Build: relevant_habitat_areas @ ' || timeofday());
BEGIN;
	INSERT INTO relevant_habitat_areas(assessment_area_id, habitat_area_id, habitat_type_id, coverage, geometry)
		SELECT assessment_area_id, habitat_area_id, habitat_type_id, coverage, geometry
		FROM build_relevant_habitat_areas_view;
COMMIT;
