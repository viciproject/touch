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

#import "VCToast.h"

@implementation VCToast

+ (void) showText:(NSString *)text duration:(NSTimeInterval) duration backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize
{
    UIView *parentView = [UIApplication sharedApplication].keyWindow;
    
    CGSize bounds = parentView.bounds.size;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, bounds.height-50, bounds.width, 50)];
    
    view.backgroundColor = backgroundColor;

    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont boldSystemFontOfSize:fontSize];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = textColor;
    label.text = text;
    
    [view addSubview:label];

    CGRect frame = view.frame;
    
	frame.origin.y = bounds.height;
    
    view.frame = frame;

	[UIView animateWithDuration:1.0 animations:^
        {
            CGRect f = frame;
            
            f.origin.y = bounds.height-frame.size.height;
            
            view.frame = f;
        }
     ];
    
    [parentView addSubview:view];
    
	[self performSelector:@selector(hide:) withObject:view afterDelay:duration];
}

+ (void) hide:(UIView *) view
{
    [UIView animateWithDuration:1.0
                     animations:^
                        {
                            CGRect f = view.frame;
        
                            f.origin.y = view.superview.bounds.size.height;
        
                            view.frame = f;
                        }
                     completion:^(BOOL done)
                        {
                            [view removeFromSuperview];
                        }
     ];
}


@end
