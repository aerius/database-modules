BEGIN; SELECT system.load_table('countries', '{data_folder}/common/nature_areas/26/nature.countries_20150721.txt', FALSE); COMMIT;
BEGIN; SELECT system.load_table('authorities', '{data_folder}/common/nature_areas/26/nature.authorities_20260817.txt'); COMMIT;

BEGIN; SELECT system.load_table('natura2000_areas', '{data_folder}/common/nature_areas/26/nature.natura2000_areas_20260511.txt'); COMMIT;
BEGIN; SELECT system.load_table('natura2000_area_properties', '{data_folder}/common/nature_areas/26/nature.natura2000_area_properties_20260511.txt'); COMMIT;

BEGIN; SELECT system.load_table('natura2000_directives', '{data_folder}/common/nature_areas/26/nature.natura2000_directives_20220328.txt'); COMMIT;
BEGIN; SELECT system.load_table('natura2000_directive_areas', '{data_folder}/common/nature_areas/26/nature.natura2000_directive_areas_20260511.txt'); COMMIT;

-- Add geometry_buffered column to assessment_areas, fill and place index.
ALTER TABLE assessment_areas ADD COLUMN geometry_buffered geometry(MultiPolygon);
UPDATE assessment_areas SET geometry_buffered = ST_Buffer(geometry, system.constant('INTERSECTION_TOLERANCE')::numeric);
CREATE INDEX idx_assessment_areas_geometry_buffered_gist ON assessment_areas USING GIST (geometry_buffered);