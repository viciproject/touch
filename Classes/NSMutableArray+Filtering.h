#import <Foundation/Foundation.h>

@interface NSMutableArray (Filtering)

- (void) removeObjectsMatching:(BOOL (^) (id)) filter;

@end
