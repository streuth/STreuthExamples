# Preparing a STreuth Examples release

STreuth documentation © 2026 Mark Kimberly Howe, licensed under CC BY-SA 4.0.

The **Example packages** GitHub Actions workflow creates a reviewed draft
release. It does not publish automatically.

The `STREUTH_READ_KEY` Actions secret must contain the private half of a
read-only deploy key registered with the private `streuth/STreuth` repository.
This gives the public examples workflow access to the pinned runtime source
without granting write access to either repository.

Before dispatching the workflow:

1. Run `./bin/audit-standalone-examples` and review every failure.
2. Run `./bin/package-distribution-examples`; all approved archives must pass.
3. Give every row in `distribution-catalog.tsv` the intended common release
   version.
4. Update the pinned STreuth commit in
   `.github/workflows/example-packages.yml` when the runtime changes.
5. Commit and push the catalog, approved list, examples, and workflow together.

The workflow runs the complete pinned STreuth test suite, creates a runtime jar,
repeats the isolation and archive checks, and attaches the example ZIPs,
`SHA256SUMS`, and the exact catalog snapshot to a draft release. The tag is
`examples-v<version>`.

Before publishing the draft:

- Confirm all approved examples have one ZIP and one checksum entry.
- Download at least one archive through GitHub and run it outside all source
  checkouts.
- Confirm the archive manifest matches its filename and catalog row.
- Keep the release as a draft if the corresponding IDE compatibility claim has
  not been exercised.
