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

#import "VCXmlParser.h"

@interface VCXmlParser()

- (BOOL) parse:(NSData *)data;

@end

@interface VCXmlElement()
{
    NSMutableArray *_children;
}

@property (nonatomic,strong) VCXmlElement *parent;

- (void) addChild:(VCXmlElement *)element;

+ (VCXmlElement *) elementWithName:(NSString *)name andAttributes:(NSDictionary *)attributes;

@end

@implementation VCXmlElement

+ (VCXmlElement *) elementWithName:(NSString *)name andAttributes:(NSDictionary *)attributes
{
    VCXmlElement *element = [[VCXmlElement alloc] init];
    
    element.name = name;
    element.attributes = attributes;
    
    return element;
}

- (void) addChild:(VCXmlElement *)element
{
    if (!_children)
        _children = [[NSMutableArray alloc] init];
    
    [_children addObject:element];
}

- (NSArray *) children
{
    return _children;
}

- (VCXmlElement *) findElement:(NSString *)name
{
    for (VCXmlElement *element in _children)
    {
        if ([element.name isEqualToString:name])
            return element;
    }
    
    return nil;
}

- (NSString *) findValue:(NSString *)name
{
    VCXmlElement *element = [self findElement:name];
    
    if (element)
        return element.value;
    
    return nil;
}

- (NSDictionary *) toGraph
{
    NSMutableDictionary *value = [[NSMutableDictionary alloc] init];
    
    for (NSString *attributeName in self.attributes.keyEnumerator)
        [value setObject:self.attributes[attributeName] forKey:[NSString stringWithFormat:@"@%@",attributeName]];
    
    if (self.value)
        [value setObject:self.value forKey:@""];

    for (VCXmlElement *element in self.children)
    {
        NSString *name = element.name;
        
        id existing = value[name];
        NSDictionary *childGraph = [element toGraph];
        
        if (existing)
        {
            NSMutableArray *list;
            
            if ([existing isKindOfClass:[NSMutableArray class]])
            {
                list = (NSMutableArray *) existing;
            }
            else
            {
                list = [[NSMutableArray alloc] init];
                
                [list addObject:existing];
                
                [value setObject:list forKey:name];
            }
            
            [list addObject:childGraph];
        }
        else
        {
            [value setObject:childGraph forKey:name];
        }
    }
    
    return value;
}

@end


@implementation VCXmlParser
{
    NSMutableString * _text;
    VCXmlElement * _currentElement;
}

+ (VCXmlElement *) parseData:(NSData *)data
{
    VCXmlParser *parser = [VCXmlParser new];
    
    BOOL success = [parser parse:data];
    
    return success ? parser->_currentElement : nil;
}

+ (VCXmlElement *) parseUrl:(NSString *)url
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    return [self parseData:data];
}

+ (VCXmlElement *) parseFile:(NSString *)file
{
    NSData *data = [NSData dataWithContentsOfFile:file];
    
    return [self parseData:data];
}

- (BOOL) parse:(NSData *)data
{
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	
	parser.delegate = self;
    
    _currentElement = nil;
    _text = [[NSMutableString alloc] init];
    
    BOOL success = [parser parse];
    
    return success;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    VCXmlElement *element = [VCXmlElement elementWithName:elementName andAttributes:attributeDict];
    
    element.parent = _currentElement;

    if (_currentElement)
    {
        [_currentElement addChild:element];
    }
    
    _currentElement = element;
    
    [_text setString:@""];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    _currentElement.value = _text;
    
    if (_currentElement.parent)
    {
        _currentElement = _currentElement.parent;
    }
    
    [_text setString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    string   =   [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    [_text appendString:string];
}

@end
