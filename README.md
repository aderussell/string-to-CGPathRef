A category for UIBezierPath that add methods which will create a path for a specified NSAttributedString.
For use with iOS 6 and later.

## Installing the project
`pod 'ARCGPathFromString'`



## Creating a path from an NSString
You can create paths for single line NSStrings by specifying the font to use.

`+ (UIBezierPath *)pathForString:(NSString *)string withFont:(UIFont *)font`


The multi line method also requires the text alignment (can be left, right, center, or justified) and a maximum width for each line of text.

`+ (UIBezierPath *)pathForMultilineString:(NSString *)string withFont:(UIFont *)font maxWidth:(CGFloat)maxWidth textAlignment:(NSTextAlignment)alignment`



## Creating a path from an NSAttributedString
You can also create paths for single line NSAttributedStrings

`+ (UIBezierPath *)pathForAttributedString:(NSAttributedString *)string`

The multi line method also requires a maximum width for each line of text.

`+ (UIBezierPath *)pathForMultilineAttributedString:(NSAttributedString *)string maxWidth:(CGFloat)maxWidth`



## License
ARCGPathFromString is available under the MIT license. See the LICENSE file for more info.
