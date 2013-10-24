//=============================================================================
// Vici Touch - Productivity Library for Objective C / iOS SDK
//
// Copyright (c) 2010-2013 Philippe Leybaert
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//=============================================================================

#import "VCButton.h"
#import <QuartzCore/QuartzCore.h>

@interface VCButton()
{
    CAGradientLayer *shineLayer;
}

@end

@implementation VCButton

- (void)initBorder
{
    CALayer *layer = self.layer;

    UIColor *baseColor = self.backgroundColor;
    
    CGFloat hue,saturation,brightness,alpha;
    
    [baseColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

    brightness = brightness * 1.05f;
    
    layer.cornerRadius = 1.0f;
    layer.masksToBounds = NO;
    layer.borderWidth = 1.0f;
    layer.borderColor = [UIColor colorWithHue:hue
                                   saturation:saturation
                                   brightness:brightness
                                        alpha:1.0f].CGColor;
    
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowRadius = 0.5f;
    layer.shadowOpacity = 0.7f;
    layer.shadowOffset = CGSizeMake(0,0);
}

- (void)addShineLayer
{
    [shineLayer removeFromSuperlayer];
    
    shineLayer = [CAGradientLayer layer];
    
    shineLayer.frame = self.layer.bounds;
    
    UIColor *baseColor = self.backgroundColor;

    CGFloat hue,saturation,brightness,alpha;
    
    [baseColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    shineLayer.colors = [NSArray arrayWithObjects:
                         (id) [UIColor colorWithHue:hue saturation:saturation brightness:brightness*72.0/81 alpha:1.0f].CGColor,
                         (id) [UIColor colorWithHue:hue saturation:saturation brightness:brightness*72.8/81 alpha:1.0f].CGColor,
                         (id) [UIColor colorWithHue:hue saturation:saturation brightness:brightness*74.5/81 alpha:1.0f].CGColor,
                         (id) [UIColor colorWithHue:hue saturation:saturation brightness:brightness*77.5/81 alpha:1.0f].CGColor,
                         (id) [UIColor colorWithHue:hue saturation:saturation brightness:brightness*79.0/81 alpha:1.0f].CGColor,
                         (id) [UIColor colorWithHue:hue saturation:saturation brightness:brightness*80.0/81 alpha:1.0f].CGColor,
                         (id) [UIColor colorWithHue:hue saturation:saturation brightness:brightness*80.7/81 alpha:1.0f].CGColor,
                         (id) [UIColor colorWithHue:hue saturation:saturation brightness:brightness*81.0/81 alpha:1.0f].CGColor,
                         nil
                         ];
    
    shineLayer.locations = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:0.0f/7],
                            [NSNumber numberWithFloat:1.0f/7],
                            [NSNumber numberWithFloat:2.0f/7],
                            [NSNumber numberWithFloat:3.0f/7],
                            [NSNumber numberWithFloat:4.0f/7],
                            [NSNumber numberWithFloat:5.0f/7],
                            [NSNumber numberWithFloat:6.0f/7],
                            [NSNumber numberWithFloat:7.0f/7],
                            nil];
    
    
    shineLayer.startPoint = CGPointMake(0.2f, 0.0f);
    shineLayer.endPoint = CGPointMake(0.8f, 1.0f);

    shineLayer.cornerRadius = 1.0f;
    shineLayer.masksToBounds = NO;
    
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    [self.layer addSublayer:shineLayer];


    [self bringSubviewToFront:self.titleLabel];
}

- (void)initLayers
{
    //self.titleLabel.textColor = [UIColor whiteColor];
    
    [self initBorder];
    [self addShineLayer];
    //[self addHighlightLayer];
    
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.shadowOffset = CGSizeMake(0.5,0.5);
}

- (void) setColor:(UIColor *)backgroundColor
{
    self.backgroundColor = backgroundColor;
    
    [self initLayers];
}

- (void)awakeFromNib
{
    [self initLayers];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
        
        [self initLayers];
    }
    
    return self;
}

@end