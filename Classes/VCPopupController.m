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

#import "VCPopupController.h"

@interface VCPopupController ()
{
    CGRect _frame;
    CGPoint _startingPoint;
    CGPoint _centerPoint;
    
    UIView * _maskView;
}

- (void) animateLaunch;

@end

@implementation VCPopupController

- (id)initWithFrame:(CGRect) frame andStartingPoint:(CGPoint) startingPoint
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self)
    {
        _frame = frame;
        _startingPoint = startingPoint;
        
        self.maskColor = [UIColor clearColor];
        self.masked = YES;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect) frame
{
    self = [self initWithFrame:frame andStartingPoint:CGPointMake(CGRectGetMidX(frame),CGRectGetMidY(frame))];
    
    return self;
}

- (void) loadView
{
    UIView *view = [[UIView alloc] initWithFrame:_frame];
    
    self.view = view;
}

- (void) presentFrom:(UIViewController *)parentController
{
    [parentController addChildViewController:self];
    
    [self didMoveToParentViewController:parentController];
    
    self.view.frame = _frame;
   
    _centerPoint = self.view.center;
    
    self.view.center = _startingPoint;
    self.view.transform = CGAffineTransformMakeScale(0.0, 0.0);
    
    if (self.masked)
    {
//        UIView *rootView = [UIApplication sharedApplication].keyWindow;
        UIView *rootView = parentController.view;
        
        CGRect maskBounds = rootView.bounds;
        
        _maskView = [[UIView alloc] initWithFrame:maskBounds];
    
        _maskView.backgroundColor = self.maskColor;
        _maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _maskView.userInteractionEnabled = YES;

        if (self.tapOutsideToDismiss)
            [_maskView addTapGestureRecognizerWithTarget:self andAction:@selector(dismiss)];
    
        [rootView addSubview:_maskView];
    }
    
    [parentController.view addSubview:self.view];
    
    [self animateLaunch];
}

- (void) viewWasFullyPresented
{
    
}

- (void) animateLaunch
{
    UIView *view = self.view;
    
    [UIView animateWithDuration:0.20
                     animations:^{
                         view.transform = CGAffineTransformMakeScale(1.00, 1.00);
                         view.center = _centerPoint;
                     }
                     completion:^(BOOL finished) {
                         [self viewWasFullyPresented];

                         /*
                         [UIView animateWithDuration:0.05f
                                          animations:^{
                                              self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                          }
                                          completion:^(BOOL finished) {
                                              [self viewWasFullyPresented];
                                          }];
                          */
                     }
     ];
}

- (void) dismiss
{
    [self.view removeFromSuperview];
    [_maskView removeFromSuperview];
    
    _maskView = nil;
    
    [self removeFromParentViewController];
    
    if (self.onDismissed)
        self.onDismissed();
}


@end
