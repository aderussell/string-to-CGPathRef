An Objective-C category for UIBezierPath that creates paths from strings.

## Using the project
For use with iOS 6 and later.


## Path from NSString
You can create paths for single line NSStrings by specifying the font to use.

`+ (UIBezierPath *)pathForString:(NSString *)string  withFont:(UIFont *)font`


The multi line method also requires the text alignment (can be left, right, center, or justified) and a maximum width for each line of text.

`+ (UIBezierPath *)pathForMultilineString:(NSString *)string withFont:(UIFont *)font  maxWidth:(CGFloat)maxWidth textAlignment:(NSTextAlignment)alignment`



## Path from NSAttributedString
You can also create paths for single line NSAttributedStrings

`+ (UIBezierPath *)pathForAttributedString:(NSAttributedString *)string`

The multi line method also requires a maximum width for each line of text.

`+ (UIBezierPath *)pathForMultilineAttributedString:(NSAttributedString *)string maxWidth:(CGFloat)maxWidth`


## Changes as of 8/8/2014
This version has created a number of changes to the previous commit that make it incompatible as a dropin replacment for older versions.
* All the method names have been changed to make them clearer.
* The CoreText internals have been seperated from the UIBezierPath category, this means that OS X can now use the CoreText methods (that return CGPathRef).
* The multiline methods now support justified text alignment. (Note that doesn't suport Natural aligment; that will be left aligned).
* 

## License
ARCGPathFromString is available under the MIT license. See the LICENSE file for more info.
