# digital-trust

## Overview

```bash
➜  export-control git:(main) ✗ tree              
.
├── input.json                                          # Mockup input.json
└── rba
    └── policy
        ├── export_controls
        │   ├── README.md
        │   ├── data.yaml                               # Export policy application lists
        │   ├── export_controls.rego                    # Export control policy
        │   └── export_controls_test.rego               # Export control Unit Tests
        └── metadata
            └── data.yaml                               # ISO 3166 Country Code list

4 directories, 6 files
➜  export-control git:(main) ✗ 

```

## Run Unit test

```bash
➜  export-control git:(main) ✗ opa test -v -r "rba.policy.export_control_test*" .


rba/policy/export_controls/export_controls_test.rego:
data.rba.policy.export_control_test.test__missing_geo_cc: PASS (2.633922ms)
data.rba.policy.export_control_test.test__missing_target_eccn: PASS (722.406µs)
data.rba.policy.export_control_test.test__missing_target_eccn_and_geo_cc: PASS (783.706µs)
data.rba.policy.export_control_test.test__unknown_geo_cc: PASS (1.307311ms)
data.rba.policy.export_control_test.test__empty_geo_cc: PASS (847.307µs)
data.rba.policy.export_control_test.test__unknown_target_eccn: PASS (804.807µs)
data.rba.policy.export_control_test.test__empty_target_eccn: PASS (1.262611ms)
data.rba.policy.export_control_test.test__trim_target_eccn_and_geo_cc: PASS (1.18921ms)
data.rba.policy.export_control_test.test__different_capitalization: PASS (808.707µs)
data.rba.policy.export_control_test.test__restricted_countries: PASS (1.13871ms)
data.rba.policy.export_control_test.test__euv_licensed_countries_technology_allowed: PASS (937.307µs)
data.rba.policy.export_control_test.test__euv_licensed_countries_software_allowed: PASS (815.007µs)
data.rba.policy.export_control_test.test__euv_non_licensed_countries_technology_blocked: PASS (2.261319ms)
data.rba.policy.export_control_test.test__euv_non_licensed_countries_software_blocked: PASS (865.307µs)
data.rba.policy.export_control_test.test__nxt1970_licensed_countries_technology_allowed: PASS (866.907µs)
data.rba.policy.export_control_test.test__nxt1970_licensed_countries_software_allowed: PASS (798.906µs)
data.rba.policy.export_control_test.test__nxt1970_non_licensed_countries_technology_blocked: PASS (823.307µs)
data.rba.policy.export_control_test.test__nxt1970_non_licensed_countries_software_blocked: PASS (1.688014ms)
data.rba.policy.export_control_test.test__not_controlled_allowed: PASS (936.508µs)
data.rba.policy.export_control_test.test__not_controlled_but_restricted_countries_2_denied: PASS (766.607µs)
--------------------------------------------------------------------------------
PASS: 20/20
➜  export-control git:(main) ✗ 
```

## Run dynamic tests

```bash

opa run --watch  repl.input:input.json .

OPA 0.60.0 (commit a1a2ae3cbb5fdddf306b1ef67ca5a856fd94fa15, built at 2023-12-20T22:07:16Z)

Run 'help' to see a list of commands and check for updates.

> data.rba.policy.export_control.authorization
{
  "allow": false,
  "message": [
    "Export Control Policy: The GEO country 'Russian Federation' (RU) is NOT in the EUV licensed countries list.",
    "Export Control Policy: The GEO country 'Russian Federation' (RU) is in the restricted countries 2 list."
  ]
}
> 

#
# Change input.json:
# {
#     "geo_cc": "NL",
#     "target_eccn": "3E001"
# }
#

> data.rba.policy.export_control.authorization
{
  "allow": true,
  "message": []
}
> 
```
