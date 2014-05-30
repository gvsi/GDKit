//
//  ViewController.h
//  Morning
//
//  Created by Giovanni Alcantara on 14/04/14.
//  Copyright (c) 2014 Giovanni Alcantara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "BTGlassScrollView.h"
#import "SHCTableViewCellDelegate.h"
#import "SHCTableView.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, SHCTableViewCellDelegate, SHCTableViewDataSource>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) BTGlassScrollView *glassScrollView;

@end
