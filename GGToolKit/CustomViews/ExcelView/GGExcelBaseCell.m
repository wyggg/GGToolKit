//
//  GGExcelBaseCell.m
//  GGToolKitDemo
//
//  Created by yg on 2024/1/10.
//

#import "GGExcelBaseCell.h"

@interface GGExcelBaseCell()


@end

@implementation GGExcelBaseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _separatorLeftView = [[UIView alloc] init];
        _separatorRightView = [[UIView alloc] init];
        _separatorTopView = [[UIView alloc] init];
        _separatorBottomView = [[UIView alloc] init];
        
        _separatorLeftView.backgroundColor = [UIColor grayColor];
        _separatorRightView.backgroundColor = [UIColor grayColor];
        _separatorTopView.backgroundColor = [UIColor grayColor];
        _separatorBottomView.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.contentView addSubview:_separatorLeftView];
    [self.contentView addSubview:_separatorRightView];
    [self.contentView addSubview:_separatorTopView];
    [self.contentView addSubview:_separatorBottomView];
    
    CGFloat contentWidth = self.contentView.frame.size.width;
    CGFloat contentHeight = self.contentView.frame.size.height;
    
    _separatorTopView.frame = CGRectMake(_separatorTopMargin, 0, contentWidth - _separatorTopMargin*2, _separatorTopScale);
    _separatorLeftView.frame = CGRectMake(0, _separatorLeftMargin, _separatorLeftScale, contentHeight - _separatorLeftMargin*2);
    _separatorBottomView.frame = CGRectMake(_separatorBottomMargin, contentHeight - _separatorBottomScale, contentWidth - _separatorBottomMargin*2, _separatorBottomScale);
    _separatorRightView.frame = CGRectMake(contentWidth - _separatorRightScale, _separatorRightMargin, _separatorRightScale, contentHeight - _separatorRightMargin*2);
    
    
}

@end
