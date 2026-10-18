# Schemas

This folder contains JSON schemas for various Kubernetes CRDs.

They are used in manifests to instruct the yaml-language-server to use them where appropriate.

Wherever possible it's preferred to use an upstream-provided file (e.g.: [`furyctl.yaml`](../sd/furyctl.yaml#L1)).
Otherwise, this folder provides schemas for CRDs by converting them using their own OpenAPI schema.

## Converting CRDs

This folder's [`mise.toml`](mise.toml) contains two mise tasks:

- [`mise run convert <crd_url>`](mise.toml#L1): converts the provided URL, using [crd2jsonschema](https://github.com/tricktron/crd2jsonschema)
- [`mise run maintenance`](mise.toml#L30): converts all CRDs for this whole project

When needed, add the new URL to the list in the `maintenance` task and run it.
