//
//  StockTableViewCell.m
//  Morning
//
//  Created by Giovanni Alcantara on 27/05/14.
//  Copyright (c) 2014 Giovanni Alcantara. All rights reserved.
//

#import "StockTableViewCell.h"

@implementation StockTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
