//
//  NSArray+GGMasonryLayout.m
//  GGExtensionDemo
//
//  Created by yg on 2022/12/12.
//

#import "NSArray+GGMasonryLayout.h"
#import <Masonry/Masonry.h>
#import <UIKit/UIKit.h>

@implementation NSArray (GGMasonryLayout)

//九宫格布局
- (NSArray *)gg_layoutGridWithWarpCount:(NSInteger)warpCount
							leftSpacing:(CGFloat)leftSpacing
						   rightSpacing:(CGFloat)rightSpacing
							 topSpacing:(CGFloat)topSpacing
						  bottomSpacing:(CGFloat)bottomSpacing
							lineSpacing:(CGFloat)lineSpacing
						  columnSpacing:(CGFloat)columnSpacing
							  itemWidth:(CGFloat)itemWidth
							 itemHeight:(CGFloat)itemHeight
{
	if (warpCount <= 0){
		return self;
	}
	//将视图分为若干行
	NSMutableArray *rowsArray = [self warpItemWithCount:warpCount];
	__block NSArray <UIView *>*prevRows = nil;//上一次循环的行
	for (int row=0; row<rowsArray.count; row++){
		NSArray <UIView *>*currRows = rowsArray[row];
		__block UIView *prevItem = nil;//上一次循环的Item
		for (int column = 0; column<currRows.count;column++){
			UIView *currView = currRows[column];
			[currView mas_remakeConstraints:^(MASConstraintMaker *make) {
				if (row == 0){
					make.top.equalTo(@(topSpacing));
				}else{
					if (itemHeight>GGAutoSize && lineSpacing == GGAutoSpacing){
						//指定了高度，动态计算上下间距
						CGFloat offset = (1-(row/((CGFloat)rowsArray.count-1)))*(itemHeight+topSpacing)-row*bottomSpacing/(((CGFloat)rowsArray.count-1));
						make.bottom.equalTo(currView.superview).multipliedBy(row/((CGFloat)rowsArray.count-1)).offset(offset);
					}else{
						make.top.equalTo(prevRows.firstObject.mas_bottom).offset(lineSpacing);
					}
				}
				if (column == 0){
					make.left.equalTo(@(leftSpacing));
				}else{
					if (itemWidth>GGAutoSize && columnSpacing == GGAutoSpacing){
						//指定了宽度，动态计算间距
						CGFloat offset = (1-(column/((CGFloat)warpCount-1)))*(itemWidth+leftSpacing)-column*rightSpacing/(((CGFloat)warpCount-1));
						make.right.equalTo(currView.superview).multipliedBy(column/((CGFloat)warpCount-1)).offset(offset);
					}else{
						//未指定宽度，使用设定的间距
						make.left.equalTo(prevItem.mas_right).offset(columnSpacing);
					}

				}

				if (itemWidth>GGAutoSize){
					//指定了宽度
					make.width.equalTo(@(itemWidth));
				}else{
					//未指定宽度
					if (prevItem){
						make.width.equalTo(prevItem);
					}
					//最后一个
					if (currView == currRows.lastObject){
						make.right.equalTo(currView.superview.mas_right).offset(-rightSpacing);
					}
				}

				if (itemHeight>GGAutoSize) {
					//指定了高度
					make.height.equalTo(@(itemHeight));
				}else{
					//未指定高度
					if (prevRows){
						make.height.equalTo(prevRows[0]);
					}else{
						make.height.equalTo(currRows[0]);
					}
					//最后一个
					if (currRows == rowsArray.lastObject){
						make.bottom.equalTo(currView.superview.mas_bottom).offset(-bottomSpacing);
					}
				}
			}];
			prevItem = currView;
		}
		prevRows = currRows;
	}
	return self;
}

- (NSMutableArray *)warpItemWithCount:(NSInteger)warpCount{
	NSInteger rowCount = self.count / warpCount;
	if(self.count % warpCount != 0){
		rowCount = rowCount + 1;
	}
	NSMutableArray *rowsArray = [NSMutableArray arrayWithCapacity:rowCount];
	for (int i=0; i<rowCount; i++){
		NSMutableArray *array = [NSMutableArray array];
		for (int a=0; a<warpCount; a++){
			NSInteger curr = i * warpCount + a;
			if (curr < self.count){
				[array addObject:self[curr]];
			}
		}
		[rowsArray addObject:array];
	}
	return rowsArray;

}

//九宫格布局
- (NSArray *)gg_layoutGridWithWarpCount:(NSInteger)warpCount
							  direction:(GGLayoutDirection)direction
							lineSpacing:(CGFloat)lineSpacing
						  columnSpacing:(CGFloat)columnSpacing
					   firstConstraints:(void(^)(MASConstraintMaker *make))firstConstraints
{
	if (warpCount <= 0){
		return self;
	}
	//将视图分为若干行
	NSMutableArray *rowsArray = [self warpItemWithCount:warpCount];
	__block NSArray <UIView *>*prevRows = nil;//上一次循环的行
	for (int row=0; row<rowsArray.count; row++){

		NSArray <UIView *>*currRows = rowsArray[row];
		UIView *prevItem = nil;//上一次循环的Item
		for (int column = 0; column<currRows.count;column++){
			UIView *currView = currRows[column];
			if (row == 0 && column == 0){
				[currView mas_remakeConstraints:^(MASConstraintMaker *make) {
					firstConstraints(make);
				}];
			}else{
				[currView mas_remakeConstraints:^(MASConstraintMaker *make) {
					make.width.equalTo(self.firstObject);
					make.height.equalTo(self.firstObject);
					if (direction == GGLayoutDirectionLeftTopToRightBottom){
						if (column == 0){
							make.left.equalTo(self.firstObject);
						}else{
							make.left.equalTo(prevItem.mas_right).offset(columnSpacing);
						}
						if (row == 0){
							make.top.equalTo(((UIView *)self.firstObject).mas_top);
						}else{
							make.top.equalTo(prevRows.lastObject.mas_bottom).offset(lineSpacing);
						}
					}else if (direction == GGLayoutDirectionLeftBottomToRightTop){
						if (column == 0){
							make.left.equalTo(self.firstObject);
						}else{
							make.left.equalTo(prevItem.mas_right).offset(columnSpacing);
						}
						if (row == 0){
							make.bottom.equalTo(((UIView *)self.firstObject).mas_bottom);
						}else{
							make.bottom.equalTo(prevRows.lastObject.mas_top).offset(-lineSpacing);
						}
					}else if (direction == GGLayoutDirectionRightTopToLeftBottom){
						if (column == 0){
							make.right.equalTo(self.firstObject);
						}else{
							make.right.equalTo(prevItem.mas_left).offset(-columnSpacing);
						}
						if (row == 0){
							make.top.equalTo(((UIView *)self.firstObject).mas_top);
						}else{
							make.top.equalTo(prevRows.lastObject.mas_bottom).offset(lineSpacing);
						}
					}else if (direction == GGLayoutDirectionRightBottomToLeftTop){
						if (column == 0){
							make.right.equalTo(self.firstObject);
						}else{
							make.right.equalTo(prevItem.mas_left).offset(-columnSpacing);
						}
						if (row == 0){
							make.bottom.equalTo(((UIView *)self.firstObject).mas_bottom);
						}else{
							make.bottom.equalTo(prevRows.lastObject.mas_top).offset(-lineSpacing);
						}
					}

				}];
			}
			prevItem = currView;
		}
		prevRows = currRows;
	}
	return self;
}



- (NSArray *)gg_layoutFlowWithSize:(CGFloat)size
					   lineSpacing:(CGFloat)lineSpacing
					 columnSpacing:(CGFloat)columnSpacing
				   layoutDirection:(GGLayoutDirection)layoutDirection
					 flowAlignment:(GGLayoutAlignment)flowAlignment
					 itemAlignment:(GGLayoutAlignment)itemAlignment
				  firstConstraints:(void(^)(MASConstraintMaker *make))firstConstraints;
{

	if (size <=0) {
		size = CGFLOAT_MAX;
	}
	if (layoutDirection == GGLayoutDirectionLeftToRight) {
		layoutDirection = GGLayoutDirectionLeftTopToRightBottom;
	}else if (layoutDirection == GGLayoutDirectionTopToBottom){
		layoutDirection = GGLayoutDirectionLeftTopToRightBottom;
	}else if (layoutDirection == GGLayoutDirectionRightToLeft){
		layoutDirection = GGLayoutDirectionRightTopToLeftBottom;
	}else if (layoutDirection == GGLayoutDirectionBottomToTop){
		layoutDirection = GGLayoutDirectionLeftBottomToRightTop;
	}
	//将视图分为若干行
	CGFloat currSize = 0;
	NSMutableArray *rowsArray = [NSMutableArray array];
	NSMutableArray *currRowArray = [NSMutableArray array];
	for (int i=0; i < self.count; i++){
		UIView *view = self[i];
		[view sizeToFit];
		[view layoutIfNeeded];
		CGSize viewSize = view.frame.size;
		currSize = currSize + viewSize.width;
		if (currSize > size){
			[rowsArray addObject:currRowArray];
			currRowArray = [NSMutableArray array];
			[currRowArray addObject:view];
			currSize = viewSize.width;
			currSize = currSize + columnSpacing;
		}else{
			[currRowArray addObject:view];
			currSize = currSize + columnSpacing;
		}
		if (i == self.count -1){
			[rowsArray addObject:currRowArray];
		}
	}

	//循环设置视图的布局
	UIView *prevItem = nil;//上一次循环的Item
	UIView *firstItem = self.firstObject;//第一个Item
	NSMutableArray *prevRows = nil;//上一行所有Item
	UIView *prevRowsLastItem = nil;//上一行最高的Item

	//创建一个隐藏的视图辅助定位
	UIView *baseLine = [[UIView alloc] init];
	baseLine.hidden = NO;
	baseLine.tag = 9999966666;
	baseLine.hidden = YES;
	baseLine.backgroundColor = [UIColor redColor];
	[firstItem.superview addSubview:baseLine];
	[baseLine mas_makeConstraints:^(MASConstraintMaker *make) {
		if (firstConstraints){
			firstConstraints(make);
		}
	}];

	for(int row=0;row<rowsArray.count;row++){
		NSArray *tempRow = rowsArray[row];
		UIView *rowsLastItem = nil;//当前行最高的Item
		CGFloat rowsWidth = 0;//当前行的宽度
		CGFloat rowsHeight = 0;//当前行的宽度
		//计算当前行的宽度
		for (UIView *tempItem in tempRow) {
			if (tempItem.frame.size.height > rowsLastItem.frame.size.height){
				rowsLastItem = tempItem;
			}
			rowsWidth += CGRectGetWidth(tempItem.frame) + columnSpacing;
		}
		rowsWidth = rowsWidth - columnSpacing;
		rowsHeight = CGRectGetHeight(rowsLastItem.frame);

		//左右间距
		CGFloat vSpacing = 0;
		if (flowAlignment == GGLayoutAlignmentFill){
			vSpacing = 0;
		}else if (flowAlignment == GGLayoutAlignmentLeading){
			vSpacing = 0;
		}else if (flowAlignment == GGLayoutAlignmentMiddle){
			vSpacing = (size - rowsWidth) / 2;
		}else if (flowAlignment == GGLayoutAlignmentTrailing){
			vSpacing = (size - rowsWidth);
		}

		for (UIView *tempItem in tempRow) {
			CGFloat width = (size - rowsWidth) / tempRow.count + CGRectGetWidth(tempItem.frame);
			CGFloat height = CGRectGetHeight(tempItem.frame);
			if (tempItem != rowsLastItem){
				height = CGRectGetHeight(rowsLastItem.frame);
			}
			[tempItem mas_remakeConstraints:^(MASConstraintMaker *make) {
				if (flowAlignment == GGLayoutAlignmentFill){
					make.width.offset(width);
				}else{
					make.width.offset(CGRectGetWidth(tempItem.frame));
				}
				if (itemAlignment == GGLayoutAlignmentFill){
					make.height.offset(height);
				}else{
					make.height.offset(CGRectGetHeight(tempItem.frame));
				}
			}];
		}

		for (UIView *tempItem in tempRow) {

			if (tempItem != firstItem) {
				[tempItem mas_makeConstraints:^(MASConstraintMaker *make) {
					//上下间距
					CGFloat spacing = lineSpacing;
					if (prevRowsLastItem){
						if (itemAlignment == GGLayoutAlignmentFill){
							spacing = lineSpacing;
						}else if (itemAlignment == GGLayoutAlignmentLeading){
							spacing = lineSpacing;
						}else if (itemAlignment == GGLayoutAlignmentMiddle){
							spacing = lineSpacing + (CGRectGetHeight(rowsLastItem.frame)- CGRectGetHeight(tempItem.frame))/2;
						}else if (itemAlignment == GGLayoutAlignmentTrailing){
							spacing = lineSpacing + (CGRectGetHeight(rowsLastItem.frame)- CGRectGetHeight(tempItem.frame));
						}
					}else{
						if (itemAlignment == GGLayoutAlignmentFill){
							spacing = 0;
						}else if (itemAlignment == GGLayoutAlignmentLeading){
							spacing = 0;
						}else if (itemAlignment == GGLayoutAlignmentMiddle){
							spacing = (CGRectGetHeight(firstItem.frame)- CGRectGetHeight(tempItem.frame))/2;
						}else if (itemAlignment == GGLayoutAlignmentTrailing){
							spacing = (CGRectGetHeight(firstItem.frame)- CGRectGetHeight(tempItem.frame));
						}
					}

//					if (row == 0){
//						spacing = 0;
//					}

					if (layoutDirection == GGLayoutDirectionLeftTopToRightBottom){
						if (prevRowsLastItem){
							make.top.equalTo(prevRowsLastItem.mas_bottom).offset(spacing);
						}else{
							make.top.equalTo(firstItem).offset(spacing);
						}
						if (tempItem == tempRow.firstObject){
							make.left.equalTo(baseLine).offset(vSpacing);
						}else{
							make.left.equalTo(prevItem.mas_right).offset(columnSpacing);
						}
					}else if (layoutDirection == GGLayoutDirectionLeftBottomToRightTop){
						if (prevRowsLastItem){
							make.bottom.equalTo(prevRowsLastItem.mas_top).offset(-spacing);
						}else{
							make.bottom.equalTo(firstItem).offset(-spacing);
						}
						if (tempItem == tempRow.firstObject){
							make.left.equalTo(baseLine).offset(vSpacing);
						}else{
							make.left.equalTo(prevItem.mas_right).offset(columnSpacing);
						}
					}else if (layoutDirection == GGLayoutDirectionRightTopToLeftBottom){
						if (prevRowsLastItem){
							make.top.equalTo(prevRowsLastItem.mas_bottom).offset(spacing);
						}else{
							make.top.equalTo(firstItem).offset(spacing);
						}
						if (tempItem == tempRow.firstObject){
							make.right.equalTo(baseLine).offset(-vSpacing);
						}else{
							make.right.equalTo(prevItem.mas_left).offset(-columnSpacing);
						}
					}else if (layoutDirection == GGLayoutDirectionRightBottomToLeftTop){
						if (prevRowsLastItem){
							make.bottom.equalTo(prevRowsLastItem.mas_top).offset(-spacing);
						}else{
							make.bottom.equalTo(firstItem).offset(-spacing);
						}
						if (tempItem == tempRow.firstObject){
							make.right.equalTo(baseLine).offset(-vSpacing);
						}else{
							make.right.equalTo(prevItem.mas_left).offset(-columnSpacing);
						}
					}
				}];
			}else{

				[tempItem mas_makeConstraints:^(MASConstraintMaker *make) {
					CGFloat spacing = 0;
					if (itemAlignment == GGLayoutAlignmentFill){
						spacing = 0;
					}else if (itemAlignment == GGLayoutAlignmentLeading){
						spacing = 0;
					}else if (itemAlignment == GGLayoutAlignmentMiddle){
						spacing = (CGRectGetHeight(rowsLastItem.frame) - CGRectGetHeight(tempItem.frame))/2;
					}else if (itemAlignment == GGLayoutAlignmentTrailing){
						spacing = CGRectGetHeight(rowsLastItem.frame) - CGRectGetHeight(tempItem.frame);
					}
					if (spacing < 0){
						spacing = 0;
					}

					if (layoutDirection == GGLayoutDirectionLeftTopToRightBottom){
						make.top.equalTo(baseLine).offset(spacing);
						make.left.equalTo(baseLine).offset(vSpacing);
					}else if (layoutDirection == GGLayoutDirectionLeftBottomToRightTop){
						make.bottom.equalTo(baseLine).offset(-spacing);
						make.left.equalTo(baseLine).offset(vSpacing);
					}else if (layoutDirection == GGLayoutDirectionRightTopToLeftBottom){
						make.top.equalTo(baseLine).offset(spacing);
						make.right.equalTo(baseLine).offset(-vSpacing);
					}else if (layoutDirection == GGLayoutDirectionRightBottomToLeftTop){
						make.bottom.equalTo(baseLine).offset(-spacing);
						make.right.equalTo(baseLine).offset(-vSpacing);
					}
				}];
			}
			prevItem = tempItem;
		}
		prevRows = (NSMutableArray *)tempRow;
		prevRowsLastItem = rowsLastItem;
	}

	return self;
}


@end
