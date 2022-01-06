import Foundation

// MARK: -Refference type
let refferenceTypeFormatter = NumberFormatter()

func decimalStyle(_ formatter: NumberFormatter) {
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
}

func currencyStyle(_ formatter: NumberFormatter) {
    formatter.numberStyle = .currency
    formatter.roundingMode = .down
}

func wholeStyle(_ formatter: NumberFormatter) {
    formatter.maximumFractionDigits = 0
}

decimalStyle(refferenceTypeFormatter)
wholeStyle(refferenceTypeFormatter)
refferenceTypeFormatter.string(for: 1234.6)

currencyStyle(refferenceTypeFormatter)
refferenceTypeFormatter.string(for: 1234.6)


decimalStyle(refferenceTypeFormatter)
wholeStyle(refferenceTypeFormatter)
refferenceTypeFormatter.string(for: 1234.6) // The result is different because we apply currency style on formatter.

// MARK: -Value Type

struct NumberFormatterConfig {
    var numberStyle: NumberFormatter.Style = .none
    var roundingMode: NumberFormatter.RoundingMode = .up
    var maximumFractionDigits: Int = 0
    
    var formatter: NumberFormatter {
        let result = NumberFormatter()
        result.numberStyle = self.numberStyle
        result.roundingMode = self.roundingMode
        result.maximumFractionDigits = self.maximumFractionDigits
        return result
    }
}
// These functions takes the entire formatter, make it's copy and return copy.
func decimalStyle(_ format: NumberFormatterConfig) -> NumberFormatterConfig {
    var format = format
    format.numberStyle = .decimal
    format.maximumFractionDigits = 2
    return format
}

func currencyStyle(_ format: NumberFormatterConfig) -> NumberFormatterConfig {
    var format = format
    format.numberStyle = .currency
    format.roundingMode = .down
    return format
}

func wholeStyle(_ format: NumberFormatterConfig) -> NumberFormatterConfig {
    var format = format
    format.maximumFractionDigits = 0
    return format
}

decimalStyle >>> currencyStyle

let valueTypeFormatter = NumberFormatterConfig()

wholeStyle(decimalStyle(valueTypeFormatter))
    .formatter
    .string(for: 1234.6)
wholeStyle(currencyStyle(valueTypeFormatter))
    .formatter
    .string(for: 1234.6)
wholeStyle(decimalStyle(valueTypeFormatter))
    .formatter
    .string(for: 1234.6)

// MARK: In Out modifications
func inoutDecimalStyle(_ format: inout NumberFormatterConfig) {
    format.numberStyle = .decimal
    format.maximumFractionDigits = 2
}

func inoutCurrencyStyle(_ format: inout NumberFormatterConfig) {
    format.numberStyle = .currency
    format.roundingMode = .down
}

func inoutWholeStyle(_ format: inout NumberFormatterConfig) {
    format.maximumFractionDigits = 0
}

var config = NumberFormatterConfig()

inoutDecimalStyle(&config)
inoutWholeStyle(&config)
config.formatter.string(for: 1234.6)

inoutCurrencyStyle(&config)
config.formatter.string(for: 1234.6)

inoutDecimalStyle(&config)
inoutWholeStyle(&config)
config.formatter.string(for: 1234.6)


// MARK: InOut Converting
func toInOut<A>(_ f: @escaping (A) -> A) -> (inout A) -> Void {
    return { a in
        a = f(a)
    }
}

func fromInOut<A>(_ f: @escaping (inout A) -> Void) -> (A) -> A {
    return { a in
        var a = a
        f(&a)
        return a
    }
}

precedencegroup SingleTypeComposition {
    associativity: left
    higherThan: ForwardApplication
}
infix operator <>: SingleTypeComposition
func <> <A>(_ f: @escaping (A) -> A, g: @escaping (A) -> A) -> (A) -> A {
    return f >>> g
}
func <> <A>(_ f: @escaping (inout A) -> Void, g: @escaping (inout A) -> Void) -> (inout A) -> Void {
    return { a in
        f(&a)
        g(&a)
    }
}
func |> <A>(a: inout A, f: (inout A) -> Void) -> Void {
    f(&a)
}

//config |> decimalStyle <> wholeStyle
//config.formatter.string(for: 1234.6)

config |> currencyStyle
config.formatter.string(for: 1234.6)

config |> decimalStyle <> wholeStyle
config.formatter.string(for: 1234.6)


config |> inoutDecimalStyle <> inoutCurrencyStyle
