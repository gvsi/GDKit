//
//  WeatherCell.m
//  Morning
//
//  Created by Giovanni Alcantara on 10/05/14.
//  Copyright (c) 2014 Giovanni Alcantara. All rights reserved.
//

#import "WeatherCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation WeatherCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setUpWeatherCell:(Weather *)weatherData
{
    //[self.cellView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.2]];
    //self.cellView.layer.cornerRadius = 7;
    //self.cellView.layer.masksToBounds = YES;
    self.conditionDescriptionLabel.text = weatherData.weatherDescription;
    self.tempMaxLabel.text = [NSString stringWithFormat:@"%d °C",weatherData.temperatureMax];
    self.tempMinLabel.text = [NSString stringWithFormat:@"%d °C",weatherData.temperatureMin];
    self.humidityLabel.text = [NSString stringWithFormat:@"%d %%",weatherData.humidity];


}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
