--determine gateway completed in the first term	
	
	SELECT DISTINCT sch.id_num, 
		CASE WHEN sch.CRS_CDE = 'GPE  104  OL' THEN 'GPE  104  A'
		ELSE CRS_CDE END AS crs_cde,
		sch.YR_CDE, sch.TRM_CDE, stsd.MAJOR_1, stsd.MAJOR_2, sch.GRADE_CDE, sch.CREDIT_HRS, sch.HRS_EARNED, 
		CASE  
			WHEN stsd.MAJOR_1 = 'AUT' AND SCH.CRS_CDE LIKE 'MTH  101%' THEN 'MG'
			WHEN stsd.MAJOR_1 in ('BAD', 'BADOL', 'IFA') AND (sch.CRS_CDE like 'MTH  102%' OR sch.crs_cde like 'MTH  103%' OR sch.CRS_CDE like 'MTH  104%') THEN 'MG'
			WHEN stsd.MAJOR_1 in ('CIT', 'CIS') AND (sch.CRS_CDE like 'MTH  103%') THEN 'MG'
			WHEN stsd.MAJOR_1 in ('EDU', 'GENA', 'GENO', 'GENOL', 'HPR', 'PAR', 'CJU', 'CJAAO', 'ADS', 'AGR') AND SCH.CRS_CDE LIKE 'MTH  102%' THEN 'MG'
			WHEN stsd.MAJOR_1 in ('BSBAD', 'BSBAO', 'BSEDU') AND (SCH.CRS_CDE LIKE 'MTH  103%' OR SCH.CRS_CDE LIKE 'MTH  104%') THEN 'MG'
			WHEN STSD.MAJOR_1 IN ('BSCJU', 'BSCJO', 'SWK', 'SWKAS', 'HSS') AND (sch.CRS_CDE like 'MTH  103%' OR sch.crs_cde like 'MTH  104%' OR sch.CRS_CDE like 'MTH  210%') THEN 'MG'
			WHEN stsd.MAJOR_1 IN ('BSESR', 'ESR', 'FWAS', 'FWBS') AND SCH.CRS_CDE LIKE 'MTH  107%' THEN 'MG'
			WHEN STSD.MAJOR_1 IN ('ENVR', 'ENR') AND SCH.CRS_CDE LIKE 'MTH  165%' THEN 'MG'
			WHEN stsd.MAJOR_1 = 'INDL' AND (SCH.CRS_CDE LIKE 'MTH  102%' OR SCH.CRS_CDE LIKE 'MTH  103%' OR SCH.CRS_CDE LIKE 'MTH  104%' OR SCH.CRS_CDE LIKE 'MTH  210%') THEN 'MG'
			WHEN stsd.MAJOR_1 IN ('AUTDL', 'HEOC', 'WLD') AND SCH.CRS_CDE LIKE 'MTH  106%' THEN 'MG'
			WHEN stsd.MAJOR_1 = 'AUTDL' AND SCH.CRS_CDE LIKE 'ENG  105%' THEN 'E'
			WHEN SCH.CRS_CDE LIKE 'ENG  110%' THEN 'E'
			WHEN STSD.MAJOR_1 IN ('ADS', 'AGR', 'BAD', 'BADOL', 'GENA', 'GENOL', 'GENO', 'HPR', 'PAR', 'INDL', 'IFA', 'CJAAO', 'CJU') AND SCH.CRS_CDE LIKE 'MTH  101%' THEN 'MP'
			WHEN STSD.MAJOR_1 IN ('CIT', 'CIS', 'HSS', 'ESR', 'SWK', 'SWKAS','FWAS', 'BSBAD', 'BSBAO', 'BSCJU', 'BSCJO', 'BSESR', 'FWBS') AND (SCH.CRS_CDE LIKE 'MTH  101%' OR SCH.CRS_CDE LIKE 'MTH  102%') THEN 'MP'
			WHEN STSD.MAJOR_1 IN ('ENR', 'ENVR') AND (SCH.CRS_CDE LIKE 'MTH  101%' OR SCH.CRS_CDE LIKE 'MTH  102%' OR SCH.CRS_CDE LIKE 'MTH  107%') THEN 'MP'

		END AS MathEnglishGateway
	FROM TmsEPrd.dbo.STUD_TERM_SUM_DIV stsd
			left join TmsEPrd.dbo.STUDENT_CRS_HIST sch on stsd.ID_NUM=sch.ID_NUM, 
		TmsEPrd.dbo.REG_CONFIG rg, 
		TmsEPrd.dbo.STUDENT_MASTER sm
	WHERE stsd.YR_CDE = 2024 AND stsd.TRM_CDE in ('40') AND (CRS_CDE like 'ENG%') AND 
		sch.ID_NUM=sm.ID_NUM  AND sch.ID_NUM=stsd.ID_NUM AND stsd.YR_CDE=sch.YR_CDE AND stsd.TRM_CDE=sch.TRM_CDE AND
		(rg.reg_config_cde = '1' AND  
		sch.transaction_sts in ('C', 'H', 'P', 'R', 'W') AND 
				(((sm.hold_1_cde is NULL OR sm.hold_1_cde = '') AND (sm.hold_2_cde is NULL OR sm.hold_2_cde = '') AND (sm.hold_3_cde is NULL OR sm.hold_3_cde = '') AND  
				(sm.hold_4_cde is NULL OR sm.hold_4_cde = '') AND (sm.hold_5_cde is NULL OR sm.hold_5_cde = '') AND (sm.hold_6_cde is NULL OR sm.hold_6_cde = '')) OR  
rg.clas_lst_incl_hold = 'Y'))
