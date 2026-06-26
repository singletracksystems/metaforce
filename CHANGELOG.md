# Changelog

## 1.2.2

- Fix session re-authentication after `INVALID_SESSION_ID`: reset memoized Savon client so new session headers and endpoints are picked up
- Restore Savon 2 SOAP logging via per-client `log`/`logger` globals on `Configuration`

**Note for consumers:** metaforce 1.2.x depends on Savon 2.x. Applications that depend on Savon 1.x directly may need a coordinated upgrade.
