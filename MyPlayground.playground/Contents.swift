import UIKit

var str = "Hello, playground"
str = "Hello, Swift"
let constStr = str

var nextYear: Int
var bodyTemp: Float
var hasPet: Bool
var arrayOfInts: [Int]
var dictionaryOfCapitalsByCountry: [String:String]
var winningLotteryNumbers: Set<Int>
let number = 42
let fmStation = 91.1
var countingUP = ["one", "two"]
let secondElement = countingUP[1]
let nameByParkingPlace = [13: "Alice", 27: "Bob"]

let emptyString = String()
let emptyArrayOfint = [Int]()
let emptySetOfFloats = Set<Float>()
let defaultNumber = Int()
let defaultBool = Bool()
let meaningOfLife = String(number)
let availableRooms = Set([205, 411, 412])
let defaultFloat = Float()
let floatFromLiteral = Float(3.14)
let easyPi = 3.14
let floatFromDouble = Float(easyPi)
let floatingPi: Float = 3.14
countingUP.count
emptyString.isEmpty
countingUP.append("three")

var reading1:Float?
var reading2:Float?
var reading3:Float?
reading1 = 9.8
reading2 = 9.2
reading3 = 9.7
if let r1 = reading1, let r2 = reading2, let r3 = reading3 {
    let avgReading = (r1 + r2 + r3) / 3
} else {
    let errorString = "Intrument reported a reading that was nil."
}

if let space13Assignee = nameByParkingPlace[13] {
    print("Key 13 is assigned in the dictionary")
}
let space43Assignee: String? = nameByParkingPlace[42]
for (space, name) in nameByParkingPlace {
    let permit = "Space \(space): \(name)"
}

enum PieType: Int {
    case apple = 0
    case cherry
    case pecan
}

let favoritePie = PieType.apple

let name: String
switch  favoritePie {
case .apple:
    name = "Apple"
case .cherry:
    name = "Cherry"
case .pecan:
    name = "Pecan"
}

let pieRawValue = PieType.pecan.rawValue
// pieRawvalue is an Int with a value of 2

if let pieType = PieType(rawValue: pieRawValue) {
//    Got a valid 'pieType'!
}


let http404Error = (404, "Not Found")
// http404Error is of type (Int, String), and equals (404, "Not Found")

let (statusCode, statusMessage) = http404Error
print("The status code is \(statusCode)")
// Prints "The status code is 404"
print("The status message is \(statusMessage)")
// Prints "The status message is Not Found" q

let age = -3
assert(age >= 0, "A person's age can't be less than zero.")
