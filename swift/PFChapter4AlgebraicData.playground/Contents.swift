import Foundation

// MARK: Struct "Algebra"
struct Pair<A, B> {
    let first: A
    let second: B
}

Pair<Bool, Bool>.init(first: true, second: true)
Pair<Bool, Bool>.init(first: true, second: false)
Pair<Bool, Bool>.init(first: false, second: true)
Pair<Bool, Bool>.init(first: false, second: false)
// 4 variants of creation

enum Three {
    case one, two, three
}

Pair<Bool, Three>.init(first: true, second: .one)
Pair<Bool, Three>.init(first: true, second: .two)
Pair<Bool, Three>.init(first: true, second: .three)
Pair<Bool, Three>.init(first: false, second: .one)
Pair<Bool, Three>.init(first: false, second: .two)
Pair<Bool, Three>.init(first: false, second: .three)
// 6 variants of creation

let _: Void = Void()
let _: Void = ()
let _: () = ()

Pair<Bool, Void>.init(first: true, second: ())
Pair<Bool, Void>.init(first: false, second: ())
// 2 variants of creation

Pair<Void, Void>.init(first: (), second: ())
// 1 variants of creation

enum Never { }

//let _: Never = ???
// This type is enum without any cases, there is no info to pass to it on init.

//Pair<Bool, Never>.init(first: true, second: ???)

//Pair<Bool, Bool> = 4 = 2 * 2
//Pair<Bool, Three> = 6 = 2 * 3
//Pair<Bool, Void> = 2 = 2 * 1
//Pair<Void, Void> = 1 = 1 * 1
//Pair<Bool, Never> = 0 = 2 * 0

// It's like logical conjunction

enum Theme {
    case light, dark
}

enum State {
    case highlighted, normal, selected
}

struct Component {
    let enabled: Bool
    let state: State
    let theme: Theme
}

// Variants of creation of Component:
// 2 * 3 * 2 = 12

// Type Abstraction

//Pair<Bool, Bool> = Bool * Bool
//Pair<Bool, Three> = Bool * Three
//Pair<Bool, Void> = Bool * Void
//Pair<Void, Void> = Void * Void
//Pair<Bool, Never> = Void * Never

// Examples of Infinity results
//Pair<Bool, String> = Bool * String
//String * [Int]
//String * [[Int]]


// MARK: Enum "Algebra"

enum Either<A, B> {
    case left(A)
    case right(B)
}

Either<Bool, Bool>.left(true)
Either<Bool, Bool>.left(false)
Either<Bool, Bool>.right(true)
Either<Bool, Bool>.right(false)
// 4 variants of creation

Either<Bool, Three>.left(true)
Either<Bool, Three>.left(false)
Either<Bool, Three>.right(.one)
Either<Bool, Three>.right(.two)
Either<Bool, Three>.right(.three)
// 5 variants of creation

Either<Bool, Void>.left(true)
Either<Bool, Void>.left(false)
Either<Bool, Void>.right(Void())
// 3 variants of creation

Either<Bool, Never>.left(true)
Either<Bool, Never>.left(false)
//Either<Bool, Never>.right(???)
// 2 variants of creation

//Either<Bool, Bool> = 2 + 2 = 4
//Either<Bool, Three> = 2 + 3 = 5
//Either<Bool, Void> = 2 + 1 = 3
//Either<Bool, Never> = 2 + 0 = 2

// It's like logical disjunction


// MARK: Arrays "Algebra"

func sum(_ xs: [Int]) -> Int {
    var result: Int = 0
    xs.forEach { result += $0 }
    return result
}

func mult(_ xs: [Int]) -> Int {
    var result: Int = 1
    xs.forEach { result *= $0 }
    return result
}

let xs = [1, 2, 3]
sum(xs)
mult(xs)

// Expectation of functions results
sum([1, 2]) + sum([3]) == sum([1, 2, 3])
mult([1, 2]) * mult([3]) == mult([1, 2, 3])

sum([1, 2]) + sum([]) == sum([1, 2])
mult([1, 2]) * mult([]) == mult([1, 2])

/* => */ sum([1, 2]) + 0 == sum([1, 2])
/* => */ mult([1, 2]) * 1 == mult([1, 2])


// MARK: Tupe "Algebra"
//Either<Pair<A, B>, Pair<A, C>>
// =>
// A * B + A * C = A * (B + C)
// =>
// Pair<A, Either<B, C>>

//Pair<Either<A, B>, Either<A, C>>
// (A + B) * (A + C) = A * A + B * A + A * C + B * C = A * (A + B) + C * (A + B)


// MARK: Real World Examples

//URLSession.shared
//    .dataTask(with: <#T##URL#>, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
// Completion handler we can represent as:

//  (Data + 1) * (URLResponse + 1) * (Error + 1)

// Optional is enum with two cases .some and .none, so it represents as A + 1
// Tuple represents as struct: A * B

//  (Data + 1) * (URLResponse + 1) * (Error + 1)
//  = Data * URLResponse * Error
//      + Data * URLResponse
//      + Data * Error
//      + Data
//      + URLResponse
//      + Error
//      + 1

// Data * URLResponse + Error
// =>
// Either<Pair<Data, URLResponse>, Error>
// It's like as Result type
//Result<(Data, URLResponse), Error>


// MARK: Exercises
// 1. What algebraic operation does the function type (A) -> B correspond to? Try explicitly enumerating all the values of some small cases like (Bool) -> Bool, (Unit) -> Bool, (Bool) -> Three and (Three) -> Bool to get some intuition.

// (A) -> B like A * B:

// (Bool) -> Bool:
// true -> true
// true -> false
// false -> true
// false -> false

// (Unit) -> Bool
// .one -> true
// .one -> false

// (Bool) -> Three
// true -> .one
// true -> .two
// true -> .three
// false -> .one
// false -> .two
// false -> three

// (Three) -> Bool
// .one -> true
// .two -> true
// .three -> true
// .one -> false
// .two -> false
// .three -> false


// 2. Consider the following recursively defined data structure. Translate this type into an algebraic equation relating List<A> to A.
indirect enum List<A> {
  case empty
  case cons(A, List<A>)
}

// List<Unit>
// .empty
// .cons(.one, .empty)
// .cons(.one, .cons(.one, .empty))
// .cons(.one, .cons(.one, .cons(.one, .empty)))
// .cons(.one, .cons(.one, .cons(.one, .cons(.one, .empty))))
// ....

// List<Bool>
// .empty

// .cons(true, .empty)
// .cons(false, .empty)

// .cons(true, .cons(true, .empty))
// .cons(true, .cons(false, .empty))
// .cons(false, .cons(true, .empty))
// .cons(false, .cons(false, .empty))

// .cons(true, .cons(true, .cons(true, .empty)))
// .cons(true, .cons(true, .cons(false, .empty)))
// .cons(true, .cons(false, .cons(true, .empty)))
// .cons(false, .cons(true, .cons(true, .empty)))
// ....

// .cons(true, .cons(true, .cons(true, .cons(true, .empty))))
// .cons(false, .cons(true, .cons(true, .cons(true, .empty))))
// .cons(true, .cons(false, .cons(true, .cons(true, .empty))))
// ....

// (1 + A)^n


// 3. Is Optional<Either<A, B>> equivalent to Either<Optional<A>, Optional<B>>? If not, what additional values does one type have that the other doesn’t?

//enum Either<A, B> {
//    case left(A)
//    case right(B)
//}

// Optional<Either<A, B>>:
// .none
// .some(.left(A))
// .some(.right(B))

// 1 + A + B

// Either<Optional<A>, Optional<B>>:
// .left(.none)
// .left(.some(A))
// .right(.none)
// .right(.some(B))

// 2 + A + B => Is Not Equal to Optional<Either<A, B>>


// 4. Is Either<Optional<A>, B> equivalent to Optional<Either<A, B>>?

// Either<Optional<A>, B>
// .left(.none)
// .left(.some(A))
// .right(B)

// 1 + A + B

// Optional<Either<A, B>>
// .none
// .some(.left(A))
// .some(.right(B))

// 1 + A + B => Is equal to Either<Optional<A>, B>


// 5. Swift allows you to pass types, like A.self, to functions that take arguments of A.Type. Overload the * and + infix operators with functions that take any type and build up an algebraic representation using Pair and Either. Explore how the precedence rules of both operators manifest themselves in the resulting types.

func +<A>(left: A, right: A) -> Either<A.Type, A.Type> {
    return Either<A.Type, A.Type>.left(left as! A.Type)
}


//func +<A>(left: A, right: A) -> Either<A.Type, A.Type>.Type {
//    let leftValue = left.self
//    let rightValue = right.self
//    return Either<leftValue, rightValue>.self
//}

func *<A>(left: A, right: A) -> Pair<A, A> {
    return Pair(first: left, second: right)
}

[1] + [2]

//Bool.self + Bool.self
Int * Int
true.self * false.self

