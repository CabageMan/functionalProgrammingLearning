import Foundation
import Darwin

func greet(at date: Date, name: String) -> String {
    let seconds = Int(date.timeIntervalSince1970) % 60
    return "Hello \(name)! It's \(seconds) seconds past the minute."
}

func greet(at date: Date) -> (String) -> String {
    return { name in
        let seconds = Int(date.timeIntervalSince1970) % 60
        return "Hello \(name)! It's \(seconds) seconds past the minute."
    }
}

// MARK: Curry
func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in { b in f(a, b) } }
}

greet(at:name:)
curry(greet(at:name:))
greet(at:)

String.init(data:encoding:)
curry(String.init(data:encoding:))

curry(String.init(data:encoding:))
>>> { $0(.utf8) }

// MARK: Flip
func flip<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {
    return { b in { a in f(a)(b) } }
}

flip(curry(String.init(data:encoding:)))

let stringWithEncoding = flip(curry(String.init(data:encoding:)))
stringWithEncoding(.utf8)

"hello".uppercased(with: Locale.init(identifier: "en"))
String.uppercased(with:)
// Signature of this function:
// (Self) -> (Arguments) -> ReturnType
String.uppercased(with:)("hello")
String.uppercased(with:)("hello")(Locale.init(identifier: "en"))

let uppercasedWithLocale = flip(String.uppercased(with:))
let uppercasedWithEn = uppercasedWithLocale(Locale.init(identifier: "en"))
"hello" |> uppercasedWithEn


// MARK: Attention
String.uppercased
// This function returned the function with signature:
// (String) -> () -> (String)
// But...
flip(String.uppercased)
// has signature:
// (Optional<Foundation.Locale>) -> (String) -> String
// Because swift compiler automatically set function with locale to flip. So need to create other flip function:

func flip<A, C>(_ f: @escaping (A) -> () -> C) -> () -> (A) -> C {
    return { { a in f(a)() } }
}

let uppercasedWithoutArguments = flip(String.uppercased)
"hello" |> uppercasedWithoutArguments()

// MARK: Zurry

// Here we have a problem with parentheses
flip(String.uppercased)
flip(String.uppercased)()
// To solve it let create another function

func zurry<A>(_ f: () -> A) -> A {
    return f()
}

zurry(flip(String.uppercased))
"hello" |> zurry(flip(String.uppercased))


// MARK: MAP

[1, 2, 3]
    .map(incr)
    .map(square)

//Array.map
//curry(Array.map)

func map<A, B>(_ f: @escaping (A) -> B) -> ([A]) -> ([B]) {
    return { $0.map(f) }
}

map(incr)
map(square)
map(incr) >>> map(square)
map(incr) >>> map(square) >>> map(String.init)
map(incr >>> square >>> String.init)

[1, 2, 3] |> map(incr) >>> map(square)
[1, 2, 3] |> map(incr) >>> map(square) >>> map(String.init)
[1, 2, 3] |> map(incr >>> square >>> String.init)


// MARK: Filter

Array(1...10)
    .filter { $0 > 5 }

func filter<A>(_ f: @escaping (A) -> Bool) -> ([A]) -> [A] {
    return { $0.filter(f) }
}

filter { $0 > 5 }
    >>> map(incr >>> square)

Array(1...10)
    |> filter { $0 > 5 }
    >>> map(incr >>> square)


// MARK: Exercises

// 1. Write curry for functions that take 3 arguments.

func greetTwo(at date: Date, name: String, lastName: String) -> String {
    let seconds = Int(date.timeIntervalSince1970) % 60
    return "Hello \(name) \(lastName)! It's \(seconds) seconds past the minute."
}

func greetTwo(at date: Date) -> (String, String) -> String {
    return { name, lastName in
        let seconds = Int(date.timeIntervalSince1970) % 60
        return "Hello \(name) \(lastName)! It's \(seconds) seconds past the minute."
    }
}

func curry<A, B, C, D>(_ f: @escaping (A, B, C) -> D) -> (A) -> (B, C) -> D {
    return { a in { b, c in f(a, b, c) } }
}

greetTwo(at:name:lastName:)
greetTwo(at:)
curry(greetTwo(at:name:lastName:))


// 2. Explore functions and methods in the Swift standard library, Foundation, and other third party code, and convert them to free functions that compose using curry, zurry, flip, or by hand.



// 3. Explore the associativity of function arrow ->. Is it fully associative, i.e. is ((A) -> B) -> C equivalent to (A) -> ((B) -> C), or does it associate to only one side? Where does it parenthesize as you build deeper, curried functions?

// 4. Write a function, uncurry, that takes a curried function and returns a function that takes two arguments. When might it be useful to un-curry a function?

// 5. Write reduce as a curried, free function. What is the configuration vs. the data?

// 6. In programming languages that lack sum/enum types one is tempted to approximate them with pairs of optionals. Do this by defining a type struct PseudoEither<A, B> of a pair of optionals, and prevent the creation of invalid values by providing initializers.
// This is “type safe” in the sense that you are not allowed to construct invalid values, but not “type safe” in the sense that the compiler is proving it to you. You must prove it to yourself.

// 7. Explore how the free map function composes with itself in order to transform a nested array. More specifically, if you have a doubly nested array [[A]], then map could mean either the transformation on the inner array or the outer array. Can you make sense of doing map >>> map?
