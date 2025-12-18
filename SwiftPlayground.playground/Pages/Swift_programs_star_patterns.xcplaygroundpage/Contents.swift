//: [Previous](@previous)

import Foundation

/*
 *
 **
 ***
 ****
 */

var row = 4
var coloum = 4

//for i in stride(from: 0, to: row, by: 1) {
//    for j in stride(from: 0, through: i, by: 1) {
//        print("*",terminator: "")
//    }
//    print(terminator: "\n")
//}

/*
    *
   **
  ***
 ****
 */
//for i in stride(from: 0, to: row, by: 1) {
//    for j in stride(from: row - 1, to: i, by: -1) {
//        print(" ",terminator: "")
//    }
//    for j in stride(from: 0, through: i, by: 1) {
//        print("*",terminator: "")
//    }
//    print(terminator: "\n")
//}

/*
 ****
 ***
 **
 *
 */

//for i in 0..<row {
//    for j in stride(from: row - i, to: 0, by: -1) {
//        print("*", terminator: "")
//    }
//    print(terminator: "\n")
//}

/*
 * * * *
  * * *
   * *
    *
 */

//for i in 0..<row {
//    for k in 0..<i {
//        print(" ", terminator: "")
//    }
//    for j in (0..<(row - i)) {
//        print(" *", terminator: "")
//    }
//    print("\n")
//}

/*
    *
   * *
  * * *
 * * * *
  * * *
   * *
    *
 */

//for i in 0..<row {
//    for e in 0..<row - 1 - i {
//        print(" ", terminator: "")
//    }
//    for j in 0...i {
//        print(" *", terminator: "")
//    }
//    print(terminator: "\n")
//}
//for j in 0..<row - 1 {
//    for e in 0...j{
//        print(" ", terminator: "")
//    }
//    for k in 0..<row - j - 1{
//        print(" *", terminator: "")
//    }
//    print(terminator: "\n")
//}

/*
  * * * *
   * * *
    * *
     *
     *
    * *
   * * *
  * * * *
 */

for i in 0..<row {
    for s in 0..<i {
        print(" ", terminator: "")
    }
    for j in 0..<coloum - i {
        print(" *", terminator: "")
    }
    print(terminator: "\n")
}
for i in 0..<row {
    for s in 0..<coloum - 1 - i {
        print(" ", terminator: "")
    }
for j in 0...i {
        print(" *", terminator: "")
    }
    print(terminator: "\n")
}


/*
 *
 **
 ***
 ****
 ***
 **
 *
 */

//for i in 0..<row {
//    for j in 0...i {
//        print("*", terminator: "")
//    }
//    print(terminator:"\n")
//}
//for i in 0..<row - 1 {
//    for j in 0..<row - 1 - i {
//        print("*", terminator: "")
//    }
//    print(terminator:"\n")
//}

/*
 ****
 ***
 **
 *
 **
 ***
 ****
 */

for i in 0..<row {
    for j in 0..<row - i {
        print("*", terminator: "")
    }
    print(terminator:"\n")
}
for i in 0..<row {
    for j in 0...i + 1 {
        print("*", terminator: "")
    }
    print(terminator:"\n")
}

/*
 1
 12
 123
 1234
 */
//for i in stride(from: 0, to: row, by: 1) {
//    for j in stride(from: 0, through: i, by: 1) {
//        print(j+1,terminator: "")
//    }
//    print(terminator: "\n")
//}

/*
 1234
 123
 12
 1
 */
//for i in stride(from: 0, to: row, by: 1) {
//    for j in stride(from: 0, to: row - i, by: 1) {
//        print(j+1,terminator: "")
//    }
//    print(terminator: "\n")
//}

/*
 A
 AB
 ABC
 ABCD
 */


//for i in stride(from: 0, to: row, by: 1) {
//    var charValue = UnicodeScalar("A").value
//    for j in stride(from: 0, through: i, by: 1) {
//        print("\(Character(UnicodeScalar(charValue)!))", terminator: "")
//        charValue += 1
//    }
//    print(terminator: "\n")
//}

/*
 A
 BB
 CCC
 DDDD
 */

//var charValue = UnicodeScalar("A").value
//for i in 0..<row {
//    for j in 0...i {
//        print("\(Character(UnicodeScalar(charValue)!))", terminator: "")
//    }
//    charValue += 1
//    print(terminator: "\n")
//}

/*
 1
 2 3
 4 5 6
 7 8 9 10
 */
//var countOne = 0
//for i in stride(from: 0, to: row, by: 1) {
//    for j in stride(from: 0, through: i, by: 1) {
//        countOne += 1
//        print("\(countOne) ",terminator: "")
//    }
//    
//    print(terminator: "\n")
//}
/*
 0
 01
 012
 0123
 01234
 */
//for i in  0...4{
//    for j in stride(from: 4, to: i, by: -1) {
//        print(terminator : " ")
//    }
//    for k in 0...i {
//        print(k,terminator : "")
////        print("\(k)\n")
//    }
//    print(" ")
//}

/*
 54321
 5432
 543
 54
 5
 */
//for i in stride(from: 0, to: 5, by: 1){
//    for j in stride(from: 5, to: i, by: -1){
//        print(j , terminator : "")
//    }
//    print(" ")
//}

/*
 5
 5 4
 5 4 3
 5 4 3 2
 5 4 3 2 1
 */
//for i in stride(from: 5, to: 0, by: -1)
//{
//    
//    for j in stride(from: 5, to: i-1, by: -1){
//        
//        print(j , terminator : "")
//    }
//    print(" ")
//}

/*
 1 2 3 4 5
 1 2 3 4
 1 2 3
 1 2
 1
 */
//for i in stride(from: 5, to: 0, by: -1)
//{
//    for j in 1...i{
//        print(j, terminator : "")
//    }
//    print(" ")
//}

/*
 1
 2 3
 4 5 6
 7 8 9 10
 11 12 13 14 15
 */
//var valueOne = 0
//for i in 1...5 {
//    
//    for j in 1...i{
//        valueOne += 1
//        print(valueOne,terminator : "")
//    }
//    print(" ")
//}

/*
 1
 2 1
 3 2 1
 4 3 2 1
 5 4 3 2 1
 */
//for i in 1...5{
//    
//    for j in 1...i{
//        
//        print(i+1 - j , terminator : "")
//    }
//    print(" ")
//}
//
//for i in 1...5{
//    for j in stride(from: i, to: 0, by: -1){
//        print(j, terminator : "")
//    }
//    print(" ")
//}

/*
 1
 2 7
 3 8 13
 4 9 14 19
 5 10 15 20 25
 */
//var valueTwo = 0
//for i in 1...5{
//    
//    for j in 1...i{
//        if j != 1{
//            valueTwo = valueTwo + 5
//        }
//        else{
//            valueTwo = i
//        }
//        print(valueTwo , terminator : " ")
//    }
//    print(" ")
//}

//for i in 1...5{
//    var temp = i
//    for j in 0...i{
//        print(temp , terminator : " ")
//        temp = temp + 5
//    }
//    print(" ")
//    
//}

/*
 1
 1 2 1
 1 2 3 2 1
 1 2 3 4 3 2 1
 1 2 3 4 5 4 3 2 1
 */
//for i in 1...5{
//    
//    for j in 1...i{
//        print(j,terminator : "")
//    }
//    
//    for k in 1..<i{
//        print(i-k,terminator : "")
//    }
//    print(" ")
//}

/*
 1 2 3 4 5
 1 2 3 4
 1 2 3
 1 2
 1
 */
//for i in stride(from: 5, to: 0, by: -1){
//    for k in stride(from: 5, to: i, by: -1) {
//        print(terminator : " ")
//    }
//    for j in stride(from: 1, to: i+1, by: 1){
//        print("*",terminator : " ")
//    }
//    
//    
//    print(" ")
//}

/*
 1
 1 1
 1 2 1
 1 3 3 1
 1 4 6 4 1
 */
//for i in 1...5{
//    for j in stride(from: 5, to: i, by: -1){
//        print(i,terminator : "")
//    }
//    var temp = 1
//    
//    for k in 1...i{
//        print(temp,terminator : "")
//        temp = temp * (i - k) / (k);
//    }
//    print(" ")
//}

/*
 1
 1 2
 1 2 3
 1 2 3 4
 1 2 3 4 5
 1 2 3 4
 1 2 3
 1 2
 1
 */
//for i in 1...5{
//    for k in stride(from: 5, to: i, by: -1) {
//        print(terminator : " ")
//    }
//    
//    for j in 1...i{
//        print(j,terminator : " ")
//    }
//    print(" ")
//}
//for i in stride(from: 5, to: 0, by: -1){
//    for k in stride(from: 5, to: i-1, by: -1) {
//        print(terminator : " ")
//    }
//    for j in stride(from: 1, to: i, by: 1){
//        print(j,terminator : " ")
//    }
//    print(" ")
//}

/*
 12345
 2345
 345
 45
 5
 5
 45
 345
 2345
 12345
 */
//for i in 1...5{
//    
//    for j in stride(from: i, to: 6, by: 1){
//        print(j , terminator : "")
//    }
//    
//    print(" ")
//}
//for i in stride(from: 5, to: 0, by: -1)
//{
//    
//    for j in stride(from: i, to: 6, by: 1){
//        print(j,terminator : "")
//    }
//    print(" ")
//}

/*
 1 2 3 4 5
 2 3 4 5
 3 4 5
 4 5
 5
 */
//for i in 1...5{
//    for k in 0...i{
//        print(terminator : " ")
//    }
//    for j in stride(from: i, to: 6, by: 1){
//        print(j , terminator : " ")
//    }
//    
//    print(" ")
//}

/*
 12345
 2345
 345
 45
 5
 5
 45
 345
 2345
 12345
 */
//for i in 1...5{
//    for k in 1...i{
//        print(terminator : " ")
//    }
//    for j in stride(from: i, to: 6, by: 1){
//        print(j , terminator : "")
//    }
//    
//    print(" ")
//}
//for i in stride(from: 5, to: 0, by: -1)
//{
//    for k in 1...i{
//        print(terminator : " ")
//    }
//    for j in stride(from: i, to: 6, by: 1){
//        print(j,terminator : "")
//    }
//    print(" ")
//}

/*
 1 2 3 4 5
 2 3 4 5
 3 4 5
 4 5
 5
 5
 4 5
 3 4 5
 2 3 4 5
 1 2 3 4 5
 */
//for i in 1...5{
//    for k in 0...i{
//        print(terminator : " ")
//    }
//    for j in stride(from: i, to: 6, by: 1){
//        print(j , terminator : " ")
//    }
//    
//    print(" ")
//}
//
//for i in stride(from: 6, to: 1, by: -1){
//    for k in 1...i{
//        print(terminator : " ")
//    }
//    for j in stride(from: i-1, to: 6, by: 1){
//        print(j , terminator : " ")
//    }
//    
//    print(" ")
//}

/*
 1
 1 0
 1 0 1
 1 0 1 0
 1 0 1 0 1
 */
//for i in 0...4{
//    for j in 0...i{
//        if j % 2 == 0{
//            print(1,terminator : " ")
//        }
//        else{
//            print(0,terminator : " ")
//        }
//    }
//    print(" ")
//    
//}

/*
 1 0 0 0 0
 0 2 0 0 0
 0 0 3 0 0
 0 0 0 4 0
 0 0 0 0 5
 */
//for i in 1...5{
//    for j in 1...5{
//        
//        if j == i{
//            print(j,terminator : " ")
//        }
//        else{
//            print(0,terminator : " ")
//        }
//        
//    }
//    print(" ")
//}
//: [Next](@next)
