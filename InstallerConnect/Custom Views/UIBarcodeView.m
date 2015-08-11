//
//  UIBarcodeView.m
//  InstallerConnect
//
//  Created by Venkat Yennam on 8/4/15.
//  Copyright (c) 2015 Venkat Yennam. All rights reserved.
//

#import "UIBarcodeView.h"
 #import <Foundation/Foundation.h>

@implementation UIBarcodeView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor * whiteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    UIColor * lightGrayColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    UIColor * redColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]; // NEW
    
    CGRect paperRect = self.bounds;
    
    drawLinearGradient(context, paperRect, whiteColor.CGColor, lightGrayColor.CGColor);
    
    // START NEW
    CGRect strokeRect = CGRectInset(paperRect, 0.0, 0.0);
    CGContextSetStrokeColorWithColor(context, redColor.CGColor);
    CGContextSetLineWidth(context, 1.5);
    CGContextStrokeRect(context, strokeRect);
    // END NEW
    
}

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    // More coming...
}

@end
