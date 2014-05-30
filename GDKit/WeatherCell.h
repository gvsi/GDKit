//
//  WeatherCell.h
//  Morning
//
//  Created by Giovanni Alcantara on 10/05/14.
//  Copyright (c) 2014 Giovanni Alcantara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weather.h"
@interface WeatherCell : UICollectionViewCell

@property (nonatomic) IBOutlet UILabel* conditionDescriptionLabel;
@property (nonatomic) IBOutlet UILabel* tempMaxLabel;
@property (nonatomic) IBOutlet UILabel* tempMinLabel;
@property (nonatomic) IBOutlet UILabel* humidityLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *forecastCollectionView;

@property (nonatomic) IBOutlet UIView* cellView;

- (void)setUpWeatherCell:(Weather *)weatherData;

@end
