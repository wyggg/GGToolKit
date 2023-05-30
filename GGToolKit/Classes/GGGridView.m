//
//  GGGridView.m
//  GGToolKit
//
//  Created by yg on 2023/5/30.
//

#import "GGGridView.h"


@interface GGGridView ()

@property (nonatomic, strong) NSMutableArray *itemArray;

@end

@implementation GGGridView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _rowSpacing = 0;
        _columnSpacing = 0;
        _warpCount = 10;
        _itemWidth = 0;
        _itemHeight = 0;
        _itemArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (_warpCount == 0){
        return;
    }
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat itemWidth = 0;
    if (self.itemWidth > 0){
        itemWidth = self.itemWidth;
    }else{
        itemWidth = (width - (self.warpCount-1)*self.columnSpacing)/self.warpCount;//每个Item的宽度为（总宽度减去间隔）/列数
    }
    CGFloat itemHeight = 0;
    if (self.itemHeight > 0){
        itemHeight = self.itemHeight;
    }else{
        NSInteger rowCount = (self.itemArray.count / self.warpCount) + (self.itemArray.count % self.warpCount == 0 ? 0 : 1);
        itemHeight = (height - (rowCount-1)*self.rowSpacing)/rowCount;
    }
//    itemHeight = itemWidth;
    int row = 0,column = 0;
    for (UIView * item in _itemArray){
        item.frame = CGRectMake(column*(itemWidth+self.columnSpacing), row*(itemHeight+self.rowSpacing), itemWidth, itemHeight);
        column++;
        if(column>=self.warpCount){
            column = 0;
            row++;
        }
    }
}

- (void)insertItem:(UIView *)item{
    [_itemArray addObject:item];
    [self addSubview:item];
    [self setNeedsLayout];
}

- (void)removeItem:(UIView *)item{
    if (item.superview == self){
        [_itemArray removeObject:item];
        [item removeFromSuperview];
        [self setNeedsLayout];
    }
}



@end

