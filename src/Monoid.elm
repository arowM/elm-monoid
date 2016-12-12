module Monoid
  exposing
    ( Monoid
    , monoid
    , empty
    , append
    , concat
    , string
    , list
    , array
    , dict
    , set
    , cmd
    , sub
    )

{-| A module to define generic functions for monoid.
For instance, we defined generic `concat` in this module using `Monoid` type as follows.

```
concat : Monoid a -> List a -> a
concat m = List.foldr (append m) (empty m)

-- >>> concat string ["foo", "bar", "baz"]
-- "foobarbaz"
-- >>> concat list [[1, 2, 3], [4, 5], [6]]
-- [1, 2, 3, 4, 5, 6]
```

# Types

@docs Monoid

# Constructors

@docs monoid

# Functions for unwraping Monoid

@docs empty
@docs append

# Convenient functions for monoid

@docs concat

# Monoid types for popular types

@docs string
@docs list
@docs array
@docs dict
@docs set
@docs cmd
@docs sub

-}

import Array exposing (Array)
import Dict exposing (Dict)
import Platform.Cmd as Cmd exposing (Cmd)
import Platform.Sub as Sub exposing (Sub)
import Set exposing (Set)


-- Types


{-| Main type.
-}
type Monoid a
  = Monoid
    { empty : a
    , append : a -> a -> a
    }



-- Constructors


{-| Constructor for `Monoid`.
-}
monoid : a -> (a -> a -> a) -> Monoid a
monoid empty append =
  Monoid
    { empty = empty
    , append = append
    }



-- Functions for unwraping monoid


{-| Take the identity element of a monoid.
-}
empty : Monoid a -> a
empty (Monoid { empty }) =
  empty


{-| Take the way to append a monoids.
-}
append : Monoid a -> (a -> a -> a)
append (Monoid { append }) =
  append



-- Convenient functions for monoids


{-| Concatenate list of monoid.
-}
concat : Monoid a -> List a -> a
concat m =
  List.foldr (append m) (empty m)



-- Monoid types for popular types


{-| `Monoid` type for `String`.
-}
string : Monoid String
string =
  monoid "" (++)


{-| `Monoid` type for `List`.
-}
list : Monoid (List a)
list =
  monoid [] (++)


{-| `Monoid` type for `Array`.
-}
array : Monoid (Array a)
array =
  monoid Array.empty Array.append


{-| `Monoid` type for `Dict`.
-}
dict : Monoid (Dict comparable a)
dict =
  monoid Dict.empty Dict.union


{-| `Monoid` type for `Set`.
-}
set : Monoid (Set comparable)
set =
  monoid Set.empty Set.union


{-| `Monoid` type for `Cmd`.
-}
cmd : Monoid (Cmd comparable)
cmd =
  monoid Cmd.none (\a b -> Cmd.batch [ a, b ])


{-| `Monoid` type for `Sub`.
-}
sub : Monoid (Sub comparable)
sub =
  monoid Sub.none (\a b -> Sub.batch [ a, b ])
