BEGIN; SELECT system.load_table('habitat_types', '{data_folder}/common/nature_habitats_and_species/26/nature.habitat_types_20230619.txt'); COMMIT;
BEGIN; SELECT system.load_table('habitat_type_critical_levels', '{data_folder}/common/nature_habitats_and_species/26/nature.habitat_type_critical_levels_20231120.txt'); COMMIT;
BEGIN; SELECT system.load_table('habitat_properties', '{data_folder}/common/nature_habitats_and_species/26/nature.habitat_properties_20260430.txt'); COMMIT;
BEGIN; SELECT system.load_table('habitat_type_relations', '{data_folder}/common/nature_habitats_and_species/26/nature.habitat_type_relations_20230619.txt'); COMMIT;

BEGIN; SELECT system.load_table('habitat_areas', '{data_folder}/common/nature_habitats_and_species/26/nature.habitat_areas_20260514.txt'); COMMIT;

BEGIN; SELECT system.load_table('species', '{data_folder}/common/nature_habitats_and_species/26/nature.species_20260430.txt'); COMMIT;
BEGIN; SELECT system.load_table('species_properties', '{data_folder}/common/nature_habitats_and_species/26/nature.species_properties_20260430.txt'); COMMIT;
BEGIN; SELECT system.load_table('designated_species', '{data_folder}/common/nature_habitats_and_species/26/nature.designated_species_20260430.txt'); COMMIT;

BEGIN; SELECT system.load_table('species_to_habitats', '{data_folder}/common/nature_habitats_and_species/26/nature.species_to_habitats_20260512.txt'); COMMIT;

-- Add geometry_buffered column to habitat_areas, fill and place index.
ALTER TABLE habitat_areas ADD COLUMN geometry_buffered geometry(MultiPolygon);
UPDATE habitat_areas SET geometry_buffered = ST_Buffer(geometry, system.constant('INTERSECTION_TOLERANCE')::numeric);
CREATE INDEX idx_habitat_areas_geometry_buffered_gist ON habitat_areas USING GIST (geometry_buffered);
