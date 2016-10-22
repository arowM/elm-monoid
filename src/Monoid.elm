module Monoid exposing
  ( Monoid
  , monoid
  , empty
  , append
  , concat
  , stringMonoid
  , listMonoid
  , arrayMonoid
  , dictMonoid
  , setMonoid
  , cmdMonoid
  , subMonoid
  )

{-| A module to define generic functions for monoid.
For instance, we defined generic `concat` in this module using `Monoid` type as follows.

```
concat : Monoid a -> List a -> a
concat m = List.foldr (append m) (empty m)

>>> concat stringMonoid ["foo", "bar", "baz"]
"foobarbaz"
>>> concat listMonoid [[1, 2, 3], [4, 5], [6]]
[1, 2, 3, 4, 5, 6]
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

@docs stringMonoid
@docs listMonoid
@docs arrayMonoid
@docs dictMonoid
@docs setMonoid
@docs cmdMonoid
@docs subMonoid

-}

import Array exposing (Array)
import Dict exposing (Dict)
import Platform.Cmd as Cmd exposing (Cmd)
import Platform.Sub as Sub exposing (Sub)
import Set exposing (Set)


-- Types


{-| Main type.
-}
type Monoid a = Monoid
    { empty : a
    , append : a -> a -> a
    }



-- Constructors


{-| Constructor for `Monoid`.
-}
monoid : a -> (a -> a -> a) -> Monoid a
monoid empty append = Monoid
  { empty = empty
  , append = append
  }



-- Functions for unwraping monoid


{-| Take the identity element of a monoid.
-}
empty : Monoid a -> a
empty (Monoid { empty }) = empty


{-| Take the way to append a monoids.
-}
append : Monoid a -> (a -> a -> a)
append (Monoid { append }) = append



-- Convenient functions for monoids


{-| Concatenate list of monoid.
-}
concat : Monoid a -> List a -> a
concat m = List.foldr (append m) (empty m)



-- Monoid types for popular types


{-| `Monoid` type for `String`.
-}
stringMonoid : Monoid String
stringMonoid = monoid "" (++)


{-| `Monoid` type for `List`.
-}
listMonoid : Monoid (List a)
listMonoid = monoid [] (++)


{-| `Monoid` type for `Array`.
-}
arrayMonoid : Monoid (Array a)
arrayMonoid = monoid Array.empty Array.append


{-| `Monoid` type for `Dict`.
-}
dictMonoid : Monoid (Dict comparable a)
dictMonoid = monoid Dict.empty Dict.union


{-| `Monoid` type for `Set`.
-}
setMonoid : Monoid (Set comparable)
setMonoid = monoid Set.empty Set.union


{-| `Monoid` type for `Cmd`.
-}
cmdMonoid : Monoid (Cmd comparable)
cmdMonoid = monoid Cmd.none (\a b -> Cmd.batch [a, b])


{-| `Monoid` type for `Sub`.
-}
subMonoid : Monoid (Sub comparable)
subMonoid = monoid Sub.none (\a b -> Sub.batch [a, b])
