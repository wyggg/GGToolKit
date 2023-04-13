//
//  NSArray+GGMasonryLayout.h
//  GGExtensionDemo
//
//  对Masonry的二次封装
//  Created by yg on 2022/12/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

//方向
typedef NS_ENUM(NSInteger, GGLayoutDirection) {
	GGLayoutDirectionLeftToRight = 0,//从左到右
	GGLayoutDirectionTopToBottom = 1,//从上到下
	GGLayoutDirectionRightToLeft = 2,//从右到左
	GGLayoutDirectionBottomToTop = 3,//从下到上
	GGLayoutDirectionLeftTopToRightBottom = 4,//左上角到右下角
	GGLayoutDirectionLeftBottomToRightTop= 5,//左下角到右上角
	GGLayoutDirectionRightTopToLeftBottom= 6,//右上角到左下角
	GGLayoutDirectionRightBottomToLeftTop= 7,//右下角到左上角
};

//对齐方式
typedef NS_ENUM(NSInteger, GGLayoutAlignment){
	GGLayoutAlignmentFill = 0,//调整Size对齐两边
	GGLayoutAlignmentLeading = 1,//首线对齐
	GGLayoutAlignmentMiddle = 2,//中线对齐
	GGLayoutAlignmentTrailing = 3//尾线对齐
};


@interface NSArray (GGMasonryLayout)

#define GGAutoSpacing CGFLOAT_MIN//指定自动计算间距
#define GGAutoSize    -1//指定自己计算宽高

/**
 *  九宫格布局1（放在容器内）
 *  将Item以等高等宽的九宫格样式排列
 *
 *  @param warpCount          折行点，指定每一行显示多少个View
 *  @param leftSpacing        左间距，内容距离父视图左侧间距
 *  @param rightSpacing       右间距，内容距离父视图右侧间距
 *  @param topSpacing         顶间距，内容距离父视图顶部间距
 *  @param bottomSpacing      底间距，内容距离父视图底部间距
 *  @param lineSpacing        行间距，每一行的间距，如果传入GGAutoSpacing表示自适应
 *  @param columnSpacing      列间距，每一列的间距，如果传入GGAutoSpacing表示自适应
 *  @param itemWidth          指定item宽度 如果传入GGAutoSize表示自适应
 *  @param itemHeight         指定item高度 如果传入GGAutoSize表示自适应
 *  @return 返回自身
 *
 * +—————————————+
 * | [+] [+] [+] |
 * | [+] [+] [+] |
 * | [+] [+] [+] |
 * +—————————————+
 */
- (NSArray *)gg_layoutGridWithWarpCount:(NSInteger)warpCount
							leftSpacing:(CGFloat)leftSpacing
						   rightSpacing:(CGFloat)rightSpacing
							 topSpacing:(CGFloat)topSpacing
						  bottomSpacing:(CGFloat)bottomSpacing
							lineSpacing:(CGFloat)lineSpacing
						  columnSpacing:(CGFloat)columnSpacing
							  itemWidth:(CGFloat)itemWidth
							 itemHeight:(CGFloat)itemHeight;

/**
 *  九宫格布局2（依赖某个视图）
 *  将Item以等高等宽的九宫格样式排列
 *
 *  @param warpCount          折行点，指定每一行显示多少个View
 *  @param direction          视图的延伸方向
 *  @param lineSpacing        行间距，每一行的间距，如果传入GGAutoSpacing表示自适应
 *  @param columnSpacing      列间距，每一列的间距，如果传入GGAutoSpacing表示自适应
 *  @param firstConstraints   队长的约束条件
 *  @return 返回自身
 *
 * +—————————————+
 * | [XXX]       |
 * | [+] [+] [+] |
 * | [+] [+] [+] |
 * | [+] [+] [+] |
 * +—————————————+
 */
- (NSArray *)gg_layoutGridWithWarpCount:(NSInteger)warpCount
							  direction:(GGLayoutDirection)direction
							lineSpacing:(CGFloat)lineSpacing
						  columnSpacing:(CGFloat)columnSpacing
					   firstConstraints:(void(^)(MASConstraintMaker *make))firstConstraints;

/**
 *  堆叠布局（依赖某个视图）
 *  动态的Item大小，视图向下换行堆叠
 *
 *  @param size              最大宽度
 *  @param lineSpacing       行间距
 *  @param columnSpacing     列间距
 *  @param layoutDirection   布局方向
 *  @param flowAlignment     布局对齐方式
 *  @param itemAlignment     行内对齐方式
 *  @param firstConstraints  基准视图约束规则
 *  @return 返回自身
 *
 *  +——————————————————+
 *  | [XXX]            |
 *  | [=][==][=][====] |  ↓
 *  | [===][=][==][==] |  ↓
 *  | [=][==][=][====] |  ↓
 *  +——————————————————+
 */

- (NSArray *)gg_layoutFlowWithSize:(CGFloat)size
					   lineSpacing:(CGFloat)lineSpacing
					 columnSpacing:(CGFloat)columnSpacing
				   layoutDirection:(GGLayoutDirection)layoutDirection
					 flowAlignment:(GGLayoutAlignment)flowAlignment
					 itemAlignment:(GGLayoutAlignment)itemAlignment
				  firstConstraints:(void(^)(MASConstraintMaker *make))firstConstraints;

@end

NS_ASSUME_NONNULL_END
