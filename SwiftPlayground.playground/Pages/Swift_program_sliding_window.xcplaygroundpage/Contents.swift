//: [Previous](@previous)
import Foundation

/*:
 Input: s = "abcabcbb"
 Output: 3
 Explanation: The answer is "abc", with the length of 3. Note that "bca" and "cab" are also correct answers.
 */

func lengthOfLongestSubstring(_ s: String) {
    
    var leftIndex = 0
    var maxLen = 0
    var store: [Character:Int] = [:]
    for (rightIndex, char) in s.enumerated() {
        print(rightIndex, char)
        
        if var index = store[char], index >= leftIndex {
            leftIndex = index + 1
        }
        store[char] = rightIndex
        maxLen = max(maxLen, rightIndex - leftIndex + 1)
    }
    print(maxLen)
}

//lengthOfLongestSubstring("abcabcbb")
//lengthOfLongestSubstring("bbbbb")
//lengthOfLongestSubstring("pwwkew")
//lengthOfLongestSubstring("pwwkew")

/*:
 Input: s = "barfoothefoobarman", words = ["foo","bar"]

 Output: [0,9]

 Explanation:

 The substring starting at 0 is "barfoo". It is the concatenation of ["bar","foo"] which is a permutation of words.
 The substring starting at 9 is "foobar". It is the concatenation of ["foo","bar"] which is a permutation of words.
 */
func findSubstring(_ s: String, _ words: [String]) -> [Int] {
    
    
    
    return []
}
print(findSubstring("barfoothefoobarman", ["foo","bar"]))
//: [Next](@next)
