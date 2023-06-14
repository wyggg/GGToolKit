//
//  GGBlankPageComponent.m
//  GGToolKit_Example
//
//  Created by yg on 2023/6/14.
//  Copyright © 2023 yyyggg. All rights reserved.
//

#import "GGBlankPageComponent.h"

@implementation GGBlankPageComponent

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI{
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.frame = self.superview.bounds;
    [self.superview bringSubviewToFront:self];
}

@end
