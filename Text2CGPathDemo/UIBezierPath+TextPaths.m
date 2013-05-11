//
//  UIBezierPath+TextPaths.m
//  orientation test
//
//  Created by Adrian Russell on 11/10/2012.
//  Copyright (c) 2012 Adrian Russell. All rights reserved.
//

#import "UIBezierPath+TextPaths.h"
#import <CoreText/CoreText.h>



#define MAX_HEIGHT_OF_FRAME 2048    //for the multiline the CTFrame must have a max path size so this is arbitrary. currently 2x the height of ipad screen.

// single line
CGPathRef CGPathCreateSingleLineStringWithAttributedString(NSAttributedString *attrString);

// multi line
CGPathRef CGPathCreateMultilineStringWithAttributedString(NSAttributedString *attrString, CGFloat maxWidth);


@implementation UIBezierPath (TextPaths)

//------------------------------------------------------------------------
#pragma mark - NSString


+ (UIBezierPath *)pathFromString:(NSString *)string WithFont:(UIFont *)font
{
    return [self pathFromString:string WithFont:font textAlignment:NSTextAlignmentCenter];
}

+ (UIBezierPath *)pathFromMultilineString:(NSString *)string WithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    return [self pathFromMultilineString:string WithFont:font maxWidth:maxWidth textAlignment:NSTextAlignmentCenter];
}

// technically pointless becuase a path is on a single line and the path will be as wide as the string so there is no alignment.
+ (UIBezierPath *)pathFromString:(NSString *)string WithFont:(UIFont *)font textAlignment:(NSTextAlignment)alignment
{
    NSAssert(string, @"string MUST NOT be nil");
    NSAssert(font,   @"font MUST NOT be nil");
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = alignment;
    NSDictionary *attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle };

    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attributes];
    
    CGPathRef letters = CGPathCreateSingleLineStringWithAttributedString(attrString);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    
    CGPathRelease(letters);
    
    return path;
}

+ (UIBezierPath *)pathFromMultilineString:(NSString *)string WithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth textAlignment:(NSTextAlignment)alignment
{
    NSAssert(string, @"string MUST NOT be nil");
    NSAssert(font,   @"font MUST NOT be nil");
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = alignment;
    
    NSDictionary *attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle };
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attributes];
    
    CGPathRef letters = CGPathCreateMultilineStringWithAttributedString(attrString, maxWidth);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    
    CGPathRelease(letters);
    
    return path;
}


//------------------------------------------------------------------------
#pragma mark - NSAttributedString

+ (UIBezierPath *)pathFromMultilineAttributedString:(NSAttributedString *)string maxWidth:(CGFloat)maxWidth
{
    NSAssert(string,         @"string MUST NOT be nil");
    NSAssert(maxWidth > 0.0, @"maxWidth must be greater than 0.0");
    
    CGPathRef letters = CGPathCreateMultilineStringWithAttributedString(string, maxWidth);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    
    CGPathRelease(letters);
    
    return path;
}

+ (UIBezierPath *)pathFromAttributedString:(NSAttributedString *)string
{
    NSAssert(string, @"string MUST NOT be nil");
    
    CGPathRef letters = CGPathCreateSingleLineStringWithAttributedString(string);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    
    CGPathRelease(letters);
    
    return path;
}


//--------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Cross Platform foundation style functions


CGPathRef CGPathCreateSingleLineStringWithAttributedString(NSAttributedString *attrString)
{
    CGMutablePathRef letters = CGPathCreateMutable();
    
    //NSDictionary *attrs = @{ (id)kCTFontAttributeName : (__bridge id)fontRef };
    //NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attrs];
    
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    // for each RUN
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        // Get FONT for this run
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        // for each GLYPH in run
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            // get Glyph & Glyph-data
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            // Get PATH of outline
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(letters, &t, letter);
                CGPathRelease(letter);
            }
        }
    }
    
    CFRelease(line);
    
    CGPathRef finalPath = CGPathCreateCopy(letters);
    CGPathRelease(letters);
    return finalPath;
}


//-------------------------------------------------------------------------------------


CGPathRef CGPathCreateMultilineStringWithAttributedString(NSAttributedString *attrString, CGFloat maxWidth)
{
    
    CGMutablePathRef letters = CGPathCreateMutable();
    
    CGRect bounds = CGRectMake(0, 0, maxWidth, MAX_HEIGHT_OF_FRAME);
    
    CGPathRef pathRef = CGPathCreateWithRect(bounds, NULL);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(attrString));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), pathRef, NULL);
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    CGPoint *points = malloc(sizeof(CGPoint) * CFArrayGetCount(lines));
    
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), points);
    
    // for each LINE
    for (CFIndex lineIndex = 0; lineIndex < CFArrayGetCount(lines); lineIndex++)
    {
        CTLineRef lineRef = CFArrayGetValueAtIndex(lines, lineIndex);
        
        CFRange r = CTLineGetStringRange(lineRef);
        
        NSParagraphStyle *paragraphStyle = [attrString attribute:NSParagraphStyleAttributeName atIndex:r.location effectiveRange:NULL];
        NSTextAlignment alignment = paragraphStyle.alignment;
        
        
        CGFloat flushFactor = 0.0;
        if (alignment == NSTextAlignmentLeft) {
            flushFactor = 0.0;
        } else if (alignment == NSTextAlignmentCenter) {
            flushFactor = 0.5;
        } else if (alignment == NSTextAlignmentRight) {
            flushFactor = 1.0;
        }
        
        
        //CTLineGet
        
        CFArrayRef runArray = CTLineGetGlyphRuns(lineRef);
        
        
        
        
        
        CGFloat lineOffset =  MAX_HEIGHT_OF_FRAME - points[lineIndex].y;
        
        
        CGFloat penOffset = CTLineGetPenOffsetForFlush(lineRef, flushFactor, maxWidth);
        
        // for each RUN
        for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
        {
            // Get FONT for this run
            CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
            CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
            
            // for each GLYPH in run
            for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
            {
                // get Glyph & Glyph-data
                CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
                CGGlyph glyph;
                CGPoint position;
                CTRunGetGlyphs(run, thisGlyphRange, &glyph);
                CTRunGetPositions(run, thisGlyphRange, &position);
                
                position.y -= lineOffset;
                position.x += penOffset;
                
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(letters, &t, letter);
                CGPathRelease(letter);
            }
        }
    }
    
    free(points);
    
    CGPathRelease(pathRef);
    CFRelease(frame);
    CFRelease(framesetter);
    
    CGPathRef finalPath = CGPathCreateCopy(letters);
    CGPathRelease(letters);
    return finalPath;
}


@end
