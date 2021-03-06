# JWT Usage Documentation

This API provides a method for loosely coupled content delivery authentication, enabling you to only provide content for valid requests from Dealer.com sites.

We have <a href="downloads/ddc-ipp-auth-demo-master.zip">a sample application</a> to demonstrate how to consume Dealer.com's Integrated Partner Program [JWKs](https://tools.ietf.org/html/rfc7517), [JWTs](https://tools.ietf.org/html/rfc7519), and [JWSs](https://tools.ietf.org/html/rfc7515).  How to pronounce `JWSs` is left as an exercise for the reader.

## JWTs

JWTs are used to claim that, at the time the token is issued, Dealer.com rendered a webpage containing specific vehicles, on a specific domain, for a specific account.

An off-platform vendor can validate this token and use that result to decide whether or not to provide paid content.

This claim is then signed with a rotating RSA private key, and the public keys are published on a `*.dealer.com` domain with HTTPS.

Successful validation of a JWT with one of our public keys ensures that the claims were not tampered with.

The consumer of a JWT is responsible for validating the signature, and can make their own decision about whether or not to honor the token.  Dealer.com provides an [`iat` (Issued At)](https://tools.ietf.org/html/rfc7519#section-4.1.6) claim, but does _not_ provide an [`exp` (Expiration Time)](https://tools.ietf.org/html/rfc7519#section-4.1.4) claim.  This means the consumer is free to (and should) define their own limits on token freshness.  An implicit expiry is reached when Dealer.com is no longer publishing the public key of the keypair that a particular JWT is signed with.

## JWKs

JWKs are published on a Dealer.com domain with HTTPS, which prevents a malicious actor from distributing public keys that would validate JWT signatures not generated by Dealer.com.

JWK public keys are guaranteed to be published well before the corresponding private key is used for generating JWTs.

This means consumers polling for public keys will always be able to validate the signature on a new, valid JWT.

JWKs are hosted on Dealer.com's Content Delivery Network, and therefore are highly available to consumers.

Consumers _SHOULD_ poll and cache JWKs for a short period of time.
Consumers _SHOULD NOT_ cache or store keys for an extended period of time to ensure invalidated/expired keys are removed in a timely manner.

JWKs are published as a [JWK Set](https://tools.ietf.org/html/rfc7517#section-5), and each JWT signature contains the [`kid` (Key Id)](https://tools.ietf.org/html/rfc7515#section-4.1.4) of the JWK used to verify the signature.

## Details

The details in this document are _not necessarily final_ and are subject to change with notice.

At the time of writing:

**JWK URL**: https://api.web.dealer.com/ipp/keys/jwks.json

**JWK Algorith**: 2048-bit RSA

**JWK Usage**:

- Private Key: Used to sign JWTs for up to 1 day

- Public Key: Published 1 day before Private Key is used, removed from publishing after 30 days

**JWK Consumer Cache Duration**: 0-15 minutes, recommend 1 minute.

**JWA**: [RS256](https://tools.ietf.org/html/rfc7518#section-7.1.2)

**JWT Claims**:

- `iss`: (Issuer) Dealer.com

- `aud`: (Audience) IPP

- `sub`: (Subject) The Dealer.com account ID

- `domain`: The public hostname associated with the Dealer.com account ID

- `VINs`: A list of VINs that Dealer.com believes the given subject has access to

## Example

The <a href="downloads/ddc-ipp-auth-demo-master.zip">provided example</a> is a spring-boot application that polls the JWK url to fetch public keys as they're published.  It has a single endpoint (`/jwt/validate/{jwt}`) that accepts a JWT as a path parameter and validates the signature and audience.

## Retrieving a JWT

A test JWT can be generated for any dealer.com site by calling `<domain>/api/ipp/jwt/vehicles?vins=` and providing a list of VINs that are valid for that site.

> A full example for `roimotors.com` would be:

```
curl -Lv https://roimotors.com/api/ipp/jwt/vehicles?vins=1HGCV1F46LA013527,1HGCV1F51LA013850,1HGCV1F52LA011170,1HGCV1F57LA003078
```

Decode the token at https://jwt.io/ to check that all of the requested VINs were returned.
If any VINs are missing, that means that Dealer.com believes the given account doesn't have access to display that inventory.

The Web Integration API provides <a href="#api-utils-getjwtforvehicles">a convenience method</a> for obtaining the valid VINs and JWT for the current page where your code is executing. This accomplishes the step above and provides you with the JWT which can be passed to your system through a URL parameter on a request which then can be validated on your service with the following validation step.

## Validating the JWT

Once you have a valid JWT, you can validate it with the sample application. The JWT is guaranteed to be url-safe.

```
curl -v localhost:8080/jwt/validate/<jwt>
```
