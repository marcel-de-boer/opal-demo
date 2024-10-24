# Demo

## 1.  Picture Overview

**103** - Service Overview

**86**  - Proof of Concept

**87**  - First Step of Proof Concept

**104** - Basic of PBAC

**105** - OPA


## 2.  OPA REPL

OPA REPL:

1.  NL => allowed
2.  Comment out NL from euv-licensed list => blocked
3.  Uncomment NL from euv-licensed list => allowed

```bash
opa run --watch  repl.input:input.json . 
```

## 3. Run OPA Server

OPA Server:
   - Show logging

```bash
opa run -s --watch --log-format "json-pretty" --log-level "debug" .  
```

## 4. REST API interface OPA

```bash
curl    --location 'http://localhost:8181/v1/data/rba/policy/export_control/authorization?pretty=true' \
        --header 'Content-Type: application/json' \
        --data '{
                "input": {
                "geo_cc": "CN",
                "target_eccn": "3E001"
            }
        }'
```

## 5. Use Cases - Postman

## 6. GIT Repository

[Digital-Trust](https://gitlab-mirai.asml.com/ "Digital-Trust")