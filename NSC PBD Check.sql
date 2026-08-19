select ntd.NSL_ID_NUM AS ID, ntd.NSL_PROG1_BEGIN_DATE AS PBD1, ntd.NSL_PROG1_ENROLL_STS_EFF_DTE AS PSED1, 
	case
		when ntd.NSL_PROG1_ENROLL_STS_EFF_DTE<ntd.NSL_PROG1_BEGIN_DATE then 'incorrect PBD'
	END AS PBD_check, 
	dh.MAJOR_1, dh.EXPECT_GRAD_YR AS GRAD_YR, dh.EXPECT_GRAD_TRM AS GRAD_TRM, dh.ENTRY_DTE, dh.WITHDRAWAL_DTE, dh.EXIT_DTE, dh.RECORD_CHANGE_DATE, ntd.NSL_PROG1_ENROLL_STATUS AS Prog_Sts,
	case when dh.ENTRY_DTE is not null AND ntd.NSL_PROG1_ENROLL_STATUS='W' THEN 'Check Prg2 dates' END AS PSD2_CHECK, NTD.NSL_PROG2_BEGIN_DATE AS PBD2, ntd.NSL_PROG2_ENROLL_STS_EFF_DTE AS PSED2
from TmsEPrd.dbo.NSLC_TRANS_DETAIL ntd
	left join TmsEPrd.dbo.DEGREE_HISTORY dh on ntd.NSL_ID_NUM=dh.ID_NUM AND dh.DIV_CDE='UG' and dh.CUR_DEGREE='Y' and dh.ACTIVE='Y' AND MAJOR_1 is not null and DTE_DEGR_CONFERRED is null
where (WITHDRAWAL_DTE > '2025-01-01' OR WITHDRAWAL_DTE is null) AND (EXIT_DTE > '2025-01-01' OR EXIT_DTE is null)
ORDER BY PBD_check desc, NSL_ID_NUM
---EACH TERM CHANGE THE WITHDRAWAL DATE & EXIT DATE TO BE A DAY JUST BEFORE THE FIRST DAY OF THE TERM TO CAPTURE ANY WITHDRAW/EXITS FOR THE CURRENT TERM

--CHECKS:

--PBD_CHECK	- PSED is before PBD which will cause an error once submitted to NSC. Or if the dates are the same but the PSED time is before PBD then there's a good chance both dates may be wrong.
------------- If this column comes up as incorrect PBD, confirm if the PBD1 or PSED are correct. Correct as needed in the transmittal detail record in J1.

--PRG2_START_DTE - When a student switches majors mid-semester the new major is under the Program 2 line; the PBD and PSED are both automatically (but incorrectly) filled in as the date
------------------ the major change was physically changed in J1 instead of the Entry Date (the first day of the term). 
------------------ Check the Transmittal Detail Records for the Program 2 dates are correct.
