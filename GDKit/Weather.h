//
//  Weather.h
//  BatApp
//
//  Created by Swechha Prakash on 28/03/14.
//  Copyright (c) 2014 Swechha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property (nonatomic, copy) NSString *cityName;
@property CGFloat latitude;
@property CGFloat longitude;
//Temperature unit - Kelvin
@property NSInteger temperature;
//Pressure unit - hPa
@property NSInteger pressure;
@property NSInteger temperatureMin;
@property NSInteger temperatureMax;
//Humidity in %
@property NSInteger humidity;
//Overall weather description
@property (nonatomic, copy) NSString *weatherDescription;
//Icon ID for the current weather
@property (nonatomic, copy) NSString *iconID;
@property NSDate *time;
@property UIColor *tempColor;

- (instancetype)initWithDictionary:(NSDictionary*)response;
- (instancetype)initWithDictionary2:(NSDictionary*)response;

@end
