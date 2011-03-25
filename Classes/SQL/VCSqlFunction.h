#include <sqlite3.h>

#import <Foundation/Foundation.h>

@interface VCSqlFunction : NSObject 
{
	NSString * _name;
	int _numArguments;
	void (*_function)(sqlite3_context *arg1,int arg2, sqlite3_value **arg3);
}

@property (nonatomic,readonly) NSString *name;
@property (nonatomic,readonly) void (*function)(sqlite3_context *arg1,int arg2, sqlite3_value **arg3);
@property (nonatomic,readonly) int numArguments;

+ (VCSqlFunction *) functionWithName:(NSString *) name function:(void (*)(sqlite3_context *arg1,int arg2, sqlite3_value **arg3))function numArguments:(int) numArguments;

@end
