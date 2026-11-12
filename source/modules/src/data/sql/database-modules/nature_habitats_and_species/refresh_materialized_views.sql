-- Refresh all materialized views
BEGIN; REFRESH MATERIALIZED VIEW habitats; COMMIT;
BEGIN; REFRESH MATERIALIZED VIEW relevant_habitats; COMMIT;
