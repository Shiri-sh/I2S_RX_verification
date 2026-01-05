# I2S_RX_verification

This repository contains the verification environment and tests for the I2S RX module.

# link to EDA playground

https://www.edaplayground.com/x/S4dP

## Overview

I performed multiple configuration tests on this verification environment. 
The main goal was to validate receiver functionality across several setups when a deterministic seed could not be generated in EDA Playground.
In addition, I added explicit coverage logging because EDA Playground could not reliably show or export coverage results from the simulator.

## Key notes

- Seed generation in EDA Playground: I could not generate a reproducible seed within EDA Playground. Because of this limitation I ran several targeted tests across different configurations instead of relying on a single randomized test.
-  If a seed could be generated, a single properly-seeded randomized test would be sufficient and preferable.
- Coverage collection: EDA Playground did not allow viewing or exporting coverage files directly, so I added logging steps that write coverage information into the repository's coverage area. These logs make it possible to inspect coverage results locally or to collect them outside EDA Playground.

## What I ran / Why

- Multiple deterministic configuration tests:
  - Purpose: exercise different I2S RX configurations and corner cases when we cannot run a single seeded randomized test.
  - Result: improved confidence across configurations even without a reproducible EDA Playground seed.
- Coverage logging:
  - Purpose: ensure coverage reports are saved in a form that can be inspected if the simulator in EDA Playground does not present coverage files.
  - Result: coverage artifacts are produced under `coverage/` for manual inspection or external collection.

## Repository layout

- rtl/        — RTL sources for the I2S RX
- tb/         — Testbench components
- seq/        — sequences and stimulus generators
- pkg/        — common packages and utilities
- interfaces/ — interface definitions
- tests/      — individual testcases / test configurations used
- coverage/   — saved coverage logs / artifacts

## Recommendations

- If you can reproduce seed generation in your environment, switch to a single seeded randomized test for broader stimulus and easier debugging.
- Keep coverage logging enabled so results remain available even when running on web-based simulators that do not expose coverage artifacts.
