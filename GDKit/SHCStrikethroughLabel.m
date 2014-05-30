//
//  SHCStrikethroughLabel.m
//  ClearStyle
//
//  Created by Colin Eberhardt on 29/08/2012.
//  Copyright (c) 2012 Colin Eberhardt. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SHCStrikethroughLabel.h"

@implementation SHCStrikethroughLabel {
    bool _strikethrough;
    CALayer* _strikethroughLayer;
}

const float STRIKEOUT_THICKNESS = 2.0f;

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _strikethroughLayer = [CALayer layer];
        _strikethroughLayer.backgroundColor = [[UIColor whiteColor] CGColor];
        _strikethroughLayer.hidden = YES;
        [self.layer addSublayer:_strikethroughLayer];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self resizeStrikeThrough];
}

-(void)setText:(NSString *)text {
    [super setText:text];
    [self resizeStrikeThrough];
}

// resizes the strikethrough layer to match the current label text
-(void)resizeStrikeThrough {
    CGSize textSize = [self.text sizeWithAttributes:@{NSFontAttributeName: self.font}];
    _strikethroughLayer.frame = CGRectMake(0, self.bounds.size.height/2,
                                           textSize.width, STRIKEOUT_THICKNESS);
}

#pragma mark - property setter
-(void)setStrikethrough:(bool)strikethrough {
    _strikethrough = strikethrough;
    _strikethroughLayer.hidden = !strikethrough;
}

@end
