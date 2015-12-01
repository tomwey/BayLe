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

/** 返回定位过程中的错误，包括解析错误 */
@property (nonatomic, retain, readonly) NSError* locationError;

@end

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
