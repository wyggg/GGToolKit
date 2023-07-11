//
//  GGViewController.m
//  GGToolKit
//
//  Created by yyyggg on 04/13/2023.
//  Copyright (c) 2023 yyyggg. All rights reserved.
//

#import "GGViewController.h"
#import <GGToolKit/GGTools.h>
#import "GGRichTextView.h"

@interface GGViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;


@end

@implementation GGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    GGWeakSelf
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view.backgroundColor = [UIColor grayColor];
    [view gg_setHighlightBackgroundWithColor:[UIColor redColor] showAnimationDuration:0.1 dismissAnimationDuration:0.15];
    [view gg_setHighlightZoomingScaleWithScale:0.95 showAnimationDuration:0.1 dismissAnimationDuration:0.15];
    [view gg_layerCornerRadius:10 masksToBounds:YES];
    [self.view addSubview:view];
    
    return;
    
    self.dataSource = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate  = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 45;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    UIButton *addDataButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addDataButton.frame = CGRectMake(100, 100, 100, 45);
    [addDataButton setTitle:@"添加数据" forState:UIControlStateNormal];
    [self.view addSubview:addDataButton];
    [addDataButton gg_addActionBlock:^(__kindof UIControl *weakSender) {
        [weakSelf.dataSource addObject:@""];
        [weakSelf.tableView reloadData];
    }];

    UIButton *removeDataButton = [UIButton buttonWithType:UIButtonTypeSystem];
    removeDataButton.frame = CGRectMake(100, 145, 100, 45);
    [removeDataButton setTitle:@"移除数据" forState:UIControlStateNormal];
    [self.view addSubview:removeDataButton];
    [removeDataButton gg_addActionBlock:^(__kindof UIControl *weakSender) {
        [weakSelf.dataSource removeAllObjects];
        [weakSelf.tableView reloadData];
    }];
    
    UIButton *removeViewButton = [UIButton buttonWithType:UIButtonTypeSystem];
    removeViewButton.frame = CGRectMake(100, 190, 100, 45);
    [removeViewButton setTitle:@"移除视图" forState:UIControlStateNormal];
    [self.view addSubview:removeViewButton];
    [removeViewButton gg_addActionBlock:^(__kindof UIControl *weakSender) {
        [weakSelf.tableView removeFromSuperview];
        weakSelf.tableView = nil;
    }];
    
    UIButton *requestButton = [UIButton buttonWithType:UIButtonTypeSystem];
    requestButton.frame = CGRectMake(100, 235, 100, 45);
    [requestButton setTitle:@"模拟请求" forState:UIControlStateNormal];
    [self.view addSubview:requestButton];
    [requestButton gg_addActionBlock:^(__kindof UIControl *weakSender) {
        [weakSelf requestError];
    }];
    
    [GGBlankPage bindScrollView:self.tableView inView:self.tableView mode:GGBlankPageBindModeCellTotal config:^GGBlankPageEmptyConfig *(GGBlankPageEmptyConfig *config) {
        config.title = @"默认标题";
        config.message = @"默认消息";
        config.restartButtonTitle = @"重试";
        config.restartButtonClick = ^{
            [weakSelf requestError];
        };
        return config;
    }];
    
//    __weak GGBlankPage *weakPage = weakSelf.tableView.gg_blankPage;
//    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"%@",weakPage);
//    }];
}

- (void)requestError{
    
    [GGBlankPage showLoadingInView:self.tableView config:^GGBlankPageLoadingConfig *(GGBlankPageLoadingConfig *config) {
        return config;
    }];
    GGWeakSelf
    [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [GGBlankPage dismissInView:weakSelf.tableView];
        [GGBlankPage configEmptyPageWithView:weakSelf.tableView config:^GGBlankPageEmptyConfig *(GGBlankPageEmptyConfig *config) {
            config.image = [UIImage imageNamed:@"nullImage"];
            config.title = @"网络请求失败";
            config.message = @"请重试";
            config.restartButtonClick = ^{
                [weakSelf requestError];
            };
            return config;
        }];
        [weakSelf.tableView reloadData];
        [timer invalidate];
    }];
}

- (void)requestSucc{
    [GGBlankPage showLoadingInView:self.tableView config:^GGBlankPageLoadingConfig *(GGBlankPageLoadingConfig *config) {
        config.message = @"加载中";
        return config;
    }];
    GGWeakSelf
    [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [GGBlankPage dismissInView:weakSelf.tableView];
        [timer invalidate];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
