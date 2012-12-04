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

@interface ARViewController ()

@end

@implementation ARViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.78 green:0.90 blue:0.91 alpha:1.0];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    // load single
    CAShapeLayer *line1 = [CAShapeLayer new];
    line1.path = [UIBezierPath pathFromString:@"Single line path." WithFont:[UIFont boldSystemFontOfSize:60.0]].CGPath;
    line1.bounds = CGPathGetBoundingBox(line1.path);
    line1.geometryFlipped = YES;
    line1.fillColor = [UIColor whiteColor].CGColor;
    line1.strokeColor = [UIColor blackColor].CGColor;
    line1.lineWidth = 3.0;
    line1.position = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height * 0.25);
    [self.view.layer addSublayer:line1];

    
    // load multi
    CAShapeLayer *line2 = [CAShapeLayer new];
    line2.path = [UIBezierPath pathFromMultilineString:@"Multi-line string that doesn't have a newline character so is automatically lined to fit width." WithFont:[UIFont boldSystemFontOfSize:40.0] maxWidth:self.view.bounds.size.width - 100].CGPath;
    line2.bounds = CGPathGetBoundingBox(line2.path);
    line2.geometryFlipped = YES;
    line2.fillColor = [UIColor whiteColor].CGColor;
    line2.strokeColor = [UIColor blackColor].CGColor;
    line2.lineWidth = 2.0;
    line2.position = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height * 0.5);
    [self.view.layer addSublayer:line2];
    
    // load multi with '\n'
    CAShapeLayer *line3 = [CAShapeLayer new];
    line3.path = [UIBezierPath pathFromMultilineString:@"Multi-line string\nwith '\\n' characters\nto\nforce\nnew line." WithFont:[UIFont boldSystemFontOfSize:40.0] maxWidth:self.view.bounds.size.width - 100].CGPath;
    line3.bounds = CGPathGetBoundingBox(line3.path);
    line3.geometryFlipped = YES;
    line3.fillColor = [UIColor whiteColor].CGColor;
    line3.strokeColor = [UIColor blackColor].CGColor;
    line3.lineWidth = 2.0;
    line3.position = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height * 0.75);
    [self.view.layer addSublayer:line3];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
