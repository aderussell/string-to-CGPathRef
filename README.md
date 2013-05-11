
An Objective-C category for UIBezierPath that creates paths from strings.

for use with iOS 6 and later.


+ (UIBezierPath *)pathFromString:(NSString *)string WithFont:(UIFont *)font;

// centered as default
+ (UIBezierPath *)pathFromMultilineString:(NSString *)string WithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;

+ (UIBezierPath *)pathFromMultilineString:(NSString *)string WithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth textAlignment:(NSTextAlignment)alignment;


// NSAttributedString

+ (UIBezierPath *)pathFromAttributedString:(NSAttributedString *)string;

+ (UIBezierPath *)pathFromMultilineAttributedString:(NSAttributedString *)string maxWidth:(CGFloat)maxWidth;
