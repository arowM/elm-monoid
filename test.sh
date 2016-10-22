#! /bin/bash
set -ue

exit `elm-doctest src/Monoid.elm | grep -c "### Failure"`
