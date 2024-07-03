//
//  GGSplicingView.m
//  GGToolKitDemo
//
//  Created by yg on 2023/12/5.
//

#import "GGSplicingView.h"


@interface GGSplicingView()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) void *mainContext;

@property (nonatomic, assign) CGFloat itemsDisplayTotalHeight;
@property (nonatomic, assign) CGFloat itemsScrollTotalHeight;
@property (nonatomic, strong) NSMutableArray <GGSplicingItemInfo *>*itemInfos;
@property (nonatomic, strong) NSMutableArray <GGSplicingItemInfo *>*itemDisplayInfos;

@end

@implementation GGSplicingView

- (instancetype)initWithSplicingSubviews:(NSArray<__kindof UIView *> *)views{
    if (self = [super initWithFrame:CGRectMake(0, 0, 0, 0)]) {
        [self addSplicingSubViews:views];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemDisplayInfos = [NSMutableArray array];
        _itemInfos = [NSMutableArray array];
        [self loadUI];
    }
    return self;
}

- (void)addSplicingSubView:(UIView *)view{
    [self addSplicingSubView:view bindScrollView:nil top:0 btm:0];
}

- (void)addSplicingSubView:(UIView *)view bindScrollView:(UIScrollView *)scrollView top:(CGFloat)top btm:(CGFloat)btm{
    [self insertSplicingSubview:view scrollView:scrollView top:top btm:btm atIndex:_itemInfos.count];
}

- (void)insertSplicingSubview:(UIView *)view atIndex:(NSUInteger)index{
    [self insertSplicingSubview:view scrollView:nil top:0 btm:0 atIndex:index];
}

- (void)addSplicingSubViews:(NSArray *)subViews{
    for (int i=0; i<subViews.count; i++) {
        [self addSplicingSubView:subViews[i]];
    }
}

- (void)insertSplicingSubview:(UIView *)view scrollView:(UIScrollView *)scrollView top:(CGFloat)top btm:(CGFloat)btm atIndex:(NSUInteger)index{
    GGSplicingItemInfo *info = [[GGSplicingItemInfo alloc] init];
    info.view = view;
    info.scrollView = scrollView;
    info.itemScrollTopOffset = top;
    info.itemScrollBtmOffset = btm;
    scrollView.scrollEnabled = NO;
    [_itemInfos insertObject:info atIndex:index];
    [self updateDisplayInfos];
    [self.contentView addSubview:view];
}

- (void)removeSplicingSubView:(UIView *)view{
    [view removeFromSuperview];
    for (GGSplicingItemInfo *info in _itemInfos) {
        if (info.view == view) {
            [_itemInfos removeObject:info];
            break;
        }
    }
    [self updateDisplayInfos];
}

- (void)updateDisplayInfos{
    [_itemDisplayInfos removeAllObjects];
    for (GGSplicingItemInfo *info in _itemInfos) {
        if (info.view.hidden == NO) {
            [_itemDisplayInfos addObject:info];
        }
    }
}

- (void)setCustomSpacing:(CGFloat)spacing afterView:(UIView *)splicingSubview{
    
}

- (void)loadUI{
    _scrollView = [[UIScrollView alloc] init];
    [self addSubview:_scrollView];
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:self.mainContext];
    _contentView = [[UIView alloc] init];
    [self.scrollView addSubview:_contentView];
}

- (void)dealloc{
    //移除对主视图的监听
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == _mainContext) {
        [self updateSubViewsOffset];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self layoutSubViewFrames];
}

- (void)reloadData{
    [self layoutSubViewFrames];
    [self updateSubViewsOffset];
}

//更新子视图位置并生成布局信息
- (void)layoutSubViewFrames{
    CGFloat itemsDisplayTotalHeight = 0;
    CGFloat itemsScrollTotalHeight = 0;
    CGFloat itemsLayoutTotalHeight = 0;
//    for (GGSplicingItemInfo *info in _itemDisplayInfos) {
//        info.itemTopSpacing = 20;
//        info.itemBtmSpacing = 50;
//    }
    for (int i=0; i<_itemDisplayInfos.count; i++) {
        GGSplicingItemInfo *info = _itemDisplayInfos[i];
        GGSplicingItemInfo *nextInfo = nil;
        if (i + 1 < _itemDisplayInfos.count) {
            nextInfo = _itemDisplayInfos[i + 1];
        }
        GGSplicingItemInfo *previousInfo = nil;
        if (i - 1 >= 0 && i - 1 < _itemDisplayInfos.count) {
            previousInfo = _itemDisplayInfos[i - 1];
        }
        if (info.view.superview != self.contentView) {
            [self.contentView addSubview:info.view];
        }
        
        if (info.scrollView) {
            
            if (info.scrollView == info.view) {
                CGFloat itemViewHeight = MIN(info.scrollView.contentSize.height, self.frame.size.height);
                CGFloat scrollContentHeight = info.scrollView.contentSize.height;
                
                info.view.frame = CGRectMake(0, itemsLayoutTotalHeight, self.frame.size.width, itemViewHeight);
                
                itemsLayoutTotalHeight += itemViewHeight;
                
                info.itemDisplayTop = itemsDisplayTotalHeight;
                itemsDisplayTotalHeight += itemViewHeight;
                info.itemDisplayBtm = itemsDisplayTotalHeight;
                
                info.itemScrollTop = itemsScrollTotalHeight;
                itemsScrollTotalHeight += scrollContentHeight;
                info.itemScrollBtm = itemsScrollTotalHeight;
            }else{
                CGFloat TOP = info.itemScrollTopOffset;
                CGFloat BTM = info.itemScrollBtmOffset;
                CGFloat scrollContentHeight = info.scrollView.contentSize.height;
                CGFloat itemViewHeight = MIN(scrollContentHeight + TOP + BTM, self.frame.size.height);
                
                info.view.frame = CGRectMake(0, itemsLayoutTotalHeight, self.frame.size.width, itemViewHeight);
                info.scrollView.frame = CGRectMake(info.scrollView.frame.origin.x, TOP, info.scrollView.frame.size.width, itemViewHeight - TOP - BTM);
                
                itemsLayoutTotalHeight += itemViewHeight;
                
                info.itemDisplayTop = itemsDisplayTotalHeight;
                itemsDisplayTotalHeight += itemViewHeight;
                info.itemDisplayBtm = itemsDisplayTotalHeight;
                
                info.itemScrollTop = itemsScrollTotalHeight;
                itemsScrollTotalHeight += scrollContentHeight + TOP + BTM;
                info.itemScrollBtm = itemsScrollTotalHeight;
            }
            
        }else{
            
            CGFloat itemViewHeight = [self queryViewHeightWithView:info.view];
            info.view.frame = CGRectMake(0, itemsLayoutTotalHeight, self.frame.size.width, itemViewHeight);
            
            itemsLayoutTotalHeight += itemViewHeight;
            
            info.itemDisplayTop = itemsDisplayTotalHeight;
            itemsDisplayTotalHeight += itemViewHeight;
            info.itemDisplayBtm = itemsDisplayTotalHeight;
            
            info.itemScrollTop = itemsScrollTotalHeight;
            itemsScrollTotalHeight += itemViewHeight;
            info.itemScrollBtm = itemsScrollTotalHeight;
        }
    }
    
    _scrollView.frame = self.bounds;
    _scrollView.contentSize = CGSizeMake(self.frame.size.width, itemsScrollTotalHeight);
    _contentView.frame = CGRectMake(0, 0, self.frame.size.width, itemsDisplayTotalHeight);
    _itemsScrollTotalHeight = itemsScrollTotalHeight;
    _itemsDisplayTotalHeight = itemsDisplayTotalHeight;
}

//根据当前布局信息更新子视图滚动偏移
- (void)updateSubViewsOffset{
    if (_itemDisplayInfos.count != 0) {
        
        //定位当前显示的View
        CGFloat mainScrollViewOffset = _scrollView.contentOffset.y;
        GGSplicingItemInfo *currInfo = nil;
        if (mainScrollViewOffset < _itemDisplayInfos.firstObject.itemScrollTop) {
            currInfo = _itemDisplayInfos.firstObject;
        }else if (mainScrollViewOffset > _itemDisplayInfos.lastObject.itemScrollTop){
            currInfo = _itemDisplayInfos.lastObject;
        }else{
            for (int i=0; i < _itemDisplayInfos.count; i++) {
                currInfo = [_itemDisplayInfos objectAtIndex:i];
                if (mainScrollViewOffset >= currInfo.itemScrollTop && mainScrollViewOffset < currInfo.itemScrollBtm){
                    break;
                }
            }
        }
        
        //计算视图偏移
        UIScrollView *currScrollView = currInfo.scrollView;
        CGFloat currScrollTop = currInfo.itemScrollTop;
        CGFloat currDisplayTop = currInfo.itemDisplayTop;
        
        //更新ContentView顶边
        if (currScrollView) {
            CGFloat currentScrollOffset = mainScrollViewOffset - currScrollTop;//获得偏移量 主ScrollView偏移量 - 内容顶部
            CGFloat currentDisplayHeight = currInfo.itemDisplayBtm - currInfo.itemDisplayTop;//获取视图高度
            CGFloat currentContentHeight = currInfo.itemScrollBtm - currInfo.itemScrollTop;//计算内容高度
            CGFloat currentScrollMax = currentContentHeight - currentDisplayHeight;//计算最大偏移量
            if (currentScrollOffset <= currentScrollMax) {
                _contentView.frame = CGRectMake(_contentView.frame.origin.x,
                                                currentScrollOffset + currScrollTop - currDisplayTop,
                                                _contentView.frame.size.width,
                                                _contentView.frame.size.height);
                currScrollView.contentOffset = CGPointMake(currScrollView.contentOffset.x, currentScrollOffset);
            }else{
                _contentView.frame = CGRectMake(_contentView.frame.origin.x,
                                                currentScrollMax + currScrollTop - currDisplayTop,
                                                _contentView.frame.size.width,
                                                _contentView.frame.size.height);
                currScrollView.contentOffset = CGPointMake(currScrollView.contentOffset.x, currentContentHeight - currentDisplayHeight);
            }
            
        }else{
            CGFloat contentViewTop = currScrollTop - currDisplayTop;
            _contentView.frame = CGRectMake(0, contentViewTop, self.frame.size.width, _itemsDisplayTotalHeight);
        }
        
        //更新ScrollView偏移量
        NSInteger index = [_itemDisplayInfos indexOfObject:currInfo];
        [self syncOtherScrollViewWithCurrentIndex:index];
    }
}

- (void)syncOtherScrollViewWithCurrentIndex:(NSInteger)index{
    for (int i=0; i<_itemDisplayInfos.count; i++) {
        GGSplicingItemInfo *info = _itemDisplayInfos[i];
        if (info.scrollView) {
            CGFloat itemScrollHeight = info.itemScrollBtm - info.itemScrollTop;
            CGFloat itemDisplayHeight = info.itemDisplayBtm - info.itemDisplayTop;
            if (i < index) {
                if (info.scrollView.contentOffset.y != itemScrollHeight - itemDisplayHeight) {
                    info.scrollView.contentOffset = CGPointMake(info.scrollView.contentOffset.x, itemScrollHeight - itemDisplayHeight);
                }
            }else if (i > index){
                if (info.scrollView.contentOffset.y != 0) {
                    info.scrollView.contentOffset = CGPointMake(info.scrollView.contentOffset.x, 0);
                }
            }
        }
    }
}

//从约束或frame中查询到view的高度
- (CGFloat)queryViewHeightWithView:(UIView *)view{
    NSLayoutConstraint *heightConstraint = nil;
    for (NSLayoutConstraint *constraint in view.constraints) {
        if (constraint.firstItem == view && constraint.firstAttribute == NSLayoutAttributeHeight) {
            heightConstraint = constraint;
            break;
        }
    }
    if (heightConstraint) {
        return heightConstraint.constant;
    }else{
        return view.frame.size.height;
    }
}

@end


@implementation GGSplicingItemInfo

@end


//                CGRect scrollViewFrame = [scrollView convertRect:scrollView.bounds toView:nil];
//                scrollViewTop = scrollViewFrame.origin.y;
//                scrollViewBtm = info.view.frame.size.height - scrollViewTop - scrollViewHeight;
