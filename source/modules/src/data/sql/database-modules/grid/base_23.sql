BEGIN; SELECT system.load_table('grid.receptors', '{data_folder}/public/receptors_20230511.txt', FALSE); COMMIT;
BEGIN; SELECT system.load_table('grid.hexagons', '{data_folder}/public/hexagons_20230511.txt', FALSE); COMMIT;
BEGIN; SELECT system.load_table('grid.non_exceeding_receptors', '{data_folder}/public/non_exceeding_receptors_20230822.txt'); COMMIT;
