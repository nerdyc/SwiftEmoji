namespace :emoji do
  
  task :environment do |t|
    $ROOT_DIR = File.expand_path("..", t.application.rakefile)
  end

  desc %{Generates swift sources from Unicode Emoji data files.}
  task :generate_sources => :environment do
    data_path = File.join($ROOT_DIR, "tasks", "emoji", "emoji-data.txt")
    data = Emoji.parse_entries(data_path)
    
    sequences_path = File.join($ROOT_DIR, "tasks", "emoji", "emoji-sequences.txt")
    sequences = Emoji.parse_entries(sequences_path)

    zwj_sequences_path = File.join($ROOT_DIR, "tasks", "emoji", "emoji-zwj-sequences.txt")
    zwj_sequences = Emoji.parse_entries(zwj_sequences_path)
    
    emoji_entries = data.select { |e| e.property == "Emoji" }
    emoji__presentation_entries = data.select { |e| e.property == "Emoji_Presentation" }
    modifier_entries = data.select { |e| e.property == "Emoji_Modifier" }
    modifier_bases = data.select { |e| e.property == "Emoji_Modifier_Base" }
    
    swift_source_code = <<-SWIFT
//
// DO NOT EDIT. This file was auto-generated from the Unicode data files located at:
//
//    http://www.unicode.org/Public/emoji/2.0/
//
// To regenerate it, use the rake tasks in the SwiftEmoji project.

///
/// A Swift-ified version of Unicode's Emoji data files, located at:
///
///   http://www.unicode.org/Public/emoji/2.0/
///
public class EmojiData {
    
    ///
    /// Patterns that match characters in the "Emoji" group. Note that characters in this group are
    /// (confusingly) not rendered as Emoji by default. They must be followed by the U+FE0F (variant
    /// selector) character to be rendered as Emoji.
    /// 
    public static let EmojiPatterns:[String] = [
        #{Emoji::Entry.to_swift_array_entries(emoji_entries).join("\n        ")}
    ]

    ///
    /// Patterns that match characters in the "Emoji Presentation" group. These characters are
    /// rendered as Emoji by default, and do not need a variant selector, unlike `EmojiPatterns`.
    ///
    public static let EmojiPresentationPatterns:[String] = [
        #{Emoji::Entry.to_swift_array_entries(emoji__presentation_entries).join("\n        ")}
    ]
  
    ///
    /// Patterns that match "Emoji_Modifier_Base" characters, which are those that can be modified
    /// by "Emoji_Modifier" (skintone) characters.
    ///
    public static let ModifierBasePatterns:[String] = [
        #{Emoji::Entry.to_swift_array_entries(modifier_bases).join("\n        ")}
    ]
    
    ///
    /// Patterns that match "Emoji_Modifier" characters (Skin Tones, aka. Fitzpatrick Modifiers).
    /// These modifiers follow the characters in the "Emoji_Modifier_Base" group.
    ///
    public static let ModifierPatterns:[String] = [
        #{Emoji::Entry.to_swift_array_entries(modifier_entries).join("\n        ")}
    ]
    
    ///
    /// Patterns that match emoji sequences. This includes keycap characters, flags, and skintone
    /// variants, but not Zero-Width-Joiner (ZWJ) sequences used for "family" characters like
    /// "👨‍👩‍👧‍👧".
    ///
    public static let SequencePatterns:[String] = [
        #{Emoji::Entry.to_swift_array_entries(sequences).join("\n        ")}
    ]

    ///
    /// Patterns that match Zero-Width-Joiner (ZWJ) sequences used for "family" characters like
    /// "👨‍👩‍👧‍👧".
    ///
    public static let ZWJSequencePatterns:[String] = [
        #{Emoji::Entry.to_swift_array_entries(zwj_sequences).join("\n        ")}
    ]
  
    internal init() {
      // prevent instantiation.
    }
    
}
  
SWIFT
    
    source_file = File.join($ROOT_DIR, "Sources", "EmojiData.swift")
    File.open(source_file, "w") { |f|
      f << swift_source_code
    }
    
  end
  
end

module Emoji
  
  def self.parse_entries(path)
    entries = []
  
    File.open(path) do |f|
      f.each_line do |line|
        match = line.match(/^\s*([^#]+?)\s*(;\s*([^#]+)\s*)?\#(.*)$/)
        if match != nil
          range = match[1]
          property = match[3]
          comment = match[4]
          
          entries << Emoji::Entry.new(range, property, comment)
        end
      end
    end
  
    entries.sort { |a,b| a.codepoints <=> b.codepoints }
  end
  
  def self.hex_code_to_escape(hex)
    if hex.length == 4
      "\\\\u#{hex}"
    elsif hex.length == 5
      "\\\\U000#{hex}"
    else
      abort "Unknown hex code: #{hex}"
    end
  end
  
  class Entry
    
    attr_reader :codepoints, :property, :comment
    
    def initialize(codepoints, property, comment)
      @codepoints = codepoints.strip
      if property != nil
        @property = property.strip
      end
      @comment = comment.strip
    end
    
    def to_swift_pattern
      parts = codepoints.split /\s+/
      pattern = parts.map do |p|
        if p =~ /^([a-f0-9]+)$/i
          Emoji.hex_code_to_escape($1)
        elsif p =~ /^([a-f0-9]+)\.\.([a-f0-9]+)$/i
          start_code = Emoji.hex_code_to_escape($1)
          end_code = Emoji.hex_code_to_escape($2)
          
          "[#{start_code}-#{end_code}]"
        else
          abort "Unknown line: #{codepoints}"  
        end
      end.join("")
      
      return pattern      
    end
    
    def self.to_swift_array_entries(entries)
      patterns = []
      entries.each_with_index do |entry, index|
        if index == entries.length - 1
          patterns << "\"#{entry.to_swift_pattern}\"     // #{entry.comment}"
        else
          patterns << "\"#{entry.to_swift_pattern}\",    // #{entry.comment}"
        end
      end
      patterns
    end
    
  end
  
end

