#import "UIView+Resizing.h"


@implementation UIView (Resizing)

- (void) setWidthTo:(float)width
{
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (void) setHeightTo:(float)height
{
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (void) setWidthTo:(float)width andHeightTo:(float)height
{
    [self setWidthTo:width];
    [self setHeightTo:height];
}

@end
