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

#import "UIView+Mask.h"

@interface __MaskView : VCSolidView

- (id)initForView:(UIView *)view andColor:(UIColor *) color;

- (void) tapped;

@property (nonatomic,copy) BOOL (^onTapped)();

@end


@implementation UIView (Mask)

- (void) addMaskWithOpacity:(CGFloat) opacity onTapped:(BOOL (^)()) onTapped
{
    UIColor *color = [UIColor colorWithWhite:1.0f alpha:opacity];
    
    __MaskView *maskView = [[__MaskView alloc] initForView:self andColor:color];
    
    maskView.onTapped = onTapped;
    maskView.tag = 98372523;
    
    [self addSubview:maskView];
}

- (void) addDarkMaskWithOpacity:(CGFloat) opacity onTapped:(BOOL (^)()) onTapped
{
    UIColor *color = [UIColor colorWithWhite:0.0f alpha:opacity];
    
    __MaskView *maskView = [[__MaskView alloc] initForView:self andColor:color];
    
    maskView.onTapped = onTapped;
    maskView.tag = 98372523;
    
    [self addSubview:maskView];
}

- (void) removeMask
{
    [[self viewWithTag:98372523] removeFromSuperview];
}

@end

@implementation __MaskView

- (id)initForView:(UIView *)view andColor:(UIColor *) color
{
    self = [super initWithFrame:view.bounds andColor:color andSizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];

    [self addTapGestureRecognizerWithTarget:self andAction:@selector(tapped)];

    return self;
}


- (void) tapped
{
    BOOL removeSelf = NO;
    
    if (self.onTapped)
        removeSelf = self.onTapped();

    if (removeSelf)
        [self removeFromSuperview];

    self.onTapped = nil;
}


@end
