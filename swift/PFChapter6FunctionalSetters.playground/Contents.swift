// Do exercises for 4, 5, 6 chapters.

let pair = (42, "Swift")

(incr(pair.0), pair.1)

func incrFirst<A>(_ pair: (Int, A)) -> (Int, A) {
    return (incr(pair.0), pair.1)
}

incrFirst(pair)

func first<A, B, C>(_ f: @escaping (A) -> C) -> ((A, B)) -> (C, B) {
    return { pair in (f(pair.0), pair.1) }
}

first(incr)(pair)
pair |> first(incr)

pair
    |> first(incr)
    |> first(incr)
    |> first(String.init)

func second<A, B, C>(_ f: @escaping (B) -> C) -> ((A, B)) -> (A, C) {
    return { pair in (pair.0, f(pair.1)) }
}

pair
    |> first(incr)
    |> first(incr)
    |> first(String.init)
    |> second { $0 + "!" }

pair
    |> first(incr)
    |> first(incr)
    |> first(String.init)
    |> second { $0.uppercased() }

pair
    |> first(incr)
    |> first(incr)
    |> first(String.init)
    |> second(zurry(flip(String.uppercased)))

pair
    |> first(incr >>> incr >>> String.init)
    |> second(zurry(flip(String.uppercased)))


first(incr)
    >>> first(String.init)
    >>> second(zurry(flip(String.uppercased)))

var copyPair = pair
copyPair.0 += 1 // The same operation like first(incr)
copyPair.1 = copyPair.1.uppercased() // The same operation like second(zurry(flip(String.uppercased)))
//copyPair.0 = String(copyPair.0) But this doesn't work, because Cannot assign value of type 'String' to type 'Int'. FP rules)


// MARK: Nested tuples

let nested = ((1, true), "Swift")

nested
    |> first { pair in pair |> second { !$0 } }
nested
    |> first { $0 |> second { !$0 } }

// Try to compose this
//nested
//    |> (first >>> second) { !$0 }

// We could not do this because compiler says:
//"Cannot convert value of type '((Int, Bool), String)' to expected argument type '((Int, Bool), (Bool, _))'"
// But we could do this:
nested
    |> (second >>> first) { !$0 }
// It works like we expect, but the syntax a little bit weird...

// Lets solve it!

precedencegroup BackwardsComposition {
    associativity: left
}

infix operator <<<: BackwardsComposition
func <<< <A, B, C>(_ f: @escaping (B) -> C, _ g: @escaping (A) -> B) -> (A) -> C {
    return { f(g($0)) }
}
 
nested
    |> (first <<< second) { !$0 }

nested
    |> (first <<< first)(incr)
    |> (first <<< second) { !$0 }
    |> second { $0 + "!" }

// Also we can store this logic and use it like this:

let transformation = (first <<< first)(incr)
    <> (first <<< second) { !$0 }
    <> second { $0 + "!" }

nested |> transformation


// MARK: Tuples which have an array as component

// Lets look at basic way to transform any structures

// ((A) -> B) -> (S) -> T
// It says: give me a way to transform one component of structure and I give you a way to transform whole structure
// So for tuples:

// ((A) -> B) -> ((A, C)) -> (B, C)
// ((A) -> B) -> ((C, A)) -> (C, B)

// Lets adapt it to arrays:

// ((A) -> B) -> ([A]) -> [B]

// And this looks like a free version of map described before:

public func map<A, B>(_ f: @escaping (A) -> B) -> ([A]) -> [B] {
    return { xs in xs.map(f) }
}

(42, ["Swift", "Objective-C"])
    |> (second <<< map) { $0 + "!" }
    |> first(incr)

// Brilliant!!!

[(42, ["Swift", "Objective-C"]), (1323, ["Haskell", "Purescript"])]
    |> (map <<< second <<< map) { $0 + "!" }

dump(
    [(42, ["Swift", "Objective-C"]), (1323, ["Haskell", "Purescript"])]
     |> (map <<< second <<< map) { $0 + "!" }
)

// Also we can do in this way ...
let data = [(42, ["Swift", "Objective-C"]), (1323, ["Haskell", "Purescript"])]
data.map { ($0.0, $0.1.map { $0 + "!" }) }
// ... but it little bit harder to use.
