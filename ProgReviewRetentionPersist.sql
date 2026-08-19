WITH NewTransfers AS (
SELECT st.Seq_Num, stsd.id_num, stsd.YR_CDE, st.AcadYear, stsd.TRM_CDE, st.Term, STSD.HRS_ENROLLED,
	CASE WHEN MAJOR_1 in ('BAD', 'BADOL') THEN 'BAD'
		WHEN MAJOR_1 in ('BSBAD', 'BSBAO') THEN 'BSBAD'
		WHEN MAJOR_1 in ('CIS', 'CIT') THen 'CIS'
		WHEN MAJOR_1 IN ('CJAAO', 'CJU') THEN 'CJU'
		WHEN MAJOR_1 in ('BSCJO', 'BSCJU') THEN 'BSCJU'
		WHEN MAJOR_1 IN ('GENA', 'GENOL') THEN 'GENA'
		WHEN MAJOR_1 IN ('HSS', 'SWK') THEN 'SWK'
		ELSE MAJOR_1
		END AS MAJOR_1,
	cv.CANDIDACY_TYPE
from TmsEPrd.dbo.STUD_TERM_SUM_DIV stsd
	LEFT JOIN TmsEPrd.dbo.candidacy_v cv ON stsd.ID_NUM=cv.ID_NUM AND stsd.YR_CDE=cv.YR_CDE AND stsd.TRM_CDE=cv.TRM_CDE and cv.CANDIDACY_TYPE in ('N', 'T')
	LEFT JOIN TmsEPrd.[UTTC\mwilhelms].Sequential_Terms st ON stsd.YR_CDE=st.YR_CDE AND stsd.TRM_CDE=st.TRM_CDE
where stsd.YR_CDE>2020  and HRS_ENROLLED>0 and stsd.TRM_CDE in ('30') and cv.CANDIDACY_TYPE is not null),

allStudents AS (
SELECT st.Seq_Num, stsd.id_num, stsd.YR_CDE, stsd.TRM_CDE, cv.CANDIDACY_TYPE
from TmsEPrd.dbo.STUD_TERM_SUM_DIV stsd
	LEFT JOIN TmsEPrd.dbo.candidacy_v cv ON stsd.ID_NUM=cv.ID_NUM AND stsd.YR_CDE=cv.YR_CDE AND stsd.TRM_CDE=cv.TRM_CDE 
	LEFT JOIN TmsEPrd.[UTTC\mwilhelms].Sequential_Terms st ON stsd.YR_CDE=st.YR_CDE AND stsd.TRM_CDE=st.TRM_CDE
where stsd.YR_CDE>2020  and HRS_ENROLLED>0 and stsd.TRM_CDE in ('30', '40') ),

persistence AS (
select a.ID_NUM, a.Seq_Num, b.Seq_Num AS Next_Seq_Num, a.yr_cde, a.trm_cde, a.candidacy_type,
	CASE WHEN b.ID_NUM IS NOT NULL THEN 'Yes'
	ELSE 'No' END AS Persisted
FROM allStudents a 
	LEFT JOIN allStudents b ON a.ID_NUM=b.ID_NUM AND b.Seq_Num=a.Seq_Num+1),
retention AS (
select a.ID_NUM, a.Seq_Num, b.Seq_Num AS Next_Seq_Num, a.yr_cde, a.trm_cde, a.candidacy_type,
	CASE WHEN b.ID_NUM IS NOT NULL THEN 'Yes'
	ELSE 'No' END AS Retained
FROM allStudents a 
	LEFT JOIN allStudents b ON a.ID_NUM=b.ID_NUM AND b.Seq_Num=a.Seq_Num+3)
select nt.*, Persisted, Retained
FROM NewTransfers nt 
	LEFT JOIN persistence p ON nt.ID_NUM=p.ID_NUM AND nt.Seq_Num=p.Seq_Num
	LEFT JOIN retention r ON nt.ID_NUM=r.ID_NUM AND nt.Seq_Num=r.Seq_Num

/*PowerBI Measures:

Dynamic measures change values based on the filter for the page/visual. 
Overall measures are not affected by filters.

DynamicPersist = DIVIDE(
    COUNTROWS(FILTER(RandP_Values, RandP_Values[Persisted]="Yes")), --NUMERATOR(COUNT OF ROWS WHERE PERSISTED IS YES)
    COUNT(RandP_Values[Persisted])) --DENOMINATOR(COUNT OF ALL ROWS WITH NON-BLANK VALUES)
DynamicRetain = DIVIDE(
    COUNTROWS(FILTER(RandP_Values, RandP_Values[Retained]="Yes")), --NUMERATOR(COUNT OF ROWS WHERE PERSISTED IS YES)
    COUNT(RandP_Values[Retained])) --DENOMINATOR(COUNT OF ALL ROWS WITH NON-BLANK VALUES)

OverallPersist = DIVIDE(
    CALCULATE(COUNTROWS(FILTER(RandP_Values, RandP_Values[Persisted]="Yes")), RandP_Values[MAJOR_1] in ALLSELECTED(RandP_Values[MAJOR_1])), --NUMERATOR(COUNT OF ALL ROWS WITH PERSIST OF YES)
    CALCULATE(COUNT(RandP_Values[Persisted]),RandP_Values[MAJOR_1] in ALLSELECTED(RandP_Values[MAJOR_1])) --DENOMINATOR(COUNT OF ALL ROWS WITH A NON-BLANK VALUE FOR PERSIST)
    ) --IN ALL SELECTED HERE IGNORES THE MAJOR_1 FILTER ON WHATEVER VISUAL THIS MEASURE IS USED IN
OverallRetain = DIVIDE(
    CALCULATE(COUNTROWS(FILTER(RandP_Values, RandP_Values[Retained]="Yes")), RandP_Values[MAJOR_1] in ALLSELECTED(RandP_Values[MAJOR_1])), --NUMERATOR(COUNT OF ALL ROWS WITH PERSIST OF YES)
    CALCULATE(COUNT(RandP_Values[Retained]),RandP_Values[MAJOR_1] in ALLSELECTED(RandP_Values[MAJOR_1])) --DENOMINATOR(COUNT OF ALL ROWS WITH A NON-BLANK VALUE FOR PERSIST)
    ) --IN ALL SELECTED HERE IGNORES THE MAJOR_1 FILTER ON WHATEVER VISUAL THIS MEASURE IS USED IN

*/
