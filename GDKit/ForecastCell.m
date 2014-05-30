//
//  ForecastCell.m
//  Morning
//
//  Created by Giovanni Alcantara on 15/05/14.
//  Copyright (c) 2014 Giovanni Alcantara. All rights reserved.
//

#import "ForecastCell.h"

@interface ForecastCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconWeatherLabel;
@property (weak, nonatomic) IBOutlet UIView *cellView;

@end

@implementation ForecastCell

-(void)setupForecastCell:(Weather *)weatherData {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [self.cellView setBackgroundColor:[weatherData.tempColor colorWithAlphaComponent:0.4]];
    
    self.timeLabel.text = [formatter stringFromDate:weatherData.time];
    self.tempLabel.text = [NSString stringWithFormat:@"%d°",(int)weatherData.temperature];
    self.iconWeatherLabel.image = [UIImage imageNamed:[NSString stringWithFormat:@"weatherIcon_%@", weatherData.iconID]];
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
