import Foundation

///
/// Useful things for working with Emoji.
///
public final class Emoji : EmojiData {
    
    ///
    /// Pattern that matches a single Emoji character, including combining marks and sequences.
    ///
    public static var SingleEmojiPattern:String = {
        // The "emoji" group needs to be followed by a special character to be rendered like emoji.
        let emojiVariants = "(?:(?:\(EmojiPatterns.joinWithSeparator("|")))\\uFE0F{0,1})"
        
        // Emoji can be followed by optional combining marks. The standard says only keycaps and
        // backslash are likely to be supported.
        let combiningMarks = "[\\u20E3\\u20E0]"
        
        // "Presentation" characters are rendered as emoji by default and need no variant.
        let emojiPresentation = "\(EmojiPresentationPatterns.joinWithSeparator("|"))"
        
        // Some other emoji are sequences of characters, joined with 'Zero Width Joiner' characters.
        // We want the longest match, so we sort these in reverse order.
        let zwjSequences = ZWJSequencePatterns.reverse().joinWithSeparator("|")
        let otherSequences = SequencePatterns.joinWithSeparator("|")
        
        return "(?:(?:\(zwjSequences)|\(otherSequences)|\(emojiVariants)|\(emojiPresentation))\(combiningMarks)?)"
    }()
    
    /// A regular expression that matches any emoji character. Useful for plucking individual emoji
    /// out of a string.
    public static var SingleEmojiRegex:NSRegularExpression = {
        return try! NSRegularExpression(pattern:SingleEmojiPattern, options:[])
    }()
    
    /// Pattern that matches one or more emoji characters in a row.
    public static var MultiEmojiPattern:String = {
        return "(?:\(SingleEmojiPattern)+)"
    }()
    
    /// Matches one or more emoji characters in a row.
    public static var MultiEmojiRegex:NSRegularExpression = {
        return try! NSRegularExpression(pattern:MultiEmojiPattern, options:[])
    }()
    
    ///
    /// Pattern that matches one or more Emoji or whitespace characters in a row. At least one emoji
    /// character is required; empty or blank strings will not be matched. Leading and trailing
    /// whitespace will be included in the match range.
    ///
    public static var MultiEmojiAndWhitespacePattern:String = {
        return "(?:(?:\\s*\(MultiEmojiPattern))+\\s*)"
    }()

    ///
    /// Matches one or more Emoji or whitespace characters in a row. At least one emoji character is
    /// required; empty or blank strings will not be matched. Leading and trailing whitespace will
    /// be included in the match range.
    ///
    public static var MultiEmojiAndWhitespaceRegex:NSRegularExpression = {
        return try! NSRegularExpression(pattern:MultiEmojiAndWhitespacePattern, options:[])
    }()

    ///
    /// Pattern that matches any string composed solely of emoji and (optional) whitespace. Empty or
    /// blank strings will not match.
    ///
    public static var PureEmojiAndWhitespacePattern:String = {
        return "^\(MultiEmojiAndWhitespacePattern)$"
    }()
    
    ///
    /// Matches any string composed solely of emoji and (optional) whitespace. Empty or blank
    /// strings will not match.
    ///
    public static var PureEmojiAndWhitespaceRegex:NSRegularExpression = {
        return try! NSRegularExpression(pattern:PureEmojiAndWhitespacePattern, options:[])
    }()
    
    ///
    /// Returns `true` if the given string is composed solely of emoji and (optional) whitespace.
    /// Empty or blank strings will not match.
    ///
    public static func isPureEmojiString(string:String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        let firstMatch = PureEmojiAndWhitespaceRegex.rangeOfFirstMatchInString(string, options:[], range:range)
        return firstMatch.location != NSNotFound
    }
    
}
