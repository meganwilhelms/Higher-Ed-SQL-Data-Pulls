/*This query is a work in progress and has not been used yet. 
This query pulls in courses brought in by students through transfers and determines if the transfer course meets the gateway requirements for their current major.
*/ 
With transfer_courses AS (	
	SELECT DISTINCT sch.id_num, 
				sch.YR_CDE, sch.TRM_CDE, stsd.MAJOR_1, stsd.MAJOR_2, sch.ADV_REQ_CDE, 
				LEFT(sch.ADV_REQ_CDE,3) + SPACE(2) + RIGHT(sch.ADV_REQ_CDE,3) AS crs_cde,
				sch.GRADE_CDE, sch.CREDIT_HRS, sch.HRS_EARNED
	FROM TmsEPrd.dbo.STUD_TERM_SUM_DIV stsd
	left join TmsEPrd.dbo.STUDENT_CRS_HIST sch on stsd.ID_NUM=sch.ID_NUM AND sch.YR_CDE = 1900 AND sch.TRM_CDE in ('01'),
	TmsEPrd.dbo.REG_CONFIG rg, TmsEPrd.dbo.STUDENT_MASTER sm
	WHERE stsd.YR_CDE > 2021 AND (ADV_REQ_CDE like 'ENG%' OR ADV_REQ_CDE like 'MTH%') AND GRADE_CDE = 'TR' ------UPDATE THE YEAR HERE IF LOOKING AT COURSES FURTHER BACK
		 AND sch.ID_NUM=sm.ID_NUM  AND 
		(rg.reg_config_cde = '1' AND  
		sch.transaction_sts in ('C', 'H', 'P', 'R', 'W') AND 
				(((sm.hold_1_cde is NULL OR sm.hold_1_cde = '') AND (sm.hold_2_cde is NULL OR sm.hold_2_cde = '') AND (sm.hold_3_cde is NULL OR sm.hold_3_cde = '') AND  
				(sm.hold_4_cde is NULL OR sm.hold_4_cde = '') AND (sm.hold_5_cde is NULL OR sm.hold_5_cde = '') AND (sm.hold_6_cde is NULL OR sm.hold_6_cde = '')) OR  
rg.clas_lst_incl_hold = 'Y'))
)

	SELECT DISTINCT stsd.id_num, 
		stsd.YR_CDE, stsd.TRM_CDE, stsd.MAJOR_1, tc.crs_cde,
		CASE  
			WHEN stsd.MAJOR_1 = 'AUT' AND tc.CRS_CDE LIKE 'MTH  101%' THEN 'MG'
			WHEN stsd.MAJOR_1 in ('BAD', 'BADOL', 'IFA') AND (tc.CRS_CDE like 'MTH  102%' OR tc.crs_cde like 'MTH  103%' OR tc.CRS_CDE like 'MTH  104%') THEN 'MG'
			WHEN stsd.MAJOR_1 in ('CIT', 'CIS') AND (tc.CRS_CDE like 'MTH  103%') THEN 'MG'
			WHEN stsd.MAJOR_1 in ('EDU', 'GENA', 'GENO', 'GENOL', 'HPR', 'PAR', 'CJU', 'CJAAO', 'ADS', 'AGR') AND tc.CRS_CDE LIKE 'MTH  102%' THEN 'MG'
			WHEN stsd.MAJOR_1 in ('BSBAD', 'BSBAO', 'BSEDU') AND (tc.CRS_CDE LIKE 'MTH  103%' OR tc.CRS_CDE LIKE 'MTH  104%') THEN 'MG'
			WHEN STSD.MAJOR_1 IN ('BSCJU', 'BSCJO', 'SWK', 'SWKAS', 'HSS') AND (tc.CRS_CDE like 'MTH  103%' OR tc.crs_cde like 'MTH  104%' OR tc.CRS_CDE like 'MTH  210%') THEN 'MG'
			WHEN stsd.MAJOR_1 IN ('BSESR', 'ESR', 'FWAS', 'FWBS') AND tc.CRS_CDE LIKE 'MTH  107%' THEN 'MG'
			WHEN STSD.MAJOR_1 IN ('ENVR', 'ENR') AND tc.CRS_CDE LIKE 'MTH  165%' THEN 'MG'
			WHEN stsd.MAJOR_1 = 'INDL' AND (tc.CRS_CDE LIKE 'MTH  102%' OR tc.CRS_CDE LIKE 'MTH  103%' OR tc.CRS_CDE LIKE 'MTH  104%' OR tc.CRS_CDE LIKE 'MTH  210%') THEN 'MG'
			WHEN stsd.MAJOR_1 IN ('AUTDL', 'HEOC', 'WLD') AND tc.CRS_CDE LIKE 'MTH  106%' THEN 'MG'
			WHEN stsd.MAJOR_1 = 'AUTDL' AND tc.CRS_CDE LIKE 'ENG  105%' THEN 'E'
			WHEN tc.CRS_CDE LIKE 'ENG  110%' THEN 'E'
			WHEN STSD.MAJOR_1 IN ('ADS', 'AGR', 'BAD', 'BADOL', 'GENA', 'GENOL', 'GENO', 'HPR', 'PAR', 'INDL', 'IFA', 'CJAAO', 'CJU') AND tc.CRS_CDE LIKE 'MTH  101%' THEN 'MP'
			WHEN STSD.MAJOR_1 IN ('CIT', 'CIS', 'HSS', 'ESR', 'SWK', 'SWKAS','FWAS', 'BSBAD', 'BSBAO', 'BSCJU', 'BSCJO', 'BSESR', 'FWBS') AND (tc.CRS_CDE LIKE 'MTH  101%' OR tc.CRS_CDE LIKE 'MTH  102%') THEN 'MP'
			WHEN STSD.MAJOR_1 IN ('ENR', 'ENVR') AND (tc.CRS_CDE LIKE 'MTH  101%' OR tc.CRS_CDE LIKE 'MTH  102%' OR tc.CRS_CDE LIKE 'MTH  107%') THEN 'MP'

		END AS MathEnglishGateway
	FROM TmsEPrd.dbo.STUD_TERM_SUM_DIV stsd
			left join transfer_courses tc on stsd.ID_NUM=tc.ID_NUM
	WHERE stsd.YR_CDE = 2024 AND stsd.TRM_CDE in ('40') -----------UPDATE THE CURRENT YEAR AND TERM--------------




