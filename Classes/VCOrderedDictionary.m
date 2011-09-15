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


@implementation VCOrderedDictionary


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

- (NSArray *) getObjects
{
    NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:[_keys count]];
    
    for (id key in _keys)
    {
        [objects addObject:[_values objectForKey:key]];
    }
    
    NSArray *returnObjects = [objects copy];
    
    [objects release];
    
    return [returnObjects autorelease];
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

@end
