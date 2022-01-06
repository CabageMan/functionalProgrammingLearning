//import Foundation
import XCTest
@_exported import Foundation

// MARK: Testing
private extension CollectionDifference {
    func testDescription(for change: Change) -> String? {
        switch change {
        case .insert(let index, let element, let association):
            if let oldIndex = association {
                return """
                Element moved from index \(oldIndex) to \(index): \(element)
                """
            } else {
                return "Additional element at index \(index): \(element)"
            }
        case .remove(let index, let element, let association):
            // If a removal has an association, it means that
            // it's part of a move, which we're handling above.
            guard association == nil else {
                return nil
            }

            return "Missing element at index \(index): \(element)"
        }
    }
}

private extension CollectionDifference {
    func asTestErrorMessage() -> String {
        let descriptions = compactMap(testDescription)

        guard !descriptions.isEmpty else {
            return ""
        }

        return "- " + descriptions.joined(separator: "\n- ")
    }
}

func assertEqual<T: BidirectionalCollection>(
    _ first: T,
    _ second: T,
    file: StaticString = #file,
    line: UInt = #line
) where T.Element: Hashable {
    let diff = second.difference(from: first).inferringMoves()
    let message = diff.asTestErrorMessage()

    XCTAssert(message.isEmpty, """
    The two collections are not equal. Differences:
    \(message)
    """, file: file, line: line)
}

public func assertEqual<T: Equatable>(_ lhs: T, _ rhs: T) -> String {
    lhs == rhs ? "✅" : "❌"
}

public func assertEqual<A: Equatable, B: Equatable>(_ lhs: (A, B), _ rhs: (A, B)) -> String {
    lhs == rhs ? "✅" : "❌"
}

public var __: Void {
    print("__")
}

// MARK: Functions
public func incr(_ x: Int) -> Int  {
    x + 1
}

public func square(_ x: Int) -> Int {
    x * x
}

precedencegroup ForwardApplication {
    associativity: left
}
infix operator |>: ForwardApplication
public func |> <A, B> (a: A, f: (A) -> B) -> B {
    return f(a)
}

precedencegroup ForwardComposition {
    associativity: left
    higherThan: ForwardApplication
}
infix operator >>>: ForwardComposition
public func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> ((A) -> C) {
    return { a in g(f(a)) }
}
