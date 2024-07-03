//
//  GGSplicingView.h
//  GGToolKitDemo
//
//  Created by yg on 2023/12/5.
//

#import <UIKit/UIKit.h>

@interface GGSplicingView : UIView

- (instancetype)initWithSplicingSubviews:(NSArray<__kindof UIView *> *)views;
- (void)addSplicingSubView:(UIView *)view;
- (void)addSplicingSubViews:(NSArray *)subViews;
- (void)addSplicingSubView:(UIView *)view bindScrollView:(UIScrollView *)scrollView top:(CGFloat)top btm:(CGFloat)btm;
- (void)removeSplicingSubView:(UIView *)view;
- (void)insertSplicingSubview:(UIView *)view atIndex:(NSUInteger)index;
- (void)insertSplicingSubview:(UIView *)view scrollView:(UIScrollView *)scrollView top:(CGFloat)top btm:(CGFloat)btm atIndex:(NSUInteger)index;
- (void)setCustomSpacing:(CGFloat)spacing afterView:(UIView *)splicingSubview;
- (void)reloadData;

@end

@interface GGSplicingItemInfo : NSObject

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat itemScrollTop;
@property (nonatomic, assign) CGFloat itemScrollBtm;
@property (nonatomic, assign) CGFloat itemDisplayTop;
@property (nonatomic, assign) CGFloat itemDisplayBtm;

//@property (nonatomic, assign) CGFloat itemTopSpacing;
//@property (nonatomic, assign) CGFloat itemBtmSpacing;

@property (nonatomic, assign) CGFloat itemScrollTopOffset;
@property (nonatomic, assign) CGFloat itemScrollBtmOffset;

@end
