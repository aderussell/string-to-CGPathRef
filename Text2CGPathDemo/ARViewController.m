//
//  ARViewController.m
//  Text2CGPathDemo
//
//  Created by Adrian Russell on 12/4/12.
//  Copyright (c) 2012 Adrian Russell. All rights reserved.
//

#import "ARViewController.h"
#import "UIBezierPath+TextPaths.h"
#import <QuartzCore/QuartzCore.h>

//-----------------------------------------------------
#pragma mark - Constants

#define SINGLE_LINE_STRING            @"Single line path."
#define MULTI_LINE_STRING             @"Multi-line string that doesn't have a newline character so is automatically lined to fit width."
#define MULTI_LINE_STRING_LINE_BREAKS @"Multi-line string\nwith '\\n' characters\nto\nforce\nnew line."



static NSString *const kFonts[4]     = { @"Helvetica-Bold", @"AmericanTypewriter-CondensedLight", @"MarkerFelt-Thin", @"TimesNewRomanPS-ItalicMT" };
static CGFloat         kFontsizes[4] = { 30.0, 60.0, 50.0, 40.0};


//-----------------------------------------------------
#pragma mark - Class implementation

@implementation ARViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.78 green:0.90 blue:0.91 alpha:1.0];
	// Do any additional setup after loading the view, typically from a nib.
}

- (NSAttributedString *)attributedStringForString:(NSString *)string
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    
    for (NSUInteger i = 0; i < string.length; i++) {
        NSUInteger option = (i % 4);
        UIFont *font = [UIFont fontWithName:kFonts[option] size:kFontsizes[option]];
        [attString addAttribute:NSFontAttributeName value:font range:NSMakeRange(i, 1)];
    }
    
    return [attString copy];
}


- (CAShapeLayer *)singleLinePathStandard
{
    CAShapeLayer *line1 = [CAShapeLayer new];
    line1.path = [UIBezierPath pathFromString:SINGLE_LINE_STRING WithFont:[UIFont boldSystemFontOfSize:60.0]].CGPath;
    line1.bounds = CGPathGetBoundingBox(line1.path);
    line1.geometryFlipped = YES;
    line1.fillColor = [UIColor whiteColor].CGColor;
    line1.strokeColor = [UIColor blackColor].CGColor;
    line1.lineWidth = 1.0;
    
    return line1;
}

- (CAShapeLayer *)singleLinePathAttributed
{
    NSAttributedString *attString = [self attributedStringForString:SINGLE_LINE_STRING];
    
    CAShapeLayer *line1 = [CAShapeLayer new];
    line1.path = [UIBezierPath pathFromAttributedString:attString].CGPath;
    line1.bounds = CGPathGetBoundingBox(line1.path);
    line1.geometryFlipped = YES;
    line1.fillColor = [UIColor whiteColor].CGColor;
    line1.strokeColor = [UIColor blackColor].CGColor;
    line1.lineWidth = 1.0;
    
    return line1;
}

- (CAShapeLayer *)multiLinePathAttributed
{
    NSAttributedString *attrString2 = [self attributedStringForString:MULTI_LINE_STRING];
    CAShapeLayer *line2 = [CAShapeLayer new];
    line2.path = [UIBezierPath pathFromMultilineAttributedString:attrString2 maxWidth:self.view.bounds.size.width - 100].CGPath;
    line2.bounds = CGPathGetBoundingBox(line2.path);
    line2.geometryFlipped = YES;
    line2.fillColor = [UIColor whiteColor].CGColor;
    line2.strokeColor = [UIColor blackColor].CGColor;
    line2.lineWidth = 1.0;
    
    return line2;
}

- (CAShapeLayer *)multiLinePathStandardLineBreaks
{
    CAShapeLayer *line3 = [CAShapeLayer new];
    line3.path = [UIBezierPath pathFromMultilineString:MULTI_LINE_STRING_LINE_BREAKS WithFont:[UIFont boldSystemFontOfSize:40.0] maxWidth:self.view.bounds.size.width - 100].CGPath;
    line3.bounds = CGPathGetBoundingBox(line3.path);
    line3.geometryFlipped = YES;
    line3.fillColor = [UIColor whiteColor].CGColor;
    line3.strokeColor = [UIColor blackColor].CGColor;
    line3.lineWidth = 1.0;
    
    return line3;
}


//-------------------------------------------------------------------------------

- (void)viewDidAppear:(BOOL)animated
{
    // load single with standard string
    CAShapeLayer *line1 = [self singleLinePathStandard];
    line1.position = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height * 0.10);
    [self.view.layer addSublayer:line1];
    
    // load single with attributed string
    CAShapeLayer *line2 = [self singleLinePathAttributed];
    line2.position = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height * 0.25);
    [self.view.layer addSublayer:line2];

    // load multi with attributed string
    CAShapeLayer *line3 = [self multiLinePathAttributed];
    line3.position = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height * 0.5);
    [self.view.layer addSublayer:line3];
    
    // load multi with '\n'
    CAShapeLayer *line4 = [self multiLinePathStandardLineBreaks];
    line4.position = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height * 0.80);
    [self.view.layer addSublayer:line4];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
