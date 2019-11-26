#!/usr/bin/env bats

source lib/functions/path.sh

@test '`__exists_in` exits 0 for success' {
  run __exists_in 'foo:bar:baz' 'bar' ':'
  [ "$status" = 0 ]
}

@test '`__exists_in` exits nonzero for failure' {
  run __exists_in 'foo:bar:baz' 'not present' ':'
  [ "$status" != 0 ]
}

@test "\`_exists_in\` has ':' as its default separator" {
  run __exists_in 'foo:bar:baz' 'foo'
  [ "$status" = 0 ]

  run __exists_in 'foo;bar;baz' 'bar'
  [ "$status" != 0 ]
}
