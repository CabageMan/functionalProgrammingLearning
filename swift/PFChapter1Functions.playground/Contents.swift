import Foundation

// MARK: Extensions
extension Int {
    func incr() -> Int {
        return self + 1
    }
    func square() -> Int {
        return self * self
    }
}

// MARK: Chapter 1 Functions

func incr(_ x: Int) -> Int  {
    x + 1
}

func square(_ x: Int) -> Int {
    x * x
}

3.incr()
3.incr().square()

precedencegroup ForwardApplication {
    associativity: left
}

infix operator |>: ForwardApplication

func |> <A, B> (a: A, f: (A) -> B) -> B {
    return f(a)
}

3 |> incr
3 |> incr |> square

precedencegroup ForwardComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator >>>: ForwardComposition

func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> ((A) -> C) {
    { a in g(f(a)) }
}

incr >>> square
square >>> incr

(incr >>> square)(3)
(square >>> incr)(3)

3 |> incr >>> square
3 |> square >>> incr

3 |> incr >>> square >>> String.init
3 |> square >>> incr >>> String.init

[1, 2, 3].map(incr).map(square)
[1, 2, 3].map(square).map(incr)

[1, 2, 3].map(incr >>> square)
[1, 2, 3].map(square >>> incr)
