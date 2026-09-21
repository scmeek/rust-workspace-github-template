#!/bin/sh
set -eu

TEST_DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
PROJECT_ROOT=$(CDPATH='' cd -- "$TEST_DIR/../.." && pwd)
SCRIPTS_DIR="$PROJECT_ROOT/scripts"
PATH="$TEST_DIR/bin:$PATH"
export PROJECT_ROOT SCRIPTS_DIR PATH

check() {
  expected=$1
  label=$2
  LICENSE_TEST_REPORT=$3
  LICENSE_TEST_EXIT=${4:-0}
  export LICENSE_TEST_REPORT LICENSE_TEST_EXIT

  if output=$(sh "$SCRIPTS_DIR/licenses-check.sh" 2>&1); then
    actual=pass
  else
    actual=fail
  fi
  if [ "$actual" != "$expected" ]; then
    printf 'FAIL: %s (expected %s)\n%s\n' "$label" "$expected" "$output" >&2
    exit 1
  fi
  printf 'PASS: %s\n' "$label"
}

check pass 'approved licenses' '[{"name":"a","version":"1","license":"MIT"},{"name":"b","version":"2","license":"(Apache-2.0 OR MIT) AND Unicode-3.0"}]'
check fail 'unapproved license among approved crates' '[{"name":"a","version":"1","license":"MIT"},{"name":"b","version":"1","license":"Proprietary"}]'
check fail 'missing license' '[{"name":"a","version":"1","license":null}]'
check fail 'custom license requires review' '[{"name":"a","version":"1","license_file":"LICENSE"}]'
check fail 'empty license' '[{"name":"a","version":"1","license":""}]'
check fail 'license matching is literal' '[{"name":"a","version":"1","license":"Apache-2x0"}]'
check fail 'unapproved compound expression' '[{"name":"a","version":"1","license":"MIT AND Proprietary"}]'
check fail 'malformed JSON' 'not json'
check fail 'wrong report shape' '{}'
check fail 'invalid entry' '[{"name":"a","version":"1","license":42}]'
check fail 'empty report' '[]'
check fail 'cargo failure' '[{"name":"a","version":"1","license":"MIT"}]' 1
