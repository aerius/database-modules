{import_common 'database-modules/nature_habitats_and_species/supplied_23.sql'}

-- Generated data
BEGIN; SELECT system.load_table('nature.relevant_habitat_areas', '{data_folder}/common/nature_habitats_and_species/23/nature.relevant_habitat_areas_20230704.txt', FALSE); COMMIT;
BEGIN; SELECT system.load_table('nature.habitats', '{data_folder}/common/nature_habitats_and_species/23/nature.habitats_20230704.txt', FALSE); COMMIT;
BEGIN; SELECT system.load_table('nature.relevant_habitats', '{data_folder}/common/nature_habitats_and_species/23/nature.relevant_habitats_20230704.txt', FALSE); COMMIT;
