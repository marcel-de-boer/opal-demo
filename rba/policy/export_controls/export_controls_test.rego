###################################################################################################
#
#  Reference: Access Rules Location for Technology & Source Code
#  Revision: 17
#  Date: 06-Sep-2024
#
###################################################################################################

package rba.policy.export_control_test

import rego.v1

import data.rba.policy.export_control

# Input validation: missing or wrong input must be blocked

test__missing_geo_cc if {
	test_input := {"target_eccn": "3E001"}
	not export_control.allow == true with input as test_input
}

test__missing_target_eccn if {
	test_input := {"geo_cc": "NL"}
	not export_control.allow == true with input as test_input
}

test__missing_target_eccn_and_geo_cc if {
	test_input := {}
	not export_control.allow == true with input as test_input
}

test__unknown_geo_cc if {
	test_input := {
		"geo_cc": "bogus",
		"target_eccn": "3E001",
	}
	not export_control.allow == true with input as test_input
}

test__empty_geo_cc if {
	test_input := {
		"geo_cc": "",
		"target_eccn": "3E001",
	}
	not export_control.allow == true with input as test_input
}

test__unknown_target_eccn if {
	test_input := {
		"geo_cc": "NL",
		"target_eccn": "bogus",
	}
	not export_control.allow == true with input as test_input
}

test__empty_target_eccn if {
	test_input := {
		"geo_cc": "NL",
		"target_eccn": "",
	}
	not export_control.allow == true with input as test_input
}

test__trim_target_eccn_and_geo_cc if {
	test_input := {
		"geo_cc": " NL ",
		"target_eccn": "  3E001  ",
	}
	export_control.allow == true with input as test_input
}

test__different_capitalization if {
	test_input := {
		"geo_cc": "nl",
		"target_eccn": "3e805",
	}
	export_control.allow == true with input as test_input
}

# Restricted countries 2 must always be blocked

test__restricted_countries if {
	test_input := {
		"geo_cc": "RU",
		"target_eccn": "3E001",
	}
	not export_control.allow == true with input as test_input
}

# EUV technology or software only accessible by EUV licensed countries

test__euv_licensed_countries_technology_allowed if {
	test_input := {
		"geo_cc": "NL",
		"target_eccn": "3E001",
	}
	export_control.allow == true with input as test_input
}

test__euv_licensed_countries_software_allowed if {
	test_input := {
		"geo_cc": "NL",
		"target_eccn": "3D001",
	}
	export_control.allow == true with input as test_input
}

test__euv_non_licensed_countries_technology_blocked if {
	test_input := {
		"geo_cc": "CN",
		"target_eccn": "3E001",
	}
	not export_control.allow == true with input as test_input
}

test__euv_non_licensed_countries_software_blocked if {
	test_input := {
		"geo_cc": "CN",
		"target_eccn": "3D001",
	}
	not export_control.allow == true with input as test_input
}

# Test on NXT1970 and Up licensed countries

test__nxt1970_licensed_countries_technology_allowed if {
	test_input := {
		"geo_cc": "CN",
		"target_eccn": "3E805",
	}
	export_control.allow == true with input as test_input
}

test__nxt1970_licensed_countries_software_allowed if {
	test_input := {
		"geo_cc": "CN",
		"target_eccn": "3D805",
	}
	export_control.allow == true with input as test_input
}

test__nxt1970_non_licensed_countries_technology_blocked if {
	test_input := {
		"geo_cc": "AF",
		"target_eccn": "3E805",
	}
	not export_control.allow == true with input as test_input
}

test__nxt1970_non_licensed_countries_software_blocked if {
	test_input := {
		"geo_cc": "AF",
		"target_eccn": "3D805",
	}
	not export_control.allow == true with input as test_input
}

# Allow unrestricted ECCN from any location - except restricted countries 2

test__not_controlled_allowed if {
	test_input := {
		"geo_cc": "AF",
		"target_eccn": "NOT CONTROLLED",
	}

	export_control.allow == true with input as test_input
}

test__not_controlled_but_restricted_countries_2_denied if {
	test_input := {
		"geo_cc": "RU",
		"target_eccn": "NOT CONTROLLED",
	}

	not export_control.allow == true with input as test_input
}
