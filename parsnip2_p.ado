program define parsnip2_p, rclass

	version 12.1

	syntax namelist(min=1 max=2) [if] [in], ///
											///
				[XB 						/// [default]
				Residuals					///
				NOIsily						///
				]
				
	if "`noisily'"=="" {
		local qui qui 
	}
	*

	* get var type & name
	tokenize `namelist'
	if "`2'"=="" {					//  only new varname provided
		local varlist `1'
	}
	else {							//  datatype also provided
		local vtype `1'
		local varlist `2'
	}
	*

	local command=e(cmd)
	if ("`command'"~="parsnip2") {
		di as err "error: -parsnip2_p- supports only the -parsnip2- command"
		exit 198
	}
	*

	marksample touse, novarlist
	
	*** warning messages
	if ("`xb'`residuals'"=="") {
		di as gr "No xb or residuals options specified. Assume xb (fitted values)."
		local xb xb
	}
	*
	
	*** obtain prediction/residuals
	local depvar `e(depvar)'
	if "`depvar'"=="" {
		di as err "internal parnsip2_p error; no depvar found."
	}
	if "`xb'"~="" {
		gen `vtype' `varlist' = `e(pred)' `if' `in'
	}
	else {
		gen `vtype' `varlist' = `e(depvar)' - `e(pred)' `if' `in'
	}
	

end
