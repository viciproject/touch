//=============================================================================
// Vici Touch - Productivity Library for Objective C / iOS SDK 
//
// Copyright (c) 2010-2011 Philippe Leybaert
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

#import "VCLazyScrollView.h"

@interface VCLazyScrollView()

- (BOOL) isSubViewVisible:(int)index;
- (UIView *) buildSubView:(int)index;
- (void) updateVisibleViews;
- (int) calculateCurrentIndex;

@end

@implementation VCLazyScrollView

@synthesize currentIndex = _currentIndex;
@synthesize visibleViews = _visibleViews;

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{
        _visibleViews = [[NSMutableSet alloc] init];
		_recycledViews = [[NSMutableSet alloc] init];
		
		super.delegate = self;
    }
	
    return self;
}

- (id<VCLazyScrollViewDelegate>) delegate 
{
	return _lazyScrollDelegate;
}

- (void) setDelegate:(id<VCLazyScrollViewDelegate>)delegate 
{
	//super.delegate = delegate;
	
	_lazyScrollDelegate = delegate;
}

- (void) setCurrentIndex:(int)index 
{
	BOOL changed = NO;
	
	if (_currentIndex != index) 
		changed = YES;
	
	_currentIndex = index;
	
	if (changed)
	{
		if ([self.delegate respondsToSelector:@selector(lazyScrollView:currentIndexChanged:)])
			[self.delegate lazyScrollView:self currentIndexChanged:index];
	
		[self updateVisibleViews];
	}
}

- (void) setCurrentIndex:(int)index animated:(BOOL)animated 
{
	[self setContentOffset:CGPointMake(index * self.bounds.size.width, 0) animated:animated];
	
	if (!animated)
		[self setCurrentIndex:index];
}

- (int) calculateCurrentIndex {
	
	CGFloat index = self.contentOffset.x / self.bounds.size.width;
	
	return (int) (index + 0.5);
}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView 
{
	int currentItem = [self calculateCurrentIndex];
	
	[self setCurrentIndex:currentItem];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
	int currentItem = [self calculateCurrentIndex];
	
	[self setCurrentIndex:currentItem];
}

/*
- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
	int currentItem = [self calculateCurrentIndex];

	[self setCurrentIndex:currentItem];
}
 */

- (void) updateVisibleViews 
{
	int numItems = [self.delegate lazyScrollViewItemCount:self];
	
	int first = _currentIndex-1;
	int last = _currentIndex+1;
	
	if (first < 0)
		first = 0;
	
	if (last >= numItems)
		last = numItems-1;
	
	for (UIView *view in _visibleViews) 
	{
		if (view.tag < first || view.tag > last) 
		{
			if ([self.delegate respondsToSelector:@selector(lazyScrollView:subViewWillRecycle:forIndex:)])
				[self.delegate lazyScrollView:self subViewWillRecycle:view forIndex:view.tag];
			
			[view removeFromSuperview];
			[_recycledViews addObject:view];
		}
	}
	
	[_visibleViews minusSet:_recycledViews];
	
	for (int i=first;i<=last;i++) 
	{
		if (![self isSubViewVisible:i]) 
		{
			UIView *view = [self buildSubView:i];
			
			[self addSubview:view];
			
			[_visibleViews addObject:view];
		}
	}

	self.contentSize = CGSizeMake(numItems * self.bounds.size.width, self.bounds.size.height);
}

- (void) forceLayout 
{
	_prevBounds = CGSizeZero;
	
	[self setNeedsLayout];
}

- (void) reloadData 
{
	[self updateVisibleViews];
	
	[self forceLayout];
}

- (void) layoutSubviews 
{
	CGSize size = self.bounds.size;
	
	if (CGSizeEqualToSize(size, _prevBounds))
		return;
	
	_prevBounds = size;
	
	for (UIView *view in _visibleViews) 
	{
		view.frame = CGRectMake(view.tag * size.width , 0, size.width, size.height);
	}
	
	self.contentSize = CGSizeMake([self.delegate lazyScrollViewItemCount:self] * size.width, size.height);
	self.contentOffset = CGPointMake(_currentIndex * size.width, 0);
}

- (UIView *) buildSubView:(int)index 
{
	CGSize size = self.bounds.size;
	
	UIView *view = [_recycledViews anyObject];
	
	if (view) 
	{
		[view retain];
		[_recycledViews removeObject:view];
		[view autorelease];
	}

	CGRect frame = CGRectMake(index*size.width, 0, size.width, size.height);

	view = [self.delegate lazyScrollView:self setupSubView:view withFrame:frame forIndex:index];

	view.tag = index;
	view.frame = frame;
	
	return view;
}
			 
- (BOOL) isSubViewVisible:(int)index 
{
	for (UIView *view in _visibleViews) 
		if (view.tag == index)
			return YES;
	
	return NO;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	if (!self.dragging) 
		[self.nextResponder touchesEnded: touches withEvent:event]; 
	
	[super touchesEnded: touches withEvent: event];
}

- (void) dealloc 
{
	[_visibleViews release];
	[_recycledViews release];
	
    [super dealloc];
}

@end
