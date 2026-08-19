/* 
This view must be recreated every term with the number being updated each term in the 3rd line (CASE WHEN line). 
This CREATE VIEW creates a logical sequence number to use for sequential terms. 
SEQ_NUM creates a sequence number based on the first row as the start to the sequence; to calculate one fall to the next just add 3; spring to next spring is also add 3
CURRENT_SEQ_NUM places the current term (based on reg_config) as term 1 then previous terms are negative terms and future terms are positive terms; +/- 3 is still used to move between fall-fall terms
*/
CREATE VIEW [UTTC\mwilhelms].Sequential_Terms AS
select ROW_NUMBER() OVER (ORDER BY TRM_BEGIN_DTE ASC) AS Seq_Num, 
CASE WHEN ytt.YR_CDE=REG_CONFIG.CUR_YR_DFLT AND ytt.TRM_CDE=REG_CONFIG.CUR_TRM_DFLT THEN 1 ELSE (ROW_NUMBER() OVER (ORDER BY TRM_BEGIN_DTE ASC) - 96) END AS Current_Seq_Num, 
CONCAT(YR_CDE, '-', RIGHT((YR_CDE + 1),2)) AS AcadYear,
CASE WHEN TRM_CDE='30' THEN 'Fall' WHEN TRM_CDE='40' THEN 'Spring' WHEN TRM_CDE='60' THEN 'Summer' ELSE '0' END AS Term,
ytt.YR_CDE, ytt.TRM_CDE, TRM_BEGIN_DTE, TRM_END_DTE, CENSUS_DTE
from TmsEPrd.dbo.YEAR_TERM_TABLE ytt, TmsEPrd.dbo.REG_CONFIG
WHERE TRM_CDE in ('30','40','60');
