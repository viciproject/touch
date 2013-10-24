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

#import "VCCellStylerState.h"

//static char ASSOC_KEY;

@implementation VCCellStylerState

- (id) initForCell:(UITableViewCell *)cell position:(VCCellPosition) position style:(VCTableStyle *)style
{
    self = [super init];
    
    if (self)
    {
        _position = position;
        _cell = cell;
        _style = style;
        
        [cell.contentView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld context:NULL];
    }
    
    return self;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"])
    {
        UIView *contentView = (UIView *)object;
        
        CGRect originalFrame = contentView.frame;
        
        int position = _position;
        
        float shadowMargin = _style.shadowDepth;
        
        float contentView_margin = 2;
        float y = contentView_margin;
        float extraHeight = 0;
        
        switch (position) {
            case VCCellPositionTop:
                extraHeight += _style.outerMargin;
            case VCCellPositionSingle:
                y += shadowMargin;
                extraHeight += _style.outerMargin;
                break;
            case VCCellPositionBottom:
                extraHeight += _style.outerMargin;
            default:
                break;
        }
        
        float diffY = y - originalFrame.origin.y;
        
        if (diffY != 0)
        {
            CGRect rect = CGRectMake(originalFrame.origin.x+shadowMargin,
                                     originalFrame.origin.y+diffY,
                                     originalFrame.size.width - shadowMargin*2,
                                     originalFrame.size.height- contentView_margin*2 - extraHeight);
            
            contentView.frame = rect;
        }
        
    }
}

- (void) dealloc
{
    [_cell.contentView removeObserver:self forKeyPath:@"frame"];
}

@end
