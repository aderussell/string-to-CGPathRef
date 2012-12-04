//
//  UIBezierPath+TextPaths.h
//  orientation test
//
//  Created by Adrian Russell on 11/10/2012.
//  Copyright (c) 2012 Adrian Russell. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIBezierPath (TextPaths)

+ (UIBezierPath *)pathFromString:(NSString *)string WithFont:(UIFont *)font;

+ (UIBezierPath *)pathFromMultilineString:(NSString *)string WithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;

@end
