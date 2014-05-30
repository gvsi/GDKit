//
//  Weather.m
//  BatApp
//
//  Created by Swechha Prakash on 28/03/14.
//  Copyright (c) 2014 Swechha. All rights reserved.
//

#import "Weather.h"
#import "WeatherKit.h"
#import <OpenWeatherMapAPI/OWMWeatherAPI.h>
#import <math.h>
#import <CoreGraphics/CoreGraphics.h>


@interface Weather()

@property OWMWeatherAPI *weatherAPI;

@end

@implementation Weather

- (instancetype)init
{
    if (self = [super init]) {
        //init
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary*)response
{
    if (self = [super init]) {
        _latitude = [response[@"coord"][@"lat"] floatValue];
        _longitude = [response[@"coord"][@"long"] floatValue];
        _temperature = roundf([response[@"main"][@"temp"] floatValue]);
        _cityName = response[@"name"];
        _weatherDescription = response[@"weather"][0][@"description"];
        _iconID = response[@"weather"][0][@"icon"];
        _humidity = [response[@"main"][@"humidity"] integerValue];
        _temperatureMax = [response[@"main"][@"temp_max"] integerValue];
        _temperatureMin = [response[@"main"][@"temp_min"] integerValue];
    }
    return self;
}

- (instancetype)initWithDictionary2:(NSDictionary*)response
{
    if (self = [super init]) {
        _time = response[@"dt"];
        _temperature = roundf([response[@"main"][@"temp"] floatValue]);
        _tempColor = [self colorForTemperature:[response[@"main"][@"temp"] floatValue]];
        _weatherDescription = response[@"weather"][0][@"description"];
        _iconID = response[@"weather"][0][@"icon"];
        _temperatureMax = [response[@"main"][@"temp_max"] integerValue];
        _temperatureMin = [response[@"main"][@"temp_min"] integerValue];
    }
    return self;
}

- (UIColor *)colorForTemperature:(CGFloat)temperature{
    UIImage *colors = [UIImage imageNamed:@"colors"];
    
    CGFloat xCoord = (temperature/38)*(colors.size.width-1);
    CGFloat yCoord = colors.size.height/2;
    
    //coordinates for 1 pixel on the image computed from the temperature value
    CGPoint point = CGPointMake(xCoord,yCoord);
    
    
    
    // Create a 1x1 pixel byte array and bitmap context to draw the pixel into.
    // Reference: http://stackoverflow.com/questions/1042830/retrieving-a-pixel-alpha-value-for-a-uiimage
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = colors.CGImage;
    NSUInteger width = CGImageGetWidth(cgImage);
    NSUInteger height = CGImageGetHeight(cgImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, -pointY);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


@end
