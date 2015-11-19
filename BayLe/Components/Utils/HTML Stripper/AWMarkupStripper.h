//
//  AWMarkupStripper.h
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-17.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __IPHONE_4_0 && __IPHONE_4_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
@interface AWMarkupStripper : NSObject <NSXMLParserDelegate>
#else
@interface AWMarkupStripper : NSObject
#endif

/**
 * 去除HTML字符串的所有标签
 */
    
- (NSString *)parse:(NSString *)htmlString;
    
@end

@interface NSString (RemoveHTMLTags)

/**
 * 返回一个已经移除了所有HTML标签的字符串
 */
- (NSString *)stringByRemovingHTMLTags;

@end
