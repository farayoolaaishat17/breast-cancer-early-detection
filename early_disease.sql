CREATE DATABASE early_disease;
USE early_disease;

-- BASE VIEW
CREATE VIEW vw_base_breast_cancer AS
SELECT
	id,
    diagnosis,
    radius_mean,
    perimeter_mean,
    area_mean,
    concavity_mean,
    concave_points_mean,
    radius_worst,
    perimeter_worst,
    area_worst,
    concavity_worst,
    concave_points_worst
FROM breast_cancer;

-- ANALYTICAL VIEWS
-- 1 Tumor Distribution Analysis
CREATE VIEW vw_tumor_distribution AS
SELECT
	diagnosis,
    COUNT(*) AS tumor_count
FROM vw_base_breast_cancer
GROUP BY diagnosis;

-- 2 Tumor Percentage Analysis
CREATE VIEW vw_tumor_percentage AS 
SELECT
	diagnosis,
    COUNT(*) AS tumor_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM vw_base_breast_cancer), 2) AS percentage
FROM vw_base_breast_cancer
GROUP BY diagnosis;

-- 3 Feature Comparison by Tumor Type
CREATE VIEW vw_feature_comparison AS
SELECT 
	diagnosis,
    ROUND(AVG(perimeter_worst), 2) AS avg_perimeter_worst,
    ROUND(AVG(area_worst), 2) AS avg_area_worst,
    ROUND(AVG(concave_points_worst), 2) AS avg_concave_points_worst,
    ROUND(AVG(radius_worst), 2) AS avg_radius_worst
FROM vw_base_breast_cancer
GROUP BY diagnosis;

-- 4 Feature Statistics Analysis
CREATE VIEW vw_feature_statistics AS 
SELECT 
	MIN(perimeter_worst) AS min_perimeter,
    MAX(perimeter_worst) AS max_perimeter,
    ROUND(AVG(perimeter_worst), 2) AS avg_perimeter,
    
    MIN(area_worst) AS min_area,
    MAX(area_worst) AS max_area,
    ROUND(AVG(area_worst), 2) AS avg_area,
    
    MIN(concave_points_worst) AS min_concave_points,
    MAX(concave_points_worst) AS max_concave_points,
    ROUND(AVG(concave_points_worst), 2) AS avg_concave_points
FROM vw_base_breast_cancer;

-- 5 Feature Importance
CREATE VIEW vw_feature_importance AS
SELECT feature, importance, importance_pct
FROM feature_importance
ORDER BY importance_pct DESC;

-- KPI VIEWS
-- 1 Total Records
CREATE VIEW vw_kpi_total_records AS
SELECT 
	COUNT(*) AS total_records
FROM vw_base_breast_cancer;

-- 2 Total Benign Tumors
CREATE VIEW vw_kpi_total_benign AS
SELECT
	COUNT(*) AS total_benign
FROM vw_base_breast_cancer
WHERE diagnosis = 'B';

-- 3 Total Malignant Tumors
CREATE VIEW vw_kpi_total_malignant AS
SELECT
	COUNT(*) AS total_malignant
FROM vw_base_breast_cancer
WHERE diagnosis = 'M';

-- 4 Percentage Benign
CREATE VIEW vw_kpi_pct_benign AS
SELECT
	ROUND((COUNT(CASE WHEN diagnosis = 'B' THEN 1 END) * 100.0) / COUNT(*), 2) AS pct_benign
FROM vw_base_breast_cancer;

-- 5 Percentage Malignant
CREATE VIEW vw_kpi_pct_malignant AS
SELECT
	ROUND((COUNT(CASE WHEN diagnosis = 'M' THEN 1 END) * 100.0) / COUNT(*), 2) AS pct_malignant
FROM vw_base_breast_cancer;

