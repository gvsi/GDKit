//
//  ForecastCell.h
//  Morning
//
//  Created by Giovanni Alcantara on 15/05/14.
//  Copyright (c) 2014 Giovanni Alcantara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weather.h"

@interface ForecastCell : UICollectionViewCell

-(void)setupForecastCell:(Weather *)weatherData;

@end