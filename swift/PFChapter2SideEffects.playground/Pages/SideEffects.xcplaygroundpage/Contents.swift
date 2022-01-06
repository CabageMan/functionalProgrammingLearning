// MARK: Side Effects With Hidden Outputs

// MARK: --Compute
func compute(_ x: Int) -> Int {
    return x * x + 1
}

compute(3)
assertEqual(10, compute(3))
assertEqual(3, compute(3))


// MARK: --Compute With Side Effects
func computeWithSideEffect(_ x: Int) -> Int {
    let result = x * x + 1
    print("Computed: \(result)")
    return result
}

computeWithSideEffect(3)
assertEqual(10, computeWithSideEffect(3))
assertEqual(3, computeWithSideEffect(3))
 
[2, 10].map(compute).map(compute)
[2, 10].map(compute >>> compute)

__
[2, 10].map(computeWithSideEffect).map(computeWithSideEffect)
__
[2, 10].map(computeWithSideEffect >>> computeWithSideEffect)


// MARK: --Compute and Print
func computeAndPrint(_ x: Int) -> (Int, [String]) {
    let result = x * x + 1
    return (result, ["Computed: \(result)"])
}

__
computeAndPrint(3)
assertEqual(
    (10, ["Computed: 10"]),
    computeAndPrint(3)
)
assertEqual(
    (9, ["Computed: 10"]),
    computeAndPrint(3)
)
assertEqual(
    (10, ["Computed: 9"]),
    computeAndPrint(3)
)

__
let (computation, logs) = computeAndPrint(3)
logs.forEach { print($0) }

__
3 |> compute >>> compute
3 |> computeWithSideEffect >>> computeWithSideEffect

func compose<A, B, C>(
    _ f: @escaping (A) -> (B, [String]),
    _ g: @escaping (B) -> (C, [String])
) -> ((A) -> (C, [String])) {
    { a in
        let (b, logs) = f(a)
        let (c, moreLogs) = g(b)
        return (c, logs + moreLogs)
    }
}

3 |> compose(computeAndPrint, computeAndPrint)

3 |> compose(compose(computeAndPrint, computeAndPrint), computeAndPrint)

3 |> compose(computeAndPrint, compose(computeAndPrint, computeAndPrint))

compose(computeAndPrint, computeAndPrint)


precedencegroup EffectfulComposition {
    associativity: left
    higherThan: ForwardApplication
    lowerThan: ForwardComposition
}
infix operator >=>: EffectfulComposition
public func >=> <A, B, C>(
    _ f: @escaping (A) -> (B, [String]),
    _ g: @escaping (B) -> (C, [String])
) -> ((A) -> (C, [String])) {
    { a in
        let (b, logs) = f(a)
        let (c, moreLogs) = g(b)
        return (c, logs + moreLogs)
    }
}

3
    |> computeAndPrint
    >=> incr
    >>> computeAndPrint
    >=> square
    >>> computeAndPrint

public func >=> <A, B, C>(
    _ f: @escaping (A) -> B?,
    _ g: @escaping (B) -> C?
) -> ((A) -> C?) {
    { a in
        fatalError()
    }
}

String.init(utf8String:) >=> URL.init(string:)

public func >=> <A, B, C>(
    _ f: @escaping (A) -> [B],
    _ g: @escaping (B) -> [C]
) -> ((A) -> [C]) {
    { a in
        fatalError()
    }
}

//public func >=> <A, B, C>(
//    _ f: @escaping (A) -> Promise<B>,
//    _ g: @escaping (B) -> Promise<B>
//) -> ((A) -> Promise<C>) {
//    { a in
//        fatalError()
//    }
//}

// MARK: Side Effects With Hidden Inputs

func greetWithEffect(_ name: String) -> String {
    let seconds = Int(Date().timeIntervalSince1970) % 60
    return "Hello, \(name)! It's \(seconds) past the minute."
}

greetWithEffect("Blob")
assertEqual("Hello, Blob! It's 47 past the minute.", greetWithEffect("Blob"))

func greet(at date: Date = Date(), name: String) -> String {
    let seconds = Int(date.timeIntervalSince1970) % 60
    return "Hello, \(name)! It's \(seconds) past the minute."
}

greet(at: Date(), name: "Blob")
assertEqual(
    "Hello, Blob! It's 10 past the minute.",
    greet(at: Date(timeIntervalSince1970: 10), name: "Blob")
)
assertEqual(
    "Hello, Blob! It's 11 past the minute.",
    greet(at: Date(timeIntervalSince1970: 10), name: "Blob")
)
assertEqual(
    "Hello, Blob! It's 10 past the minute.",
    greet(at: Date(timeIntervalSince1970: 11), name: "Blob")
)


greetWithEffect

func uppercased(_ string: String) -> String {
    string.uppercased()
}

"Blob" |> uppercased >>> greetWithEffect
"Blob" |> greetWithEffect >>> uppercased

greet

func greet(at date: Date) -> (String) -> String {
    return { name in
        let seconds = Int(date.timeIntervalSince1970) % 60
        return "Hello, \(name)! It's \(seconds) past the minute."
    }
}

"Blob" |> greet(at: Date()) >>> uppercased
"Blob" |> uppercased >>> greet(at: Date())
assertEqual(
    "Hello, BLOB! It's 5 past the minute.",
    "Blob" |> uppercased >>> greet(at: Date(timeIntervalSince1970: 5))
)
