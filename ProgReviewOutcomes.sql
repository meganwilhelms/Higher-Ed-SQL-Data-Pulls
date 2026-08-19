/*This query pulls the columns needed to calculate measures in power bi such as CCR and GPA */
SELECT stsd.id_num, stsd.YR_CDE, stsd.TRM_CDE, STSD.TRM_QUAL_PTS, STSD.TRM_HRS_EARNED , STSD.TRM_HRS_GPA, STSD.HRS_ENROLLED,
	CASE WHEN MAJOR_1 in ('BAD', 'BADOL') THEN 'BAD'
		WHEN MAJOR_1 in ('BSBAD', 'BSBAO') THEN 'BSBAD'
		WHEN MAJOR_1 in ('CIS', 'CIT') THen 'CIS'
		WHEN MAJOR_1 IN ('CJAAO', 'CJU') THEN 'CJU'
		WHEN MAJOR_1 in ('BSCJO', 'BSCJU') THEN 'BSCJU'
		WHEN MAJOR_1 IN ('GENA', 'GENOL') THEN 'GENA'
		WHEN MAJOR_1 IN ('HSS', 'SWK') THEN 'SWK'
		ELSE MAJOR_1
		END AS MAJOR_1,
		 st.Seq_Num, st.AcadYear, st.Term
from TmsEPrd.dbo.STUD_TERM_SUM_DIV stsd
	LEFT JOIN TmsEPrd.[UTTC\mwilhelms].Sequential_Terms st ON stsd.YR_CDE=st.YR_CDE AND stsd.TRM_CDE=st.TRM_CDE
where stsd.YR_CDE>2020  and HRS_ENROLLED>0 and stsd.TRM_CDE in ('30', '40', '60')

/*PowerBI Measures:

Dynamic measures change values based on the filter for the page/visual. 
Overall measures are not affected by filters.

DynamicCCR = DIVIDE(SUM(Outcomes[TRM_HRS_EARNED]), --numerator
                    SUM(Outcomes[HRS_ENROLLED])) --denominator
DynamicCOUNT = DISTINCTCOUNT(Outcomes[id_num])
DynamicGPA = DIVIDE((SUM(Outcomes[TRM_QUAL_PTS])), --numerator
                    (SUM(Outcomes[TRM_HRS_GPA])), 0) --denominator; the ,0 at the end fixes a 0/0 situation to display as 0 instead of a missing value

OverallCCR = DIVIDE(
    CALCULATE(SUM(Outcomes[TRM_HRS_EARNED]), Outcomes[MAJOR_1] in ALLSELECTED(Outcomes[MAJOR_1])), --numerator
    CALCULATE(SUM(Outcomes[HRS_ENROLLED]), Outcomes[MAJOR_1] in ALLSELECTED(Outcomes[MAJOR_1])))   --denominator
OverallCOUNT = CALCULATE(DISTINCTCOUNT(Outcomes[id_num]), Outcomes[MAJOR_1] in ALLSELECTED(Outcomes[MAJOR_1]))
OverallGPA = DIVIDE(
    CALCULATE(SUM(Outcomes[TRM_QUAL_PTS]), Outcomes[MAJOR_1] in ALLSELECTED(Outcomes[MAJOR_1])), --numerator
    CALCULATE(SUM(Outcomes[TRM_HRS_GPA]), Outcomes[MAJOR_1] in ALLSELECTED(Outcomes[MAJOR_1])))  --denominator
*/
