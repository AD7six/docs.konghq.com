---
nav_title: Records reference
---

## Records

In the [configuration parameter](/hub/kong-inc/openid-connect/configuration/) list, 
two configuration settings used an array of records as a data type:

- `config.client_jwk`: array of JWK records (one for each client)
- `config.session_redis_cluster_nodes`: array of host records, either as IP
addresses or hostnames, and their ports.

Below are descriptions of the record types.

### JWK Record

The JSON Web Key (JWK) record is specified in [RFC7517][jwk]. This record is used with the
`config.client_jwk` when using `private_key_jwk` client authentication.

Here is an example of a JWK record generated by the plugin itself (see [JSON Web Key Set](/hub/kong-inc/openid-connect/api/#json-web-key-set)):

```json
{
    "kid": "B2FxBJ8G_e61tnZEfaYpaMLjswjNO3dbVEQhR7-i_9s",
    "kty": "RSA",
    "alg": "RS256",
    "use": "sig"
    "e": "AQAB",
    "n": "…",
    "d": "…",
    "p": "…",
    "q": "…",
    "dp": "…",
    "dq": "…",
    "qi": "…"
}
```

The JWK private fields (`k`, `d`, `p`, `q`, `dp`, `dq`, `qi`, `oth`, `r`, `t`) are _referenceable_,
which means they can be securely stored as a
[secret](/gateway/latest/kong-enterprise/secrets-management/getting-started/)
in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

### Host Record

The Host record used with the `config.session_redis_cluster_nodes` is simple.
It contains `ip` or `host`, and the `port` where the `port` defaults to `6379`.

Here is an example of a Host record:

```json
{
    "ip": "127.0.0.1"
    "port": 6379
}
```