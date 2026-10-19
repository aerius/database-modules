SELECT system.store_table('grid.receptors_to_assessment_areas', '{data_folder}/export/{tablename}_{datesuffix}.txt');

SELECT system.store_query(
	'grid.receptors_to_assessment_areas',
	$$ SELECT
		receptor_id,
		assessment_area_id,
		zoom_level,
		surface

		FROM receptors_to_assessment_areas

		WHERE is_robust_intersect IS TRUE

		ORDER BY
			receptor_id,
			assessment_area_id,
			zoom_level
	$$,
	'{data_folder}/export/{tablename}_{datesuffix}.txt'
);


SELECT system.store_table('grid.receptors_to_critical_deposition_areas', '{data_folder}/export/{tablename}_{datesuffix}.txt');

SELECT system.store_query(
	'grid.receptors_to_critical_deposition_areas',
	$$ SELECT
		assessment_area_id,
		type,
		critical_deposition_area_id,
		receptor_id,
		zoom_level,
		surface,
		receptor_habitat_coverage

		FROM receptors_to_critical_deposition_areas

		WHERE is_robust_intersect IS TRUE

		ORDER BY
			assessment_area_id,
			type,
			critical_deposition_area_id,
			receptor_id,
			zoom_level
	$$,
	'{data_folder}/export/{tablename}_{datesuffix}.txt'
);
