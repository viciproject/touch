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


#import "VCUtil.h"
#include <sys/xattr.h>
#include <CommonCrypto/CommonDigest.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <net/if_dl.h>
#include <ifaddrs.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation VCUtil

+ (NSString *) documentsPath 
{
	NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	return [searchPaths objectAtIndex:0];
}

+ (NSString *) cachesPath
{
	NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
	
    return [searchPaths objectAtIndex:0]; 
}

+ (NSString *) mainBundlePath
{
	return [[NSBundle mainBundle] resourcePath];
}

+ (NSString *) fileInDocumentsPath:(NSString *)fileName
{
	return [[self documentsPath] stringByAppendingPathComponent:fileName];
}

+ (NSString *) fileInMainBundlePath:(NSString *)fileName
{
	return [[self mainBundlePath] stringByAppendingPathComponent:fileName];
}

+ (BOOL) fileExists:(NSString *)fileName 
{
	return [[NSFileManager defaultManager] fileExistsAtPath:fileName];
}

+ (BOOL) fileExistsInDocuments:(NSString *)fileName 
{
	return [[NSFileManager defaultManager] fileExistsAtPath:[self fileInDocumentsPath:fileName]];
}

+ (BOOL) fileExistsInMainBundle:(NSString *)fileName 
{
	return [[NSFileManager defaultManager] fileExistsAtPath:[self fileInMainBundlePath:fileName]];
}

static int networkActivityCounter = 0;

+ (void) startNetworkActivity 
{
	networkActivityCounter++;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = (networkActivityCounter > 0);
}

+ (void) endNetworkActivity 
{
	networkActivityCounter--;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = (networkActivityCounter > 0);
}

+ (void) showAlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:TT(@"alert.button.ok") otherButtonTitles:nil];
	
	[alertView show];
}

+ (BOOL) setNoBackupFlag:(NSString *)path
{
    const char* filePath = [path UTF8String];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);

    return result == 0;
}

+ (NSString *) uniqueId
{
    return [self toHex:[self sha1:[self macAddress]]];
}

+ (NSString *) uniqueIdWithKey:(NSData *)key
{
    NSMutableData *finalKey = [NSMutableData  dataWithData:[self macAddress]];
    
    [finalKey appendData:key];
    
    return [self toHex:[self sha1:finalKey]];
}

+ (NSData *) sha1:(NSData *) data
{
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    return [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
}

+ (NSString *) toHex:(NSData *)data
{
    int numBytes = [data length];
    
    NSMutableString* output = [NSMutableString stringWithCapacity:numBytes * 2];
    
    unsigned char *ptr = (unsigned char *)[data bytes];
    
    for(int i = 0; i < numBytes; i++)
        [output appendFormat:@"%02x", *ptr++];
    
    return output;
}

#define IFT_ETHER 0x6 

+ (NSData *) macAddress
{    
    struct ifaddrs *addrs;
    struct ifaddrs *current;
    const struct sockaddr_dl *dlAddr;
    const unsigned char* base;
    unsigned char macAddr[6] = {0,0,0,0,0,0};
    
    if (getifaddrs(&addrs) == 0) 
    {
        current = addrs;
        
        while (current != 0) 
        {
            if ( (current->ifa_addr->sa_family == AF_LINK)
                && (((const struct sockaddr_dl *) current->ifa_addr)->sdl_type == IFT_ETHER) && strcmp("en0", current->ifa_name)==0 ) 
            {
                dlAddr = (const struct sockaddr_dl *) current->ifa_addr;
                base = (const unsigned char*) &dlAddr->sdl_data[dlAddr->sdl_nlen];

                memcpy(macAddr,base, 6);
            }
            current = current->ifa_next;
        }
        
        freeifaddrs(addrs);
    }    
    
    return [NSData dataWithBytes:macAddr length:6];
}

+ (BOOL) isPad
{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
}

+ (BOOL) isPhone
{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone);
}

+ (BOOL) isTallPhone
{
    return ([self isPhone] && [UIApplication sharedApplication].keyWindow.frame.size.height > 500.0f);
}

+ (BOOL) isSmallPhone
{
    return ([self isPhone] && ![self isTallPhone]);
}

+ (BOOL) isLandscape:(UIViewController *)controller
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    return UIInterfaceOrientationIsLandscape(orientation) || UIDeviceOrientationIsLandscape(controller.interfaceOrientation);
}

+ (BOOL) isOS7
{
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0");
}

+ (void) dispatch:(dispatch_block_t) block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), block);
}

+ (void) dispatchUI:(dispatch_block_t) block
{
    if ([NSThread isMainThread])
        block();
    else
        dispatch_async(dispatch_get_main_queue(), block);
}

+ (void) dispatchUI:(dispatch_block_t) block withDelay:(NSTimeInterval) delay
{
    double delayInSeconds = delay;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}


+ (NSArray *) liftToArray:(id)object
{
    if (!object)
        return nil;
    
    if ([object isKindOfClass:[NSArray class]])
        return object;
    
    return [NSArray arrayWithObject:object];
}

+ (NSArray *) liftToArrayNotNil:(id)object
{
    if (!object)
        return [NSArray array];
    
    if ([object isKindOfClass:[NSArray class]])
        return object;
    
    return [NSArray arrayWithObject:object];
    
}


@end
