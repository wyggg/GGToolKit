//
//  GGExcelTextCell.m
//  GGToolKitDemo
//
//  Created by yg on 2024/1/10.
//

#import "GGExcelTextCell.h"

@implementation GGExcelTextCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 0;
        [self.contentView addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _textLabel.frame = self.contentView.bounds;
}

@end
