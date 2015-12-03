//
//  Location.h
//  BayLe
//
//  Created by tangwei1 on 15/12/3.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Location : NSObject

@property (nonatomic, copy) NSString* city;
@property (nonatomic, copy) NSString* placement;
@property (nonatomic, copy) NSString* address;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (id)initWithCity:(NSString *)city placement:(NSString *)placement;
+ (id)locationWithCity:(NSString *)city placement:(NSString *)placement;

@end

@interface Location (Wrapper)

/** 返回位置格式化字符串，格式为：120.344444,65.012345 */
- (NSString *)locationString;

@end
