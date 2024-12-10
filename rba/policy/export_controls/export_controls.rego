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
default allow := false

allow if {
        print("MARCEL",input)
}

