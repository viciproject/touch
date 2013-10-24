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

#import <QuartzCore/QuartzCore.h>

#import "VCSpinnerBox.h"

@interface VCSpinnerBox()
{
    
}

@property (strong) UIView *boxView;

@end

@implementation VCSpinnerBox

- (id) initForView:(UIView *)view
{
    self = [super init];
    
    if (self)
    {
        [self createView:view];
    }
    
    return self;
}

- (id) init
{
    self = [super init];
    
    if (self)
    {
        [self createView:[UIApplication sharedApplication].keyWindow];
    }
    
    return self;
}

- (void) createView:(UIView *)view
{
    [VCUtil dispatchUI:^{

        CGRect bounds = view.bounds;

        UIView *maskView = [[VCSolidView alloc] initWithFrame:bounds andColor:[UIColor clearColor]];

        maskView.userInteractionEnabled = YES;
        
        [view addSubview:maskView];
        
        int w = 100;
        int h = 100;
        
        CGRect frame = CGRectMake(bounds.size.width/2 - w/2 , bounds.size.height/2 - h/2 , w, h);
        
        UIView *boxView = [[UIView alloc] initWithFrame:frame];
        
        boxView.layer.cornerRadius = 10.0f;
        boxView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
        
        [maskView addSubview:boxView];
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        spinner.frame = CGRectMake(25, 25, 50, 50);
        spinner.hidesWhenStopped = YES;
        
        [boxView addSubview:spinner];
        
        [spinner startAnimating];
        
        self.boxView = maskView;
        
    }];
}

- (void) hide
{
    [VCUtil dispatchUI:^{ [self.boxView removeFromSuperview]; }];
}

@end
