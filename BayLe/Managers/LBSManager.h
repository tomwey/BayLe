//
//  LBSManager.h
//  BayLe
//
//  Created by tangwei1 on 15/11/30.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, LocationErrorCode) {
    LocationErrorCodeNotFound = -97,
    LocationErrorCodeParseError = -98,
    LocationErrorCodePOISearchError = -99,
};

FOUNDATION_EXTERN NSString * const LBSManagerUserLocationDidChangeNotification;

@class Location;
@interface LBSManager : NSObject

+ (instancetype)sharedInstance;

/**
 * 打开定位
 * 
 * @param completion 位置处理回调，如果解析成功，则返回正确的位置信息，否则位置信息为nil，并返回错误
 */
- (void)startUpdatingLocation;

- (void)startUpdatingLocation:( void (^)(Location* aLocation, NSError* error) )completion;

/**
 * 关闭定位
 */
- (void)stopUpdatingLocation;

/**
 * POI数据搜索
 *
 * @param keyword 位置关键字
 * @param completion 搜索完成的回调，回调参数locations为原生的位置数据
 * @return
 */
- (void)POISearch:(NSString *)keyword completion:( void (^)(NSArray* locations, NSError* aError) )completion;

/** 返回当前用户位置信息 */
@property (nonatomic, retain, readonly) Location* currentLocation;

/** 返回当前最新的位置 */
@property (nonatomic, retain, readonly) CLLocation* currentCLLocation;

/** 返回定位过程中的错误，包括解析错误 */
@property (nonatomic, retain, readonly) NSError* locationError;

@end

/**
 * 获取两点之间的距离字符串
 */
static inline NSString* LBSDistanceStringBetweenTwoLocations(CLLocation *oneLocation, CLLocation *otherLocation) {
    double distance = [oneLocation distanceFromLocation:otherLocation];
    
    NSString* distanceString = nil;
    if ( distance >= 1000 ) {
        distanceString = [NSString stringWithFormat:@"%.1fkm", distance / 1000.0];
    } else {
        distanceString = [NSString stringWithFormat:@"%dm", (int)distance];
    }
    
    return distanceString;
};

/**
 * 解析坐标字符串成一个CLLocation对象
 * @param location 位置经纬度字符串，格式为120.234443,45.0349494
 */
static inline CLLocation* LBSParseLocationForCoordinate(NSString* coordinateString) {
    NSArray* locations = [coordinateString componentsSeparatedByString:@","];
    CLLocation* location = [[[CLLocation alloc] initWithLatitude:[[locations lastObject] doubleValue]
                                                       longitude:[[locations firstObject] doubleValue]] autorelease];
    return location;
};

