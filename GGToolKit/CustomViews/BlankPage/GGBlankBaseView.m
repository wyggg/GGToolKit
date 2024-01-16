//
//  GGBlankBaseView.m
//  GGToolKit
//
//  Created by yg on 2023/10/20.
//

#import "GGBlankBaseView.h"

#define QUERY_TAG 1008823132

@interface GGBlankBaseView()

@property (nonatomic, assign) GGBlankViewBindMode bindMode;
@property (nonatomic, assign) GGBlankViewDisplayStatus displayStatus;
@property (nonatomic, weak) UIScrollView *bindScrollView;
@property (nonatomic, strong) UIView *customView;

@end

@implementation GGBlankBaseView

@synthesize config = _config;

#pragma mark - Public Methods

+ (void)showInView:(UIView *)view configBlock:(GGBlankConfigBlock)configBlock{
    GGBlankBaseView *blankView = [view viewWithTag:QUERY_TAG];
    if (blankView == nil){
        blankView = [[self alloc] init];
    }
    [blankView showInView:view configBlock:configBlock];
}

+ (void)showInView:(UIView *)view custom:(UIView *)custom{
    GGBlankBaseView *blankView = [view viewWithTag:QUERY_TAG];
    if (blankView == nil){
        blankView = [[self alloc] init];
    }
    [blankView showInView:view custom:custom];
}

+ (void)dismissInView:(UIView *)view{
    GGBlankBaseView *blankView = [view viewWithTag:QUERY_TAG];
    if (blankView){
        [blankView removeFromSuperview];
    }
}

+ (void)bindScrollView:(UIScrollView *)scrollView inView:(UIView *)view mode:(GGBlankViewBindMode)mode configBlock:(GGBlankConfigBlock)configBlock{
    GGBlankBaseView *blankView = [scrollView viewWithTag:QUERY_TAG];
    if (blankView == nil){
        blankView = [[self alloc] init];
    }
    [blankView bindScrollView:scrollView inView:view mode:mode configBlock:configBlock];
}

+ (void)bindScrollView:(UIScrollView *)scrollView mode:(GGBlankViewBindMode)mode configBlock:(GGBlankConfigBlock)configBlock{
    GGBlankBaseView *blankView = [scrollView viewWithTag:QUERY_TAG];
    if (blankView == nil){
        blankView = [[self alloc] init];
    }
    [blankView bindScrollView:scrollView mode:mode configBlock:configBlock];
}

+ (void)bindScrollView:(UIScrollView *)scrollView inView:(UIView *)view mode:(GGBlankViewBindMode)mode custom:(UIView *)custom{
    GGBlankBaseView *blankView = [scrollView viewWithTag:QUERY_TAG];
    if (blankView == nil){
        blankView = [[self alloc] init];
    }
    [blankView bindScrollView:scrollView inView:view mode:mode custom:custom];
}

+ (void)bindScrollView:(UIScrollView *)scrollView mode:(GGBlankViewBindMode)mode custom:(UIView *)custom{
    GGBlankBaseView *blankView = [scrollView viewWithTag:QUERY_TAG];
    if (blankView == nil){
        blankView = [[self alloc] init];
    }
    [blankView bindScrollView:scrollView mode:mode custom:custom];
}

+ (void)unBingScrollViewInView:(UIView *)view{
    GGBlankBaseView *blankView = [view viewWithTag:QUERY_TAG];
    [blankView unBindScrollView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeUI];
    }
    return self;
}

- (__kindof GGBlankBaseConfig *)initializeConfig{
    GGBlankBaseConfig *config = [[GGBlankBaseConfig alloc] init];
    config.contentBackgroundColor = [UIColor grayColor];
    return config;
}

- (void)initializeUI{
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.frame = CGRectMake(self.config.contentInset.left,
                            self.config.contentInset.top,
                            self.superview.bounds.size.width - self.config.contentInset.left - self.config.contentInset.right,
                            self.superview.bounds.size.height - self.config.contentInset.top - self.config.contentInset.bottom);
    [self updateFrames:self.config];
}

- (void)updateFrames:(GGBlankBaseConfig *)baseConfig{
    if (self.customView){
        [self addSubview:baseConfig.customView];
        self.customView.frame = self.bounds;
    }
}

- (void)showInView:(UIView *)view configBlock:(GGBlankConfigBlock)configBlock{
    GGBlankBaseView *oldPageView = [view viewWithTag:QUERY_TAG];
    if (oldPageView){
        [oldPageView dismiss];
    }
    GGBlankBaseConfig *configModel = [self initializeConfig];
    if (configBlock){
        configModel = configBlock(configModel);
    }
    self.tag = QUERY_TAG;
    self.config = configModel;
    self.displayStatus = GGBlankViewDisplayStatusShow;
    [view addSubview:self];
}

- (void)showInView:(UIView *)view custom:(UIView *)custom{
    [self showInView:view configBlock:^__kindof GGBlankBaseConfig * _Nonnull(__kindof GGBlankBaseConfig * _Nonnull config) {
        config.customView = custom;
        return config;
    }];
}

- (void)dismiss{
    [self removeFromSuperview];
}

- (void)setConfig:(GGBlankBaseConfig *)config{
    _config = config;
    [self reloadData:config];
    [self updateFrames:config];
}

- (void)reloadData:(__kindof GGBlankBaseConfig *)baseConfig{
    self.customView = baseConfig.customView;
    self.backgroundColor = baseConfig.contentBackgroundColor;
}

- (void)setCustomView:(UIView *)customView{
    if (customView != _customView){
        [_customView removeFromSuperview];
    }
    _customView = customView;
    if (_customView != nil){
        [self addSubview:_customView];
    }
}

- (void)bindScrollView:(UIScrollView *)scrollView inView:(UIView *)view mode:(GGBlankViewBindMode)mode configBlock:(GGBlankConfigBlock)configBlock{
    [self unBindScrollView];
    [self showInView:view configBlock:configBlock];
    if ([scrollView isKindOfClass:[UITableView class]] || [scrollView isKindOfClass:[UICollectionView class]]){
        _bindScrollView = scrollView;
        self.bindMode = mode;
        [self.bindScrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        [self configBindState];
    }else{
        NSLog(@"绑定失败，传入的对象不是UITableView或UICollectionView");
    }
}

- (void)bindScrollView:(UIScrollView *)scrollView mode:(GGBlankViewBindMode)mode configBlock:(GGBlankConfigBlock)configBlock{
    [self bindScrollView:scrollView inView:scrollView mode:mode configBlock:configBlock];
}

- (void)bindScrollView:(UIScrollView *)scrollView inView:(UIView *)view mode:(GGBlankViewBindMode)mode custom:(UIView *)custom{
    [self bindScrollView:scrollView inView:view mode:mode configBlock:^GGBlankBaseConfig *(GGBlankBaseConfig *config) {
        config.customView = custom;
        return config;
    }];
}

- (void)bindScrollView:(UIScrollView *)scrollView mode:(GGBlankViewBindMode)mode custom:(UIView *)custom{
    [self bindScrollView:scrollView inView:scrollView mode:mode configBlock:^GGBlankBaseConfig *(GGBlankBaseConfig *config) {
        config.customView = custom;
        return config;
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        [self configBindState];
    }
}

- (void)configBindState{
    if ([self isThereContent] == NO){
        self.displayStatus = GGBlankViewDisplayStatusShow;
    }else{
        self.displayStatus = GGBlankViewDisplayStatusHidden;
    }
}

- (void)setDisplayStatus:(GGBlankViewDisplayStatus)displayStatus{
    _displayStatus = displayStatus;
    if (displayStatus == GGBlankViewDisplayStatusShow){
        self.hidden = NO;
    }else if (displayStatus == GGBlankViewDisplayStatusHidden){
        self.hidden = YES;
    }
}

- (void)unBindScrollView{
    if (_bindScrollView){
        [self.bindScrollView removeObserver:self forKeyPath:@"contentSize"];
        _bindScrollView = nil;
    }
}

//查询绑定的视图数据源
- (BOOL)isThereContent{
    if (self.bindMode == GGBlankViewBindModeSectionsTotal){
        if ([self.bindScrollView isKindOfClass:[UITableView class]]){
            UITableView *tableView = (UITableView *)self.bindScrollView;
            if ([tableView numberOfSections]){
                return YES;
            }
        }else if ([self.bindScrollView isKindOfClass:[UICollectionView class]]){
            UICollectionView *collectionView = (UICollectionView *)self.bindScrollView;
            if ([collectionView numberOfSections]){
                return YES;
            }
        }
    }else if (self.bindMode == GGBlankViewBindModeCellTotal){
        if ([self.bindScrollView isKindOfClass:[UITableView class]]){
            UITableView *tableView = (UITableView *)self.bindScrollView;
            NSInteger sections  = [tableView numberOfSections];
            for (int i=0; i<sections; i++) {
                if (tableView.dataSource && [tableView.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]){
                    NSInteger rowCount = [tableView.dataSource tableView:tableView numberOfRowsInSection:i];
                    if (rowCount > 0){
                        return YES;
                    }
                }
            }
        }else if ([self.bindScrollView isKindOfClass:[UICollectionView class]]){
            UICollectionView *collectionView = (UICollectionView *)self.bindScrollView;
            NSInteger sections  = [collectionView numberOfSections];
            for (int i=0; i<sections; i++) {
                if (collectionView.dataSource && [collectionView.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]){
                    NSInteger rowCount = [collectionView.dataSource collectionView:collectionView numberOfItemsInSection:i];
                    if (rowCount > 0){
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
}

- (BOOL)isCellExistAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        return YES;
    } else {
        return NO;
    }
}

- (void)dealloc{
    [self unBindScrollView];
}

- (void)removeFromSuperview{
    [super removeFromSuperview];
    [self unBindScrollView];
}


@end

@implementation GGBlankBaseConfig

@end
