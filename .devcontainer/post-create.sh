#!/bin/bash
# Runs once when the Codespace/devcontainer is created.
# Pre-installs everything needed to develop and test twenty-front/twenty-server
# so the first `yarn test` / `npx nx ...` doesn't pay install+build cost.
set -euo pipefail

npm install -g @anthropic-ai/claude-code

# Hardened mode can prompt interactively for young/unapproved packages, which
# hangs in non-interactive shells (Codespaces creation, CI, agent tooling).
# Disabling it only for this script's install; day-to-day it's also set via
# containerEnv in devcontainer.json so later ad-hoc `yarn` calls don't hang either.
YARN_ENABLE_HARDENED_MODE=false yarn install

# twenty-shared and twenty-ui must be built before twenty-front tests/typecheck
# can resolve their generated/dist output.
npx nx build twenty-shared
npx nx build twenty-ui
