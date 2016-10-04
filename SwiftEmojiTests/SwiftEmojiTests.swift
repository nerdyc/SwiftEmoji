//
//  SwiftEmojiTests.swift
//  SwiftEmojiTests
//
//  Created by Christian Niles on 4/25/16.
//  Copyright © 2016 Christian Niles. All rights reserved.
//

import XCTest
import SwiftEmoji

class SwiftEmojiTests: XCTestCase {
    
    func test_SingleEmoji() {
        let matches = Emoji.SingleEmojiRegex.extractMatchesInString(
            "simple: 👍; fitzpatrick: 👎🏼 flag: 🇨🇦 keycap: 9️⃣0️⃣ sequence 👨‍👩‍👧‍👧 sequence with combining mark: 👨‍👩‍👧‍👦⃠"
        )
        XCTAssertEqual(matches, ["👍", "👎🏼", "🇨🇦", "9️⃣", "0️⃣", "👨‍👩‍👧‍👧", "👨‍👩‍👧‍👦⃠"])
    }
    
    func test_MultiEmoji() {
        let matches = Emoji.MultiEmojiRegex.extractMatchesInString(
            "simple: 👍 👎🏼😳 flag: 🇨🇦 keycap: 9️⃣0️⃣ sequence 👨‍👩‍👧‍👧 sequence with combining mark: 👨‍👩‍👧‍👦⃠"
        )
        XCTAssertEqual(matches, ["👍", "👎🏼😳", "🇨🇦", "9️⃣0️⃣", "👨‍👩‍👧‍👧", "👨‍👩‍👧‍👦⃠"])
    }
    
    func test_MultiEmojiAndWhitespace() {
        let matches = Emoji.MultiEmojiAndWhitespaceRegex.extractMatchesInString(
            "simple: 👍 👎🏼😳 flag: 🇨🇦 keycap: 9️⃣0️⃣ sequence 👨‍👩‍👧‍👧 sequence with combining mark: 👨‍👩‍👧‍👦⃠"
        )
        
        // note that whitespace is also included
        XCTAssertEqual(matches, [" 👍 👎🏼😳 ", " 🇨🇦 ", " 9️⃣0️⃣ ", " 👨‍👩‍👧‍👧 ", " 👨‍👩‍👧‍👦⃠"])
    }
    
    func test_isPureEmojiString() {
        // TEST: Single character emoji
        XCTAssertTrue(Emoji.isPureEmojiString("😔"))
        XCTAssertTrue(Emoji.isPureEmojiString("🇨🇦")) // flag sequence
        XCTAssertTrue(Emoji.isPureEmojiString("👨‍👨‍👧‍👧")) // family sequence
        XCTAssertTrue(Emoji.isPureEmojiString("0️⃣")) // keycap sequence
        XCTAssertTrue(Emoji.isPureEmojiString("👶🏿")) // skin tone sequence
        XCTAssertTrue(Emoji.isPureEmojiString("👨‍👩‍👧‍👦⃠")) // sequence with combining mark
        
        // TEST: Multiple character emoji
        XCTAssertTrue(Emoji.isPureEmojiString("😔😔"))
        
        // TEST: Whitespace is ignored
        XCTAssertTrue(Emoji.isPureEmojiString(" 😔 😔 "))
        
        // TEST: A mix of emoji and text returns false
        XCTAssertFalse(Emoji.isPureEmojiString("👌 job!"))
        
        // TEST: No emoji at all
        XCTAssertFalse(Emoji.isPureEmojiString("Nice job!"))
    }
    
    func test_Emoji30() {
        XCTAssertTrue(Emoji.isPureEmojiString("🕵🏾"))
        XCTAssertTrue(Emoji.isPureEmojiString("🤰")) // pregnant woman, unicode 9.0
    }
    
}

// =================================================================================================
// MARK:- Test Helpers

extension NSRegularExpression {
    
    func extractMatchesInString(string:String) -> [String] {
        let range = NSRange(location: 0, length: string.utf16.count)
        return matchesInString(string, options: [], range: range).map() { result in
            (string as NSString).substringWithRange(result.range)
        }
    }
    
}
