program parsnip2, eclass

	syntax varlist [if] [in] , [ pred(name) hold(name) * ]
	
	if "`pred'"~="" {
		di as res "warning: pred option ignored; prediction saved as _parsnip2_pred"
	}
	if "`hold'"~="" {
		di as res "warning: hold option ignored"
	}
	
	// touse has obs that parsnip will use
	marksample touse
	tempvar hold
	qui gen byte `hold' = 1
	// set hold to maximal set of obs
	markout `hold' `varlist'
	// now set hold to 0 if parsnip will use it
	replace `hold'=0 if `touse'

	cap drop _parsnip2_pred
	local pred _parsnip2_pred
	tokenize `varlist'
	local depvar `1'

	parsnip `varlist', pred(`pred') hold(`hold') `options'
	
	ereturn clear
	ereturn local cmd parsnip2
	ereturn local pred `pred'
	ereturn local predict parsnip2_p
	ereturn local depvar `depvar'
	
end
