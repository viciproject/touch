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

#import "VCOrderedDictionary.h"


@interface VCOrderedDictionary ()

@property (nonatomic, retain) NSMutableArray *keys;
@property (nonatomic, retain) NSMutableDictionary *values;

@end


@implementation VCOrderedDictionary


@synthesize keys = _keys;
@synthesize values = _values;


#pragma mark - Initalization & deallocation

- (id) init
{
    self = [super init];
    
    if (self)
    {
        _keys = [[NSMutableArray alloc] init];
        _values = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void) dealloc
{
    [_keys release];
    [_values release];
    
    [super dealloc];
}

#pragma mark - Public methods

- (void) addObject:(id)object forKey:(id)key
{
    if ([_keys containsObject:key])
    {
        NSException *exception = [NSException exceptionWithName:@"IndexAlreadyExists" reason:@"Index already exists" userInfo:nil];
        
        [exception raise];
    }
    
    [_keys addObject:key];
    [_values setObject:object forKey:key];
}

- (NSUInteger) count
{
    return [_keys count];
}
- (NSArray *) getObjects
{
    NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:[_keys count]];
    
    for (id key in _keys)
    {
        [objects addObject:[_values objectForKey:key]];
    }
    
    return [objects autorelease];
}


- (void) insertObject:(id)object forKey:(id)key atIndex:(NSUInteger)index
{
    if ([_keys containsObject:key])
    {
        NSException *exception = [NSException exceptionWithName:@"IndexAlreadyExists" reason:@"Index already exists" userInfo:nil];
        
        [exception raise];
    }
    
    [_keys insertObject:key atIndex:index];
    [_values setObject:object forKey:key];
}

- (NSUInteger) indexForKey:(id)key
{
    return [_keys indexOfObject:key];
}

- (id) keyForIndex:(NSUInteger)index
{
    return [_keys objectAtIndex:index];
}

- (id) objectAtIndex:(NSUInteger)index
{
    id key = [_keys objectAtIndex:index];
    
    return [_values objectForKey:key];
}

- (id) objectForKey:(id)key
{
    return [_values objectForKey:key];
}

- (void) removeAllObjects
{
    [_keys removeAllObjects];
    [_values removeAllObjects];
}

- (void) removeObjectAtIndex:(NSUInteger)index
{
    id key = [_keys objectAtIndex:index];
    
    [_keys removeObjectAtIndex:index];
    [_values removeObjectForKey:key];
}

- (void) removeObjectForKey:(id)key
{
    NSUInteger index = [_keys indexOfObject:key];
    
    [_keys removeObjectAtIndex:index];
    [_values removeObjectForKey:key];
}

- (void) replaceObjectAtIndex:(NSUInteger)index withObject:(id)object
{
    id key = [_keys objectAtIndex:index];
    
    [_values setObject:object forKey:key];
}

- (void) replaceObjectWithKey:(id)key withObject:(id)object
{
    [_values setObject:object forKey:key];
}

- (void) setObject:(id)object forKey:(id)key
{
    if ([_keys containsObject:key])
    {
        [_values setObject:object forKey:key];
    }
    else
    {
        [self addObject:object forKey:key];
    }
}

#pragma mark - NSCoding protocol methods

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_keys forKey:@"keys"];
    [aCoder encodeObject:_values forKey:@"values"];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _keys = [[NSMutableArray arrayWithArray:[aDecoder decodeObjectForKey:@"keys"]] retain];
        _values = [[NSMutableDictionary dictionaryWithDictionary:[aDecoder decodeObjectForKey:@"values"]] retain];
    }
    
    return self;
}

#pragma mark - NSCopying protocol methods

- (id) copyWithZone:(NSZone *)zone
{
    VCOrderedDictionary *copy = [[[self class] allocWithZone:zone] init];
    
    copy.keys = [NSMutableArray arrayWithArray:_keys];
    copy.values = [NSMutableDictionary dictionaryWithDictionary:_values];
    
    return copy;
}

@end
