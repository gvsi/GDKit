//
//  WeatherKit.h
//  Morning
//
//  Created by Giovanni Alcantara on 08/05/14.
//  Copyright (c) 2014 Giovanni Alcantara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WeatherKit : NSObject

+ (id)sharedInstance;
- (void)weatherAtLocation:(CLLocation*)location success:(void (^)(NSDictionary* result))success failure:(void (^)(NSError *error))failure;
- (void)weatherIconWithId:(NSString *)iconId success:(void (^)(UIImage* icon))success failure:(void (^)(NSError* error))failure;
- (void)forecastAtLocation:(CLLocation*)location success:(void (^)(NSDictionary* result))success failure:(void (^)(NSError *error))failure;
- (void)hourlyForecastAtLocation:(CLLocation*)location success:(void (^)(NSDictionary* result))success failure:(void (^)(NSError *error))failure;
- (UIImageView *)weatherIconWithId:(NSString *)iconId;

@end
