#import "UIView+Positioning.h"


@implementation UIView (Positioning)

- (void) setXTo:(float)x
{
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}

- (void) setYTo:(float)y
{
    CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}

- (void) setXTo:(float)x andYTo:(float)y
{
    [self setXTo:x];
    [self setYTo:y];
}

@end
