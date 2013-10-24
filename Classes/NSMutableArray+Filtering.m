#import "NSMutableArray+Filtering.h"

@implementation NSMutableArray (Filtering)

- (void) removeObjectsMatching:(BOOL (^) (id)) filter
{
    int count = [self count];
    
    for (int i=count-1;i>=0;i--)
    {
        if (filter(self[i]))
        {
            [self removeObjectAtIndex:i];
        }
    }
}


@end
