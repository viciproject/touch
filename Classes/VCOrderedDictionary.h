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

#import <Foundation/Foundation.h>


@interface VCOrderedDictionary : NSObject <NSCoding, NSCopying>
{
    NSMutableArray *_keys;
    NSMutableDictionary *_values;
}


- (void) addObject:(id)object forKey:(id)key;

- (NSUInteger) count;

- (NSArray *) getObjects;

- (void) insertObject:(id)object forKey:(id)key atIndex:(NSUInteger)index;

- (id) objectAtIndex:(NSUInteger)index;
- (id) objectForKey:(id)key;

- (void) removeAllObjects;
- (void) removeObjectAtIndex:(NSUInteger)index;
- (void) removeObjectForKey:(id)key;

- (void) replaceObjectAtIndex:(NSUInteger)index withObject:(id)object;
- (void) replaceObjectWithKey:(id)key withObject:(id)object;

- (void) setObject:(id)object forKey:(id)key;

@end
