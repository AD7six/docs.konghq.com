---
title: Session authentication
nav_title: Session
---

## Prerequisites

{% include /md/plugins-hub/oidc-prereqs.md %}

## Session authentication

Kong OpenID Connect plugin can issue a session cookie that can be used for further
session authentication. To make OpenID Connect issue a session cookie, you need
to first authenticate with one of the other grant / flows described above. In
[authorization code flow](#authorization-code-flow) we already demonstrated session
authentication when we used the redirect login action. The session authentication
is described below:

<img src="/assets/images/docs/openid-connect/session-authentication.svg">

### Patch the plugin

Let's patch the plugin that we created in the [Kong configuration](#prerequisites) step.

We want to only use the session authentication, but we also enable the 
[password grant](/hub/kong-inc/openid-connect/how-to/authentication/password-grant/) for demoing purposes.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=session                                    \
  config.auth_methods=password # only enabled for demoing purposes
```
```http
HTTP/1.1 200 OK
```

```json
{
    "id": "5f35b796-ced6-4c00-9b2a-90eef745f4f9",
    "name": "openid-connect",
    "service": {
        "id": "5fa9e468-0007-4d7e-9aeb-49ca9edd6ccd"
    },
    "config": {
        "auth_methods": [
            "session",
            "password"
        ]
    }
}
```

### Test the session authentication

1. Request the service with basic authentication credentials (created in the [Keycloak configuration](#prerequisites) step),
   and store the session:
   ```bash
   http -v -a john:doe --session=john :8000
   ```
   ```http
   GET / HTTP/1.1
   Authorization: Basic BEkg3bHT0ERXFmKr1qelBQYrLBeHb5Hr
   ```
   ```http
   HTTP/1.1 200 OK
   Set-Cookie: session=<session-cookie>; Path=/; SameSite=Lax; HttpOnly
   ```
   ```json
   {
       "headers": {
           "Authorization": "Bearer <access-token>"
       },
       "method": "GET"
   }
   ```
2. Make request with a session cookie (stored above):
   ```bash
   http -v --session=john :8000
   ```
   ```http
   GET / HTTP/1.1
   Cookie: session=<session-cookie>
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```json
   {
       "headers": {
           "Authorization": "Bearer <access-token>"
       },
       "method": "GET"
   }
   ```

{:.note}
> **Note**: If you want to disable session creation with some grants, you can use the 
[`config.disable_session`](/hub/kong-inc/openid-connect/configuration/#disable_session) configuration parameter.