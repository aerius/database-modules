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
