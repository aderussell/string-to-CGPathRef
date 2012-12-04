//
//  UIBezierPath+TextPaths.m
//  orientation test
//
//  Created by Adrian Russell on 11/10/2012.
//  Copyright (c) 2012 Adrian Russell. All rights reserved.
//

#import "UIBezierPath+TextPaths.h"
#import <CoreText/CoreText.h>


#define MAX_HEIGHT_OF_FRAME 2048    //for the multiline the CTFrame must have a max path size so this is arbitrary. currently height of retina ipad screen.

#define ALIGN_FLUSH 0.5 // currently aligned to center text

CGPathRef CGPathCreateSingleLineString(NSString *string, CTFontRef fontRef);
CGPathRef CGPathCreateMultilineString(NSString *string, CTFontRef fontRef, CGFloat maxWidth);

@implementation UIBezierPath (TextPaths)

+ (UIBezierPath *)pathFromString:(NSString *)string WithFont:(UIFont *)font
{
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
   
    CGPathRef letters = CGPathCreateSingleLineString(string, fontRef);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    
    CGPathRelease(letters);
    CFRelease(fontRef);
    
    return path;
}

+ (UIBezierPath *)pathFromMultilineString:(NSString *)string WithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    
    // create the CGPath for all of the letters
    CGPathRef letters = CGPathCreateMultilineString(string, fontRef, maxWidth);

    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];

    CGPathRelease(letters);
    CFRelease(fontRef);
    
    
    return path;
}

//--------------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Cross Platform foundation style functions

CGPathRef CGPathCreateSingleLineString(NSString *string, CTFontRef fontRef)
{
    CGMutablePathRef letters = CGPathCreateMutable();
    
    NSDictionary *attrs = @{ (id)kCTFontAttributeName : (__bridge id)fontRef };
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attrs];
    
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



CGPathRef CGPathCreateMultilineString(NSString *string, CTFontRef fontRef, CGFloat maxWidth)
{
    CGMutablePathRef letters = CGPathCreateMutable();
    
    NSDictionary *attrs = @{ (id)kCTFontAttributeName : (__bridge id)fontRef };
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attrs];
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGRect bounds = CGRectMake(0, 0, maxWidth, MAX_HEIGHT_OF_FRAME);
    CGPathAddRect(pathRef, NULL, bounds);
    
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(attrString));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), pathRef, NULL);
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    CGPoint *points = malloc(sizeof(CGPoint) * CFArrayGetCount(lines));
    
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), points);
    
    // for each LINE
    for (CFIndex lineIndex = 0; lineIndex < CFArrayGetCount(lines); lineIndex++)
    {
        CTLineRef lineRef = CFArrayGetValueAtIndex(lines, lineIndex);
        
        CFArrayRef runArray = CTLineGetGlyphRuns(lineRef);
        
        CGFloat lineOffset =  MAX_HEIGHT_OF_FRAME - points[lineIndex].y;
        
        CGFloat penOffset = CTLineGetPenOffsetForFlush(lineRef, ALIGN_FLUSH, maxWidth);
        
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
