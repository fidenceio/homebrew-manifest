# Manifest North Star (Tap Alignment)

**Status:** Active  
**Last Updated:** 2026-03-05  
**Repository Role:** Distribution and upgrade delivery layer

## North Star Companion Documents

- `manifest.cli`: `docs/NORTH_STAR.md`
- `manifest.cloud`: `docs/NORTH_STAR.md`
- `homebrew.tap`: `NORTH_STAR.md` (this document)

## Ecosystem Context

Manifest operates as one coordinated system across three repositories:

- `manifest.cli` provides command-line release workflows
- `manifest.cloud` provides AI analysis and recommendation services
- `homebrew.tap` provides installation and upgrade delivery

This document maps Tap responsibilities to the shared strategy.

## Mission

Make Manifest easy to install, easy to upgrade, and trustworthy to run at scale by delivering timely and reliable package updates.

## Strategic Goals

### Goal 1: Developer Experience First

Tap should remove adoption friction for both solo developers and teams.

Key outcomes:

- predictable install and upgrade commands through `brew`
- clear onboarding path to current Manifest CLI capabilities
- stable package behavior across supported environments

### Goal 2: Near-Term Product Value

Near-term value only lands when users receive updates quickly and safely.

Key outcomes:

- formula updates synchronized with CLI release cadence
- checksum/version integrity users can trust
- low-friction upgrade path to smart versioning and AI-doc improvements

### Goal 3: Long-Term Thin-Client Ecosystem

Tap supports the long-term edge vision as a bootstrap and update channel.

Key outcomes:

- dependable distribution for control-plane tooling
- predictable upgrade paths for operators managing fleets
- package delivery reliability that complements automated release workflows

## Repo Responsibilities (Tap)

`homebrew.tap` is responsible for:

- publishing accurate, timely formulas for Manifest releases
- preserving package integrity and consistency
- keeping distribution docs aligned with CLI and Cloud strategy messaging
- reducing release-to-install latency for end users

## 12-Month Priority Plan

### P1: Release-to-Tap Reliability

- reduce time between CLI release and formula update
- define simple verification checklist for version and checksum
- improve visibility on delayed or failed formula publication

### P2: Upgrade Experience Quality

- tighten documentation for install/upgrade troubleshooting
- keep naming and links consistent across all repos
- validate platform compatibility assumptions in docs

### P3: Fleet and Edge Readiness

- align package delivery expectations with fleet rollout workflows
- document how tap updates support operator-led edge deployments
- track distribution constraints that impact thin-client operations

## Cross-Repo Contracts

- **Tap <-> CLI:** tap publishes quickly enough for CLI workflow adoption and fixes
- **Tap <-> Cloud:** distributed versions should match cloud integration expectations
- **Tap <-> Ecosystem:** package delivery should not become the bottleneck for release operations

## Success Metrics

- release-to-formula update time
- install and upgrade success rate
- adoption through Homebrew channel
- number of incidents related to package mismatch or delayed updates

## Review Cadence

Review strategy monthly or at each major release.  
Update this document when distribution process, release cadence, or ecosystem interfaces change.
