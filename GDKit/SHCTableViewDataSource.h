//
//  SHCTableViewDataSource.h
//  Morning
//
//  Created by Giovanni Alcantara on 21/05/14.
//  Copyright (c) 2014 Giovanni Alcantara. All rights reserved.
//

// The SHCTableViewDataSource is adopted by a class that is a source of data
// for a SHCTableView
@protocol SHCTableViewDataSource <NSObject>

// Indicates the number of rows in the table
-(NSInteger)numberOfRows;

// Obtains the cell for the given row
-(UIView *)cellForRow:(NSInteger)row;

// Informs the datasource that a new item has been added at the given index
-(void) itemAddedAtIndex:(NSInteger)index;

@end
