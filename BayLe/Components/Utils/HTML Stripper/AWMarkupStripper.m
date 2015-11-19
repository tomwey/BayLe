//
//  AWMarkupStripper.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-17.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "AWMarkupStripper.h"
#import "AWEntityTables.h"

@implementation AWMarkupStripper
{
    NSMutableArray* _strings;
}

- (void)dealloc
{
    [_strings release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [_strings addObject:string];
}

- (NSData *)       parser:(NSXMLParser *)parser
resolveExternalEntityName:(NSString *)name
                 systemID:(NSString *)systemID
{
    return [[[AWEntityTables sharedInstance] iso88591] objectForKey:name];
}

- (NSString *)parse:(NSString *)htmlString
{
    _strings = [[NSMutableArray alloc] init];
    
    NSString* document = [NSString stringWithFormat:@"<x>%@</x>", htmlString];
    NSData* data = [document dataUsingEncoding:htmlString.fastestEncoding];
    NSXMLParser* parser = [[[NSXMLParser alloc] initWithData:data] autorelease];
    parser.delegate = self;
    [parser parse];
    
    NSString* result = [_strings componentsJoinedByString:@""];
    
    [_strings release];
    _strings = nil;
    
    return result;
}

@end

@implementation NSString (RemoveHTMLTags)

/**
 * 返回一个已经移除了所有HTML标签的字符串
 */
- (NSString *)stringByRemovingHTMLTags
{
    AWMarkupStripper* stripper = [[[AWMarkupStripper alloc] init] autorelease];
    return [stripper parse:self];
}

@end
