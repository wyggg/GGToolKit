//
//  GGExcelView.m
//  GGToolKitDemo
//
//  Created by yg on 2024/1/3.
//

#import "GGExcelView.h"
#import "GGExcelLayout.h"

@interface GGExcelView()<UICollectionViewDataSource, UICollectionViewDelegate,UIScrollViewDelegate,GGExcelLayout>

@property (nonatomic, strong) UICollectionView *collectionViewTopLeft;
@property (nonatomic, strong) UICollectionView *collectionViewTopRight;
@property (nonatomic, strong) UICollectionView *collectionViewBtmLeft;
@property (nonatomic, strong) UICollectionView *collectionViewBtmRight;
@property (nonatomic, strong) NSMutableDictionary *collectionViewRegisterClassDic;

@end

@implementation GGExcelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _collectionViewRegisterClassDic = [NSMutableDictionary dictionary];
        _contentView = [[UIView alloc] init];
        [self addSubview:_contentView];
        self.collectionViewTopLeft = [self createCollectionView];
        self.collectionViewTopRight = [self createCollectionView];
        self.collectionViewBtmLeft = [self createCollectionView];
        self.collectionViewBtmRight = [self createCollectionView];
        _collectionViewBtmRight.showsVerticalScrollIndicator = YES;
        _collectionViewBtmRight.showsHorizontalScrollIndicator = YES;
        [self setBounces:NO];
        [self registerClass:[GGExcelBaseCell class] forCellWithReuseIdentifier:@"GGExcelBaseCellDefaultRegistration"];
    }
    return self;
}

- (UICollectionView *)createCollectionView{
    GGExcelLayout *customLayout = [[GGExcelLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:customLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:collectionView];
    return collectionView;
}

- (void)setBounces:(BOOL)bounces{
    _bounces = bounces;
    _collectionViewTopLeft.bounces = bounces;
    _collectionViewTopRight.bounces = bounces;
    _collectionViewBtmLeft.bounces = bounces;
    _collectionViewBtmRight.bounces = bounces;
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier{
    [self.collectionViewTopLeft registerClass:cellClass forCellWithReuseIdentifier:identifier];
    [self.collectionViewTopRight registerClass:cellClass forCellWithReuseIdentifier:identifier];
    [self.collectionViewBtmLeft registerClass:cellClass forCellWithReuseIdentifier:identifier];
    [self.collectionViewBtmRight registerClass:cellClass forCellWithReuseIdentifier:identifier];
    _collectionViewRegisterClassDic[identifier] = cellClass;
}

- (__kindof GGExcelBaseCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    UICollectionView *collectionView = nil;
    NSIndexPath *oIndexPath = nil;
    if (indexPath.row < self.fixedPath.row) {
        if (indexPath.section < self.fixedPath.section) {
            collectionView = _collectionViewTopLeft;
            oIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        }else{
            collectionView = _collectionViewBtmLeft;
            oIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - self.fixedPath.section];
        }
    }else{
        if (indexPath.section < self.fixedPath.section) {
            collectionView = _collectionViewTopRight;
            oIndexPath = [NSIndexPath indexPathForRow:indexPath.row - self.fixedPath.row inSection:indexPath.section];
        }else{
            collectionView = _collectionViewBtmRight;
            oIndexPath = [NSIndexPath indexPathForRow:indexPath.row - self.fixedPath.row inSection:indexPath.section - self.fixedPath.section];
        }
    }
    return [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:oIndexPath];
    
}

- (void)reloadData{
    [self.collectionViewTopLeft reloadData];
    [self.collectionViewTopRight reloadData];
    [self.collectionViewBtmLeft reloadData];
    [self.collectionViewBtmRight reloadData];
}

- (void)calculateFrames{
    _topLeftContentSize = ((GGExcelLayout *)_collectionViewTopLeft.collectionViewLayout).layoutContentSize;
    _topRightContentSize = ((GGExcelLayout *)_collectionViewTopRight.collectionViewLayout).layoutContentSize;
    _btmLeftContentSize = ((GGExcelLayout *)_collectionViewBtmLeft.collectionViewLayout).layoutContentSize;
    _btmRightContentSize = ((GGExcelLayout *)_collectionViewBtmRight.collectionViewLayout).layoutContentSize;
    
    _contentTotalWidth = MAX(_topLeftContentSize.width + _topRightContentSize.width, _btmLeftContentSize.width + _btmRightContentSize.width);
    _contentTotalHeight = MAX(_topLeftContentSize.height + _btmLeftContentSize.height, _topRightContentSize.height + _btmRightContentSize.height);
    CGFloat contentWidth = MIN(self.frame.size.width, _contentTotalWidth);
    CGFloat contentHeight = MIN(self.frame.size.height, _contentTotalHeight) ;
    
    self.contentView.frame = CGRectMake(0, 0, contentWidth, contentHeight);
    
    _fixedWidth = MAX(_topLeftContentSize.width, _btmLeftContentSize.width);
    _fixedHeight = MAX(_topLeftContentSize.height, _topRightContentSize.height);
    self.collectionViewTopLeft.frame = CGRectMake(0, 0, _fixedWidth, _fixedHeight);
    self.collectionViewTopRight.frame = CGRectMake(_fixedWidth, 0, contentWidth - _fixedWidth, _fixedHeight);
    self.collectionViewBtmLeft.frame = CGRectMake(0, _fixedHeight, _fixedWidth, contentHeight - _fixedHeight);
    self.collectionViewBtmRight.frame = CGRectMake(_fixedWidth, _fixedHeight, contentWidth - _fixedWidth, contentHeight - _fixedHeight);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self calculateFrames];
}

#pragma mark - UICollectionViewDataSource

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _collectionViewTopRight) {
        _collectionViewBtmRight.contentOffset = CGPointMake(scrollView.contentOffset.x, _collectionViewBtmRight.contentOffset.y);
    }else if (scrollView == _collectionViewBtmLeft) {
        _collectionViewBtmRight.contentOffset = CGPointMake(_collectionViewBtmRight.contentOffset.x, scrollView.contentOffset.y);
    }else if (scrollView == _collectionViewBtmRight){
        _collectionViewTopRight.contentOffset = CGPointMake(scrollView.contentOffset.x, _collectionViewTopRight.contentOffset.y);
        _collectionViewBtmLeft.contentOffset = CGPointMake(_collectionViewBtmLeft.contentOffset.x, scrollView.contentOffset.y);
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger sectionsCount = _sectionCount;
    if (_delegate && [_delegate respondsToSelector:@selector(numberOfSectionsInExcelView:)]) {
        sectionsCount = [_delegate numberOfSectionsInExcelView:self];
    }
    if (collectionView == _collectionViewTopLeft) {
        return MIN(sectionsCount, self.fixedPath.section);
    }else if (collectionView == _collectionViewTopRight){
        return MIN(sectionsCount, self.fixedPath.section);
    }else if (collectionView == _collectionViewBtmLeft){
        return sectionsCount - self.fixedPath.section;
    }else if (collectionView == _collectionViewBtmRight){
        return sectionsCount - self.fixedPath.section;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger rowCount = _rowCount;
    if (_delegate && [_delegate respondsToSelector:@selector(excelView:numberOfItemsInSection:)]) {
        rowCount = [_delegate excelView:self numberOfItemsInSection:section];
    }
    if (collectionView == _collectionViewTopLeft) {
        return self.fixedPath.row;
    }else if (collectionView == _collectionViewTopRight){
        return rowCount - self.fixedPath.row;
    }else if (collectionView == _collectionViewBtmLeft){
        return self.fixedPath.row;
    }else if (collectionView == _collectionViewBtmRight){
        return rowCount - self.fixedPath.row;
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize cellSize = _cellSize;
    if (_delegate && [_delegate respondsToSelector:@selector(excelView:sizeForCellAtIndexPath:)]) {
        NSIndexPath *aIndexPath = [self convertIndexPath:indexPath atCollectionView:collectionView];
        cellSize = [_delegate excelView:self sizeForCellAtIndexPath:aIndexPath];
    }
    return cellSize;
}

- (BOOL)collectionView:(UICollectionView *)collectionView hiddenForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(excelView:hiddenForItemAtIndexPath:)]) {
        NSIndexPath *aIndexPath = [self convertIndexPath:indexPath atCollectionView:collectionView];
        return [_delegate excelView:self hiddenForItemAtIndexPath:aIndexPath];
    }
    return NO;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GGExcelBaseCell *cell = nil;
    if (_delegate && [_delegate respondsToSelector:@selector(excelView:cellForItemAtIndexPath:)]) {
        NSIndexPath *aIndexPath = [self convertIndexPath:indexPath atCollectionView:collectionView];
        cell = [_delegate excelView:self cellForItemAtIndexPath:aIndexPath];
    }else{
        NSIndexPath *aIndexPath = [self convertIndexPath:indexPath atCollectionView:collectionView];
        cell = [self dequeueReusableCellWithReuseIdentifier:@"GGExcelBaseCellDefaultRegistration" forIndexPath:aIndexPath];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(excelView:didSelectItemAtIndexPath:)]) {
        NSIndexPath *aIndexPath = [self convertIndexPath:indexPath atCollectionView:collectionView];
        [_delegate excelView:self didSelectItemAtIndexPath:aIndexPath];
    }
}

- (NSIndexPath *)convertIndexPath:(NSIndexPath *)indexPath atCollectionView:(UICollectionView *)collectionView{
    if (collectionView == _collectionViewTopLeft) {
        return [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    }else if (collectionView == _collectionViewTopRight){
        return [NSIndexPath indexPathForRow:indexPath.row + self.fixedPath.row inSection:indexPath.section];
    }else if (collectionView == _collectionViewBtmLeft){
        return [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + self.fixedPath.section];
    }else if (collectionView == _collectionViewBtmRight){
        return [NSIndexPath indexPathForRow:indexPath.row + self.fixedPath.row inSection:indexPath.section + self.fixedPath.section];
    }
    return indexPath;
}

//Layout中计算的contentSize有更新
- (void)collectionView:(UICollectionView *)collectionView updateInContentSize:(CGSize)contentSize{
    [self calculateFrames];
}

- (void)outputImage:(void(^)(UIImage *))done{
    
    CGFloat viewHeight = 0;
    CGFloat viewWidth = 0;
    
    viewHeight += MAX(_topLeftContentSize.height, _topRightContentSize.height);
    viewHeight += MAX(_btmLeftContentSize.height, _btmRightContentSize.height);
    viewWidth += MAX(_topLeftContentSize.width + _topRightContentSize.width, _btmLeftContentSize.width + _btmRightContentSize.width);
    
    if (viewWidth == 0 || viewHeight == 0) {
        if (done) { done(nil);}
        return;
    }
    
    GGExcelView *excelView = [[GGExcelView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    excelView.delegate = self.delegate;
    excelView.cellSize = self.cellSize;
    excelView.fixedPath = self.fixedPath;
    excelView.sectionCount = self.sectionCount;
    excelView.rowCount = self.rowCount;
    for (NSString *ids in _collectionViewRegisterClassDic.allKeys) {
        [excelView registerClass:_collectionViewRegisterClassDic[ids] forCellWithReuseIdentifier:ids];
    }
    excelView.hidden = YES;
    [self.superview addSubview:excelView];
    __weak GGExcelView * weakExcelView = excelView;
    [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
        __strong GGExcelView * strongExcelView = weakExcelView;
        
        strongExcelView.hidden = NO;
        UIGraphicsBeginImageContextWithOptions(strongExcelView.frame.size, NO, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, -strongExcelView.frame.origin.x, -strongExcelView.frame.origin.y);
        [strongExcelView.layer renderInContext: context];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [strongExcelView removeFromSuperview];
        [timer invalidate];
        if (done) {
            done(image);
        }
    }];
}


@end
