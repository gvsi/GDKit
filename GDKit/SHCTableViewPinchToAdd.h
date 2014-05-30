//
//  SHCTableViewPinchToAdd.h
//  Morning
//
//  Created by Giovanni Alcantara on 23/05/14.
//  Copyright (c) 2014 Giovanni Alcantara. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SHCTableView;

// A behaviour that adds the facility to pinch the list in order to insert a new
// item at any location.
//
@interface SHCTableViewPinchToAdd : NSObject

// associates this behaviour with the given table
- (id)initWithTableView:(SHCTableView*)tableView;

@end
