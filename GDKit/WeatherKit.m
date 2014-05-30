//
//  WeatherKit.m
//  Morning
//
//  Created by Giovanni Alcantara on 08/05/14.
//  Copyright (c) 2014 Giovanni Alcantara. All rights reserved.
//

#import "WeatherKit.h"
#import <OWMWeatherAPI.h>
#import <AFNetworking.h>

@interface WeatherKit()
@property OWMWeatherAPI* weatherAPI;
@property NSURL *imageBaseURL;
@end

@implementation WeatherKit

+ (id)sharedInstance
{
    static WeatherKit *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _weatherAPI = [[OWMWeatherAPI alloc] initWithAPIKey:@"35749c0399d8dfe755fd8bbeed0548c4"];
        _imageBaseURL = [[NSURL alloc] initWithString:@"http://openweathermap.org/img/w"];
    }
    return self;
}

- (void)weatherAtLocation:(CLLocation*)location success:(void (^)(NSDictionary* result))success failure:(void (^)(NSError *error))failure
{
    [self.weatherAPI currentWeatherByCoordinate:location.coordinate withCallback:^(NSError *error, NSDictionary *result) {
        if (!error) {
            success(result);
        } else {
            failure(error);
        }
    }];
}

- (void)forecastAtLocation:(CLLocation*)location success:(void (^)(NSDictionary* result))success failure:(void (^)(NSError *error))failure
{
    [self.weatherAPI dailyForecastWeatherByCoordinate:location.coordinate withCount:14 andCallback:^(NSError *error, NSDictionary *result) {
        if (!error) {
            //get the forecast
            success(result);
        } else {
            failure(error);
        }
    }];
}

- (void)hourlyForecastAtLocation:(CLLocation*)location success:(void (^)(NSDictionary* result))success failure:(void (^)(NSError *error))failure
{
    [self.weatherAPI forecastWeatherByCoordinate:location.coordinate withCallback:^(NSError *error, NSDictionary *result) {
        if (!error) {
            //get the forecast
            success(result);
        } else {
            failure(error);
        }
    }];
}


- (void)weatherIconWithId:(NSString *)iconId success:(void (^)(UIImage* icon))success failure:(void (^)(NSError* error))failure
{
    if (iconId) {
        NSURL *imageURL = [self.imageBaseURL URLByAppendingPathComponent:iconId];
        UIImage *iconImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        if (iconImage) {
            success(iconImage);
        } else {
            failure([NSError errorWithDomain:@"Failed to fetch the image" code:-1 userInfo:nil]);
        }
    }
    failure([NSError errorWithDomain:@"Icon ID is nil" code:-1 userInfo:nil]);
}

//Returns image view with the weather icon
- (UIImageView *)weatherIconWithId:(NSString *)iconId
{
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    NSURL *imageURL = [self.imageBaseURL URLByAppendingPathComponent:iconId];
    [iconView setImageWithURL:imageURL];
    return iconView;
}

@end
