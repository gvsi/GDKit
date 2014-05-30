//
//  SHCTableView.h
//  Morning
//
//  Created by Giovanni Alcantara on 21/05/14.
//  Copyright (c) 2014 Giovanni Alcantara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHCTableViewDataSource.h"
#import "SHCTableViewCell.h"

@interface SHCTableView : UIView

// the object that acts as the data source for this table
@property (nonatomic, assign) id<SHCTableViewDataSource> dataSource;
@property (nonatomic,assign) BOOL isEditing;
@property (nonatomic, assign, readonly) UIScrollView* scrollView;

// dequeues a cell that can be reused
-(UIView*)dequeueReusableCell;

// registers a class for use as new cells
-(void)registerClassForCells:(Class)cellClass;

// an array of cells that are currently visible, sorted from top to bottom.
-(NSArray*)visibleCells;

// forces the table to dispose of all the cells and re-build the table.
-(void)reloadData;

-(void) refreshView;
@end