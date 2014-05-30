//
//  ViewController.m
//  Morning
//
//  Created by Giovanni Alcantara on 14/04/14.
//  Copyright (c) 2014 Giovanni Alcantara. All rights reserved.
//

#import "ViewController.h"
#import "BTGlassScrollView.h"
#import "WeatherKit.h"
#import "Weather.h"
#import "WeatherCell.h"
#import "ForecastCell.h"
#import "SVPullToRefresh.h"
#import "SHCToDoItem.h"
#import "ToDoCell.h"
#import "SHCTableViewCell.h"
#import "SHCTableViewPinchToAdd.h"
//#import "StockTableViewCell.h"

#define kTimerIntervalInSeconds 5
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;

@property (weak, nonatomic) IBOutlet UIView *mainView2;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;


@property (weak, nonatomic) IBOutlet UIView *homeView;

@property (strong, nonatomic) HomeViewController *homeViewController;
@property (strong, nonatomic) WeatherKit *weatherKit;
@property (strong, nonatomic) Weather *weather;
@property (strong, nonatomic) WeatherCell *weatherCell;
@property (strong, nonatomic) ForecastCell *forecastCell;

@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;

@property (strong, nonatomic) NSMutableArray *forecastArray;
@property (strong, nonatomic) UICollectionView *forecastCollectionView;;

@end

@implementation ViewController {
    __weak UIScrollView *weakForegroundScrollView;
    NSMutableArray* _toDoItems;
    SHCTableView *_toDoTableView;
    SHCTableView *_stockTableView;
    float _editingOffset;
    SHCTableViewPinchToAdd* _pinchAddNew;
}

- (void)viewDidLoad
{
    //Initialize location manager
    _locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    [self.locationManager startUpdatingLocation];
    
    _toDoItems = [[NSMutableArray alloc] init];
    [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Feed the cat"]];
    [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Buy eggs"]];
    [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Pack bags for WWDC"]];
    [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Rule the web"]];
    [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Buy a new iPhone"]];
    [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Find missing socks"]];
    [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Write a new tutorial"]];
    [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Master Objective-C"]];
    [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Remember your wedding anniversary!"]];
    [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Drink less beer"]];
    [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Learn to draw"]];
    [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Take the car to the garage"]];
    [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Sell things on eBay"]];
    [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Learn to juggle"]];
    [_toDoItems addObject:[SHCToDoItem toDoItemWithText:@"Give up"]];
    
    
    
    [super viewDidLoad];
    
    
    self.homeViewController = [[HomeViewController alloc] init];
    self.homeViewController.view.frame = self.homeView.bounds;
    
    [self.homeView addSubview:self.homeViewController.view];
    [self addChildViewController:self.homeViewController];
    
    self.glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@""] blurredImage:nil viewDistanceFromBottom:120 foregroundView:[self customView]];
    
    weakForegroundScrollView = self.glassScrollView.foregroundScrollView;
    __weak ViewController *weakSelf = self;
    
    [weakForegroundScrollView addPullToRefreshWithActionHandler:^{
        
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            NSLog(@"Pulled");
            [weakSelf.locationManager startUpdatingLocation];
        });
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    
    [self.view addSubview:self.glassScrollView];
    
    [self.glassScrollView setBackgroundImage:[UIImage imageNamed:@"001-StockPhoto-320x568"] overWriteBlur:YES animated:YES duration:1.0f];
    //Initial stock photos from bundle
    

}


-(void)updateTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    self.homeViewController.timeLabel.text=[formatter stringFromDate:[NSDate date]];
}


- (UIView *)customView
{
    UIView *view = self.mainView2;
    
    
    [self.tempLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120]];
    [self.tempLabel setShadowColor:[UIColor blackColor]];
    [self.tempLabel setShadowOffset:CGSizeMake(1, 1)];
    //[self.tempLabel setTextColor:[self colorForTemperature:40]];
    
    [self.locationLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:24]];
    [self.locationLabel adjustsFontSizeToFitWidth];
    
    [self.locationLabel setShadowColor:[UIColor blackColor]];
    [self.locationLabel setShadowOffset:CGSizeMake(1, 1)];
    
    return view;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateLocations");
    CLLocation *currentLocation = [locations lastObject];
    [[WeatherKit sharedInstance] weatherAtLocation:currentLocation success:^(NSDictionary *weatherResult)
     {
         
         self.weather = [[Weather alloc] initWithDictionary:weatherResult];
         
         // Set up weather overview on the first page
         self.locationLabel.text = self.weather.cityName;
         self.tempLabel.text = [NSString stringWithFormat:@"%d°",(int)self.weather.temperature];
         self.weatherIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"weatherIcon_%@", self.weather.iconID]];
         
         
         
         NSLog(@"Updated weather data");
     } failure:^(NSError *error) {
         NSLog(@"Couldn't get the weather at current location");
     }];
    
    
    [[WeatherKit sharedInstance] hourlyForecastAtLocation:currentLocation success:^(NSDictionary *weatherResult2)
     {
         self.forecastArray = [weatherResult2[@"list"] mutableCopy];

         if ([self.forecastArray count] != 0) {
             
             NSDateComponents* tomorrowComponents = [NSDateComponents new] ;
             tomorrowComponents.day = 1 ;
             NSDate* tomorrow = [[NSCalendar currentCalendar] dateByAddingComponents:tomorrowComponents toDate:[NSDate date] options:0] ;
             
             NSDateComponents* tomorrowAt6AMComponents = [[NSCalendar currentCalendar] components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:tomorrow];
             tomorrowAt6AMComponents.hour = 6;
             
             for (NSInteger i = [self.forecastArray count] - 1; i >= 0 ; i--) {
                 NSDate *date = [self.forecastArray objectAtIndex:i][@"dt"];
                 if ([date compare:[[NSCalendar currentCalendar] dateFromComponents:tomorrowAt6AMComponents]] == NSOrderedDescending) {
                     [self.forecastArray removeObjectAtIndex:i];
                 }
             }
             [self.mainCollectionView reloadData];
         }
         
     } failure:^(NSError *error) {
         NSLog(@"Couldn't get the weather forecast at current location");
     }];
    
    [self.locationManager stopUpdatingLocation];
    NSLog(@"Stops animating");
    [weakForegroundScrollView.pullToRefreshView stopAnimating];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location Manager failed with error: %@",error);
    [weakForegroundScrollView.pullToRefreshView stopAnimating];
    [self.locationManager stopUpdatingLocation];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error getting your location" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Hey 2 - ");
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    if (collectionView == self.mainCollectionView) {
        if (indexPath.row == 0) {
            size = CGSizeMake(320, 150 + [self.forecastArray count] * 60);
        } else if (indexPath.row == 1) {
            size = CGSizeMake(320, 60 * [_toDoItems count]);
        }
    } else if (collectionView == self.forecastCollectionView) {
        size = CGSizeMake(320, 60);
    }
    
    return size;
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count;
    if (collectionView == self.mainCollectionView) {
        if (self.weather != nil) {
            count = 2;
        } else {
            count = 0;
        }
    } else if (collectionView == self.forecastCollectionView) {
        count = [self.forecastArray count];
    }
    return count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    UICollectionViewCell *collectionViewCell;
    if (collectionView == self.mainCollectionView) {
        if (indexPath.row == 0) {
            self.weatherCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WeatherCell" forIndexPath:indexPath];
            [self.weatherCell setUpWeatherCell:self.weather];
            self.forecastCollectionView = self.weatherCell.forecastCollectionView;
            collectionViewCell = self.weatherCell;
        } else if (indexPath.row == 1){
            collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ToDoCell" forIndexPath:indexPath];
            _toDoTableView = (SHCTableView *)[collectionViewCell viewWithTag:1];
            _toDoTableView.dataSource = self;
            _toDoTableView.backgroundColor = [UIColor clearColor];
            [_toDoTableView registerClassForCells:[SHCTableViewCell class]];
            _pinchAddNew = [[SHCTableViewPinchToAdd alloc] initWithTableView:_toDoTableView];
        } else if (indexPath.row == 2) {
            collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StockCell" forIndexPath:indexPath];
            _stockTableView = (SHCTableView *)[collectionViewCell viewWithTag:2];
            _stockTableView.dataSource = self;
            _stockTableView.backgroundColor = [UIColor clearColor];
            //[_stockTableView registerClassForCells:[StockTableViewCell class]];
        }
    } else if (collectionView == self.forecastCollectionView) {
        ForecastCell *cell = [self.forecastCollectionView dequeueReusableCellWithReuseIdentifier:@"ForecastCell" forIndexPath:indexPath];
        Weather *weather = [[Weather alloc] initWithDictionary2:[self.forecastArray objectAtIndex:indexPath.row]];
        [cell setupForecastCell:weather];
        collectionViewCell = cell;
    }
    
    return collectionViewCell;
}

#pragma mark - SHCTableViewDataSource methods
-(NSInteger)numberOfRows {
    return _toDoItems.count;
}

-(UITableViewCell *)cellForRow:(NSInteger)row {
    SHCTableViewCell* cell = (SHCTableViewCell*)[_toDoTableView dequeueReusableCell];
    SHCToDoItem *item = _toDoItems[row];
    cell.todoItem = item;
    cell.delegate = self;
    cell.backgroundColor = [self colorForIndex:row];
    if (cell.todoItem.completed == YES) {
        cell.itemCompleteLayer.hidden = NO;
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

-(UIColor*)colorForIndex:(NSInteger) index {
    NSUInteger itemCount = _toDoItems.count - 1;
    float val = ((float)index / (float)itemCount) * 1.2;
    return [UIColor colorWithRed: 1.0 green:val blue: 0.0 alpha:0.3];
}

-(void)itemAdded {
    [self itemAddedAtIndex:0];
}

-(void)itemAddedAtIndex:(NSInteger)index {
    // create the new item
    SHCToDoItem* toDoItem = [[SHCToDoItem alloc] init];
    [_toDoItems insertObject:toDoItem atIndex:index];
    
    // refresh the table
    [_toDoTableView reloadData];
    
    CGRect newFrame = _toDoTableView.superview.superview.frame;
    newFrame.size.height = [_toDoItems count] * 60.0f;
    
    [_toDoTableView.superview.superview setFrame:newFrame];
    
    // enter edit mode
    SHCTableViewCell* editCell;
    for (SHCTableViewCell* cell in _toDoTableView.visibleCells) {
        if (cell.todoItem == toDoItem) {
            editCell = cell;
            break;
        }
    }
    [editCell.label becomeFirstResponder];
}

#pragma mark - UITableViewDataDelegate protocol methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [self colorForIndex:indexPath.row];
}

-(void)toDoItemDeleted:(id)todoItem {
    float delay = 0.0;
    
    // remove the model object
    [_toDoItems removeObject:todoItem];
    
    // find the visible cells
    NSArray* visibleCells = [_toDoTableView visibleCells];
    
    UIView* lastView = [visibleCells lastObject];
    bool startAnimating = false;
    
    // iterate over all of the cells
    for(SHCTableViewCell* cell in visibleCells) {
        if (startAnimating) {
            [UIView animateWithDuration:0.3
                                  delay:delay
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 cell.frame = CGRectOffset(cell.frame, 0.0f, -cell.frame.size.height);
                             }
                             completion:^(BOOL finished){
                                 if (cell == lastView) {
                                     [_toDoTableView reloadData];
                                 }
                             }];
            delay+=0.03;
        }
        
        // if you have reached the item that was deleted, start animating
        if (cell.todoItem == todoItem) {
            startAnimating = true;
            cell.hidden = YES;
        }
    }
}
-(BOOL)cellShoudBeginEditing:(SHCTableViewCell *)cell {
    if (_toDoTableView.isEditing == YES) {
        _toDoTableView.isEditing = NO;
        [_toDoTableView endEditing:YES];
        [self cellDidEndEditing:cell];
        return NO;
    } else {
        return YES;
    }
    
}

-(void)cellDidBeginEditing:(SHCTableViewCell *)editingCell {
    _toDoTableView.isEditing = YES;
    
    //_editingOffset = _toDoTableView.scrollView.contentOffset.y - editingCell.frame.origin.y;
    [self.glassScrollView.foregroundScrollView setContentOffset:CGPointMake(0, self.glassScrollView.foregroundScrollView.frame.size.height + [self.mainCollectionView viewWithTag:3].frame.origin.y + editingCell.frame.origin.y - 60.0f) animated:YES];

    for(SHCTableViewCell* cell in [_toDoTableView visibleCells]) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             //cell.frame = CGRectOffset(cell.frame, 0, _editingOffset);
                             if (cell != editingCell) {
                                 cell.alpha = 0.3;
                             }
                         }];
    }

}

-(void)cellDidEndEditing:(SHCTableViewCell *)editingCell {
    if (!(editingCell.label.text && editingCell.label.text.length > 0)) {
        [editingCell.delegate toDoItemDeleted:editingCell.todoItem];
    }
    
    for(SHCTableViewCell* cell in [_toDoTableView visibleCells]) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             //cell.frame = CGRectOffset(cell.frame, 0, -_editingOffset);
                             if (cell != editingCell)
                             {
                                 cell.alpha = 1.0;
                             }
                         }];
    }
    _toDoTableView.isEditing = NO;
}


@end
