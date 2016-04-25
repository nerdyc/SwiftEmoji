# Swift Emoji

`SwiftEmoji` provides a set of regular expressions to find emoji in swift strings. All forms of emoji are matched, including:

* Single-character emoji (👍)
* Emoji that are variants of other characters (e.g. ⌚️ instead of ⌚︎)
* Fitzpatrick Modifiers (e.g. skintones 👍🏻👍🏼👍🏽👍🏾👍🏿)
* ZWJ Sequences (e.g. 💑)
* Combining sequences (e.g. 0️⃣)
* Flag sequences (e.g 🇨🇦)

All emoji are derived directly from the standard unicode data files, using an automated script.

## Usage

The `Emoji` class exposes a number of useful regular expressions as static variables. They each come
in compiled (`NSRegularExpression`) and uncompiled (`String`) forms.

The `String` values are useful when composing your own expressions. For example, the default expressions do not create any capture groups, to avoid the performance overhead.

Look at the source code in `Emoji.swift` for an example.

## License

Squeal is released under the MIT License. Details are in the `LICENSE.txt` file in the project.