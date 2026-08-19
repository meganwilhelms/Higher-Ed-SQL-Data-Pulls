/*
This report pulls student level data for each term the student is enrolled in. To be used to calculate gpa and ccr in power bi.
By: Megan Wilhelms
Created: 6/18/2026
*/

WITH Courses AS (
	SELECT sch.id_num, sch.YR_CDE, sch.TRM_CDE,
	CASE WHEN GRADE_CDE in ('A', 'B', 'C') THEN HRS_EARNED ELSE 0 END AS Pass_Hrs_Earned, HRS_ATTEMPTED
	FROM TmsEPrd.dbo.STUDENT_CRS_HIST sch
	WHERE sch.TRANSACTION_STS != 'D' AND sch.YR_CDE>2020 and sch.TRM_CDE in ('30', '40', '60')
),
Course_summary AS (
	SELECT id_num, YR_CDE, TRM_CDE, SUM(Pass_Hrs_Earned) AS Tot_Hrs_Earned, SUM(HRS_ATTEMPTED) AS Tot_Hrs_Attempted
	FROM Courses
	GROUP BY ID_NUM, YR_CDE, TRM_CDE
)
SELECT stsd.id_num, stsd.YR_CDE, stsd.TRM_CDE, STSD.TRM_QUAL_PTS, STSD.TRM_HRS_GPA, Tot_Hrs_Earned, Tot_Hrs_Attempted, hrs_enrolled, TRM_HRS_EARNED,
	CASE WHEN MAJOR_1 in ('BAD', 'BADOL') THEN 'BAD'
		WHEN MAJOR_1 in ('BSBAD', 'BSBAO') THEN 'BSBAD'
		WHEN MAJOR_1 in ('CIS', 'CIT') THen 'CIS'
		WHEN MAJOR_1 IN ('CJAAO', 'CJU') THEN 'CJU'
		WHEN MAJOR_1 in ('BSCJO', 'BSCJU') THEN 'BSCJU'
		WHEN MAJOR_1 IN ('GENA', 'GENOL') THEN 'GENA'
		WHEN MAJOR_1 IN ('HSS', 'SWK') THEN 'SWK' --note: if a program has an acronym change then add it here so the different spellings are listed as one major 
		ELSE MAJOR_1
		END AS MAJOR_1,
		 st.Seq_Num, st.AcadYear, st.Term
from TmsEPrd.dbo.STUD_TERM_SUM_DIV stsd
	LEFT JOIN TmsEPrd.[UTTC\mwilhelms].Sequential_Terms st ON stsd.YR_CDE=st.YR_CDE AND stsd.TRM_CDE=st.TRM_CDE
	LEFT JOIN Course_summary ON stsd.ID_NUM=Course_summary.ID_NUM AND stsd.YR_CDE=Course_summary.YR_CDE AND stsd.TRM_CDE=Course_summary.TRM_CDE
where stsd.YR_CDE>2020  and HRS_ENROLLED>0 and stsd.TRM_CDE in ('30', '40', '60')
