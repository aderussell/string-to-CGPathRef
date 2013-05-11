//
//  UIBezierPath+TextPaths.h
//  orientation test
//
//  Created by Adrian Russell on 11/10/2012.
//  Copyright (c) 2012 Adrian Russell. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIBezierPath (TextPaths)

// NSString

+ (UIBezierPath *)pathFromString:(NSString *)string WithFont:(UIFont *)font;

// centered as default
+ (UIBezierPath *)pathFromMultilineString:(NSString *)string WithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;

+ (UIBezierPath *)pathFromMultilineString:(NSString *)string WithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth textAlignment:(NSTextAlignment)alignment;


// NSAttributedString

+ (UIBezierPath *)pathFromAttributedString:(NSAttributedString *)string;

+ (UIBezierPath *)pathFromMultilineAttributedString:(NSAttributedString *)string maxWidth:(CGFloat)maxWidth;

@end
