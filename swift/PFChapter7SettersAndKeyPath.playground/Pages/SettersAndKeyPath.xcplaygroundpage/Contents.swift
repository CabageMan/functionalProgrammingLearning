import Foundation

struct Food {
    var name: String
}

struct Location {
    var name: String
}

struct User {
    var favoriteFoods: [Food]
    var location: Location
    var name: String
}

let user = User(
    favoriteFoods: [Food(name: "Tacos"), Food(name: "Nachos")],
    location: Location(name: "Brooklyn"),
    name: "Blob"
)

User.init(
    favoriteFoods: user.favoriteFoods,
    location: Location(name: "Los Angeles"),
    name: user.name
)

func userLocationName(_ f: @escaping (String) -> String) -> (User) -> User {
    return { user in
        User(
            favoriteFoods: user.favoriteFoods,
            location: Location(name: f(user.location.name)),
            name: user.name
        )
    }
}

user
    |> userLocationName { _ in "Los Angeles" }

user
    |> userLocationName { $0 + "!" }

// MARK: Key Path

\User.name // WritableKeyPath<User, String>

user.name
user[keyPath: \User.name]

var copyUser = user
copyUser.name = "Blobbo"
copyUser.name

copyUser[keyPath: \User.name] = "Blobber"

func prop<Root, Value>(_ kp: WritableKeyPath<Root, Value>)
    -> (@escaping (Value) -> Value)
    -> (Root) -> Root {
    return { update in
        { root in
            var copy = root
            copy[keyPath: kp] = update(copy[keyPath: kp])
            return copy
        }
    }
}


prop(\User.name) // (String) -> String -> (User) -> User
user.name
(prop(\User.name)) { _ in "Blobbo" }
(prop(\User.name)) { $0.uppercased() }

// Let's dive dipper to other structs
prop(\User.location) <<< prop(\Location.name)
// KeyPath is composible out of box, so:
prop(\User.location.name)

// Let's use it
user
    |> (prop(\User.name)) { _ in "Blobbo" }
    |> (prop(\User.location.name)) { _ in "Loss Angeles" }

(23, user)
    |> (second <<< prop(\User.name)) { $0.uppercased() }
    |> first(incr)

// or more easier
user
    |> (prop(\.name)) { _ in "Blobbo" }
    |> (prop(\.location.name)) { _ in "Loss Angeles" }

(23, user)
    |> (second <<< prop(\.name)) { $0.uppercased() }
    |> first(incr)

user.favoriteFoods
    .map { Food(name: $0.name + " & Salad") }

let makeHealthier = (prop(\User.favoriteFoods) <<< map <<< prop(\.name)) { $0 + " & Salad" }

//dump(user)
//dump(user |> makeHealthier)
//dump(user |> makeHealthier |> makeHealthier)
//dump(
//    user
//        |> makeHealthier
//        |> makeHealthier
//        |> (prop(\User.location.name)) { _ in "Miami" }
//        |> (prop(\User.name)) { "Healthy " + $0 }
//)
//dump(
//    (23, user)
//        |> second(makeHealthier)
//        |> second(makeHealthier)
//        |> (second <<< prop(\User.location.name)) { _ in "Miami" }
//        |> (second <<< prop(\User.name)) { "Healthy " + $0 }
//        |> first(incr)
//)

second(makeHealthier)
    <> second(makeHealthier)
    <> (second <<< prop(\User.location.name)) { _ in "Miami" }
    <> (second <<< prop(\User.name)) { "Healthy " + $0 }
    <> first(incr)

second(
    makeHealthier
        <> makeHealthier
        <> (prop(\User.location.name)) { _ in "Miami" }
        <> (prop(\User.name)) { "Healthy " + $0 }
)
<> first(incr)


var newUser = user
newUser.name = "Blobbo"
newUser.location.name = "Los Angeles"
newUser.favoriteFoods = copyUser.favoriteFoods.map { Food(name: $0.name + " & Salad") }

// Stopped at 17:02
