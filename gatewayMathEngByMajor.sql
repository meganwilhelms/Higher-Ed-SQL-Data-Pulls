/*This query looks at all students taking a math or english in the specified term and if the math or english course are a gateway math or english for their major. 
MathEnglishGateway column will list M if the course is a math gateway for the major and E if the course is an English gateway for the major.

*/

DECLARE @YEAR char(4) = '2026' ; --Change this year to the wanted year. 
DECLARE @TERM char(2) = '30'; --Change this term to the wanted term.

SELECT sch.id_num, 
	CASE WHEN sch.CRS_CDE = 'GPE  104  OL' THEN 'GPE  104  A' ELSE CRS_CDE END AS crs_cde,
	sch.YR_CDE, sch.TRM_CDE, stsd.MAJOR_1, stsd.MAJOR_2, sch.GRADE_CDE, sch.CREDIT_HRS, sch.HRS_EARNED, 
		CASE  
			WHEN stsd.MAJOR_1 in ('BAD', 'BADOL', 'IFA') AND (sch.CRS_CDE like 'MTH  102%' OR sch.crs_cde like 'MTH  103%' OR sch.CRS_CDE like 'MTH  104%') THEN 'M'
			WHEN stsd.MAJOR_1 in ('CIT', 'CIS') AND (sch.CRS_CDE like 'MTH  102%' OR sch.CRS_CDE like 'MTH  210%') THEN 'M'
			WHEN stsd.MAJOR_1 in ('EDU', 'GENA', 'GENO', 'GENOL', 'HPR', 'PAR', 'CJU', 'CJAAO', 'ADS', 'AGR') AND SCH.CRS_CDE LIKE 'MTH  102%' THEN 'M'
			WHEN stsd.MAJOR_1 in ('BSBAD', 'BSBAO', 'BSEDU', 'HSS') AND (SCH.CRS_CDE LIKE 'MTH  103%' OR SCH.CRS_CDE LIKE 'MTH  104%') THEN 'M'
			WHEN STSD.MAJOR_1 IN ('BSCJU', 'BSCJO', 'SWK', 'SWKAS') AND (sch.CRS_CDE like 'MTH  103%' OR sch.crs_cde like 'MTH  104%' OR sch.CRS_CDE like 'MTH  210%') THEN 'M'
			WHEN stsd.MAJOR_1 IN ('BSESR', 'ESR') AND SCH.CRS_CDE LIKE 'MTH  107%' THEN 'M'
			WHEN STSD.MAJOR_1 IN ('ENVR', 'ENR') AND SCH.CRS_CDE LIKE 'MTH  165%' THEN 'M'
			WHEN stsd.MAJOR_1 = 'INDL' AND (SCH.CRS_CDE LIKE 'MTH  102%' OR SCH.CRS_CDE LIKE 'MTH  103%' OR SCH.CRS_CDE LIKE 'MTH  104%' OR SCH.CRS_CDE LIKE 'MTH  210%') THEN 'M'
			WHEN stsd.MAJOR_1 IN ('FWAS', 'FWBS') AND SCH.CRS_CDE LIKE 'MTH  107%' THEN 'M'
			WHEN stsd.MAJOR_1 IN ('AUTDL', 'HEOC', 'WLD') AND SCH.CRS_CDE LIKE 'MTH  106%' THEN 'M'
			WHEN stsd.MAJOR_1 = 'AUTDL' AND SCH.CRS_CDE LIKE 'ENG  105%' THEN 'E'
			WHEN SCH.CRS_CDE LIKE 'ENG  110%' THEN 'E'
		END AS MathEnglishGateway
FROM TmsEPrd.dbo.STUD_TERM_SUM_DIV stsd
		LEFT JOIN TmsEPrd.dbo.STUDENT_CRS_HIST sch on stsd.ID_NUM=sch.ID_NUM AND stsd.YR_CDE=sch.YR_CDE AND stsd.TRM_CDE=sch.TRM_CDE
WHERE stsd.YR_CDE = @YEAR AND stsd.TRM_CDE =@TERM AND (CRS_CDE like 'ENG%' OR CRS_CDE like 'MTH%') 
			AND stsd.HRS_ENROLLED>0 AND sch.TRANSACTION_STS != 'D'

