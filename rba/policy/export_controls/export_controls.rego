###################################################################################################
#
#  Reference: Access Rules Location for Technology & Source Code
#  Revision: 17
#  Date: 06-Sep-2024
#
###################################################################################################

package rba.policy.export_control

import rego.v1

# To  Do:
# 1. Complete list of country codes
# 2. Discuss origin
#      Non-US origin NXT1970 and up** Only to NXT1970 and up licensed countries
#      US origin NXT1970 and up Worldwide except to restricted countries 1 and restricted countries 2
# 3. Move some metadata from rego program to export_controls/data.yaml ?
# 4. Think about positive logic - To do or not to do - During testing I already found some bugs /unforseen
#    use cases which resulted in no deny message == allow.

#
## Initialize values
#

# Normalize input
geo_cc := trim(lower(input_geo_cc), " ") if {
	input_geo_cc
}

target_eccn := trim(upper(input_target_eccn), " ") if {
	input_target_eccn
}

# Countries
countries := data.rba.policy.metadata.countries

# Technology and Software ECCN Sets
euv_eccn := {"3E001", "3D001", "3D002", "3D003"}

nxt1970_eccn := {"3E805", "3E806", "3D805", "3D806"}

technology_eccn := {"3E001", "3E805", "3E806", "3E991", "EAR99", "NOT CONTROLLED"}

software_eccn := {"3D001", "3D002", "3D003", "3D805", "3D806", "3D991", "EAR99", "NOT CONTROLLED"}

# Export License Country Code Lists
euv_licensed_countries := data.rba.policy.export_controls.euv_licensed_countries

nxt_1970_and_up_nl_licensed_countries := data.rba.policy.export_controls.nxt_1970_and_up_nl_licensed_countries

restricted_countries_1 := data.rba.policy.export_controls.restricted_countries_1

restricted_countries_2 := data.rba.policy.export_controls.restricted_countries_2

#
## Authorization decision
#

default allow := false

allow if {
	count(deny) == 0
        print("MARCEL",input)
}

authorization := {
	"allow": allow,
	"message": deny,
}

#
## Export Control Policy Rules
#

# Check on mandatory attributes

deny contains msg if {
	not geo_cc
	msg := "Export Control Policy: The GEO country code is missing."
}

deny contains msg if {
	not geo_cc in object.keys(countries)
	msg := sprintf("Export Control Policy: The country code '%v' is a unknown country code.", [geo_cc])
}

deny contains msg if {
	not target_eccn
	msg := "Export Control Policy: The target ECCN code is missing."
}

deny contains msg if {
	not target_eccn in (technology_eccn | software_eccn)
	msg := sprintf("Export Control Policy: The target ECCN code '%v' is a unknown ECCN code.", [target_eccn])
}

# Block restricted countries 2

deny contains msg if {
	geo_cc in restricted_countries_2

	msg := sprintf(
		"Export Control Policy: The GEO country '%v' (%v) is in the restricted countries 2 list.",
		[countries[geo_cc].name, countries[geo_cc].cc_2],
	)
}

# Only allow access to EUV targets from EUV licensed countries

deny contains msg if {
	not geo_cc in euv_licensed_countries
	target_eccn in euv_eccn

	msg := sprintf(
		"Export Control Policy: The GEO country '%v' (%v) is NOT in the EUV licensed countries list.",
		[countries[geo_cc].name, countries[geo_cc].cc_2],
	)
}

# Only allow access to NXT1970 targets from NXT1970 and up licensed countries

deny contains msg if {
	not geo_cc in nxt_1970_and_up_nl_licensed_countries
	target_eccn in nxt1970_eccn

	msg := sprintf(
		"Export Control Policy: The GEO country '%v' (%v) is NOT in the XT1970 and up NL licensed countries list.",
		[countries[geo_cc].name, countries[geo_cc].cc_2],
	)
}
