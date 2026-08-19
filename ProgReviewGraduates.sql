/*This query gives a list of graduates for the chosen degree conferred period. A student with a double major will be listed twice for each major graduating. 

*/
With primary_major AS (
 SELECT DISTINCT DEGREE_HISTORY.ID_NUM,
         degree_history.dte_degr_conferred AS Date, 
		 st.AcadYear, st.Term, st.YR_CDE,
         degree_history.major_1 as major,
		 --degree_history.MAJOR_2,
         degree_history.degr_cde,
		 DEGREE_HISTORY.DIV_CDE,
		 DEGREE_HISTORY.EXIT_REASON
    FROM TmsEPrd.dbo.degree_history
			LEFT JOIN TmsEPrd.dbo.year_term_table ytt ON DEGREE_HISTORY.DTE_DEGR_CONFERRED=ytt.trm_end_dte
			LEFT JOIN TmsEPrd.[UTTC\mwilhelms].Sequential_Terms st ON ytt.YR_CDE=st.YR_CDE AND ytt.TRM_CDE=st.TRM_CDE
   WHERE ((degree_history.dte_degr_conferred >= '8/23/2021' ) AND (degree_history.dte_degr_conferred <= '5/10/2026')) AND EXIT_REASON='G'
),
second_major AS (
 SELECT DISTINCT DEGREE_HISTORY.ID_NUM,
         degree_history.dte_degr_conferred AS Date, 
		 st.AcadYear, st.Term, st.YR_CDE,
         --degree_history.major_1,
		 degree_history.MAJOR_2 as major,
         degree_history.degr_cde,
		 DEGREE_HISTORY.DIV_CDE,
		 DEGREE_HISTORY.EXIT_REASON
    FROM TmsEPrd.dbo.degree_history
			LEFT JOIN TmsEPrd.dbo.year_term_table ytt ON DEGREE_HISTORY.DTE_DEGR_CONFERRED=ytt.trm_end_dte
			LEFT JOIN TmsEPrd.[UTTC\mwilhelms].Sequential_Terms st ON ytt.YR_CDE=st.YR_CDE AND ytt.TRM_CDE=st.TRM_CDE
   WHERE ((degree_history.dte_degr_conferred >= '8/23/2021' ) AND (degree_history.dte_degr_conferred <= '5/10/2026')) AND EXIT_REASON='G' AND MAJOR_2 is not null
)
select * FROM primary_major
UNION ALL
select * FROM second_major
order by ID_NUM
