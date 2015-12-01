//
//  LBSManager.m
//  BayLe
//
//  Created by tangwei1 on 15/11/30.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "LBSManager.h"
#import "Defines.h"

@interface LBSManager () <CLLocationManagerDelegate, APIManagerDelegate>

@property (nonatomic, retain) CLLocationManager* locationManager;

/** 位置逆编码 */
@property (nonatomic, retain) APIManager* geocodeAPIManager;

/** 位置搜索 */
@property (nonatomic, retain) APIManager* POISearchAPIManager;

@property (nonatomic, retain, readwrite) Location* currentLocation;
@property (nonatomic, retain, readwrite) NSError* locationError;

@property (nonatomic, copy) void (^locationHandleBlock)(Location* location, NSError* error);

@property (nonatomic, retain) CLLocation* currentCLLocation;

@end

NSString * const LBSManagerUserLocationDidChangeNotification = @"LBSManagerUserLocationDidChangeNotification";

@implementation LBSManager

static NSString * const QQLBSServer      = @"http://apis.map.qq.com";
static NSString * const QQGeoCoderAPIKey = @"5TXBZ-RDMH3-6GN36-3YZ6J-2QJYK-XIFZI";

static NSString * const QQGeocodeAPI     = @"/ws/geocoder/v1";

AW_SINGLETON_IMPL(LBSManager)

#pragma mark - Public Methods
/**
 * 打开定位
 */
- (void)startUpdatingLocation
{
    if ( !self.locationManager ) {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    }
    
    if ( !self.locationManager.delegate ) {
        self.locationManager.delegate = self;
    }

    [self.locationManager startUpdatingLocation];
}

- (void)startUpdatingLocation:( void (^)(Location* aLocation, NSError* error) )completion
{
    self.locationHandleBlock = completion;
    
    [self startUpdatingLocation];
}

/**
 * 关闭定位
 */
- (void)stopUpdatingLocation
{
    self.locationManager.delegate = nil;
    self.locationHandleBlock = nil;
    
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation* newLocation = [locations lastObject];
    
    NSTimeInterval locationAge = - [newLocation.timestamp timeIntervalSinceNow];
    if ( locationAge > 5.0 ) {
        return;
    }
    
    if ( newLocation.horizontalAccuracy < 0 ) {
        return;
    }
    
    if ( !self.currentCLLocation ) {
        self.currentCLLocation = newLocation;
        [self geocodeLocation:self.currentCLLocation];
    } else {
        CLLocation* loc1 = [[[CLLocation alloc] initWithLatitude:self.currentCLLocation.coordinate.latitude
                                                       longitude:self.currentCLLocation.coordinate.longitude] autorelease];
        CLLocation* loc2 = [[[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude
                                                       longitude:newLocation.coordinate.longitude] autorelease];
        
        double distance = [loc1 distanceFromLocation:loc2];
        
        self.currentCLLocation = newLocation;
        
        if ( distance > 20 ) {
            [self geocodeLocation:self.currentCLLocation];
        } else {
            NSLog(@"updated.");
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"位置定位失败");
    
    [AWModalAlert say:@"定位服务已关闭" message:[NSString stringWithFormat:@"请到设置->隐私->定位服务中开启【%@】定位服务，以便能够准确获得您的位置信息",
                                          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]]];
    
    self.locationError = [NSError errorWithDomain:@"位置定位失败" code:LocationErrorCodeNotFound userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:LBSManagerUserLocationDidChangeNotification object:nil];
    
    if ( self.locationHandleBlock ) {
        self.locationHandleBlock(nil, self.locationError);
    }
}

#pragma mark - APIManagerDelegate
/** 网络请求成功回调 */
- (void)apiManagerDidSuccess:(APIManager *)manager
{
    if ( manager == self.geocodeAPIManager ) {
//        NSLog(@"result: %@", [manager fetchDataWithReformer:nil]);
        [self parseLocationInfo:[manager fetchDataWithReformer:nil]];
    } else if ( self.POISearchAPIManager == manager ) {
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LBSManagerUserLocationDidChangeNotification object:nil];
}

/** 网络请求失败回调 */
- (void)apiManagerDidFailure:(APIManager *)manager
{
    if ( self.geocodeAPIManager == manager ) {
        // 位置解析失败
        self.locationError = [NSError errorWithDomain:@"位置解析失败" code:LocationErrorCodeParseError userInfo:nil];
    } else if ( self.POISearchAPIManager == manager ) {
        // 位置搜索
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LBSManagerUserLocationDidChangeNotification object:nil];
    if ( self.locationHandleBlock ) {
        self.locationHandleBlock(nil, self.locationError);
    }
}

#pragma mark - Private Methods
- (void)parseLocationInfo:(id)locationInfo
{
    NSInteger code = [[locationInfo objectForKey:@"status"] integerValue];
    if ( code == 0 ) {
        NSDictionary* data = [locationInfo objectForKey:@"result"];
        
        NSDictionary* landmark = [[data  objectForKey:@"address_reference"] objectForKey:@"landmark_l2"];
        if ( !landmark ) {
            landmark = [[data  objectForKey:@"address_reference"] objectForKey:@"landmark_l1"];
        }
        
        NSString* address = [landmark objectForKey:@"title"];
        
        if ( address.length == 0 ) {
            address = [[data objectForKey:@"formatted_addresses"] objectForKey:@"recommend"];
        }
        
        if ( address.length == 0 ) {
            address = [data objectForKey:@"address"];
        }
        
        NSString* city = [[data objectForKey:@"address_component"] objectForKey:@"city"];
        
        self.currentLocation.city = city;
        self.currentLocation.placement = address;
        
        if ( self.locationHandleBlock ) {
            self.locationHandleBlock(self.currentLocation, nil);
        }
        
    } else {
        
        NSString* message = [locationInfo objectForKey:@"message"];
        self.locationError = [NSError errorWithDomain:message code:LocationErrorCodeParseError userInfo:nil];
        
        if ( self.locationHandleBlock ) {
            self.locationHandleBlock(nil, self.locationError);
        }
    }
}

- (void)geocodeLocation:(CLLocation *)location
{
    if ( [self.geocodeAPIManager isLoading] ) return;
    
    if ( !self.geocodeAPIManager ) {
        self.geocodeAPIManager = [[[APIManager alloc] initWithDelegate:self] autorelease];
        APIConfig* config      = [[[APIConfig alloc] init] autorelease];
        config.stageServer     = config.productionServer = QQLBSServer;
        self.geocodeAPIManager.apiConfig = config;
    }
    
    self.currentLocation = [Location locationWithCity:nil placement:nil];
    self.currentLocation.coordinate = location.coordinate;
    
    [self.geocodeAPIManager cancelRequest];
    
    NSString* locationVal = [NSString stringWithFormat:@"%.06lf,%.06lf", location.coordinate.latitude, location.coordinate.longitude];
    APIRequest* aRequest = APIRequestCreate(QQGeocodeAPI, RequestMethodGet, @{ @"location" : locationVal, @"key" : QQGeoCoderAPIKey, @"coord_type" : @(1)  });
    
    [self.geocodeAPIManager sendRequest:aRequest];
}

- (NSString *)locationString
{
    return [NSString stringWithFormat:@"%.06lf,%.06lf", self.currentLocation.coordinate.longitude, self.currentLocation.coordinate.latitude];
}

@end

@implementation Location

- (id)initWithCity:(NSString *)city placement:(NSString *)placement
{
    if ( self = [super init] ) {
        self.city = city;
        self.placement = placement;
    }
    return self;
}

+ (id)locationWithCity:(NSString *)city placement:(NSString *)placement
{
    return [[[Location alloc] initWithCity:city placement:placement] autorelease];
}

- (void)dealloc
{
    self.city = nil;
    self.placement = nil;
    
    [super dealloc];
}

@end
