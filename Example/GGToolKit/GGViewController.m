//
//  GGViewController.m
//  GGToolKit
//
//  Created by yyyggg on 04/13/2023.
//  Copyright (c) 2023 yyyggg. All rights reserved.
//

#import "GGViewController.h"
#import <Masonry/Masonry.h>
#import <GGToolKit/GGTools.h>
#import "GGRichTextView.h"

@interface GGViewController ()

@end

@implementation GGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    GGBlankPageLoading *view = [[GGBlankPageLoading alloc] init];
//    view.positionOffset = CGPointMake(0, 100);
//    view.position = GGBlankPageLoadingPositionTopCenter;
//    view.backgroundColor = [UIColor linkColor];
//    [self.view addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(100);
//        make.centerX.offset(0);
//        make.width.height.offset(100);
//    }];
    
//    self.view.backgroundColor = [UIColor whiteColor];
//
//    GGBlankPageEmpty *view = [[GGBlankPageEmpty alloc] init];
//    view.imageView.image = [UIImage imageNamed:@"nullImage"];
//    view.titleLabel.text = @"没有数据";
//    view.subTitleLabel.text = @"没有查询到数据，请更换搜索条件再试~";
//    [view.button setTitle:@"重试" forState:UIControlStateNormal];
//    view.position = GGBlankPageEmptyPositionCenter;
//    [self.view addSubview:view];
    

//	CAShapeLayer *layer = [CALayer gg_borderLayerWithFrame:CGRectMake(100, 100, 100, 100) lineWidth:1 strokeColor:[UIColor orangeColor] fillColor:[[UIColor grayColor] colorWithAlphaComponent:0.1] cornerRadius:15 lineDashPattern:@[@5]];
//	layer.backgroundColor = [UIColor clearColor].CGColor;
//	layer.path = [UIBezierPath bezierPathWithRoundedRect:layer.bounds cornerRadius:15].CGPath;
//	[self.view.layer addSublayer:layer];
//
//
//	CAGradientLayer *layer2 = [CALayer gg_gradientLayerWithFrame:CGRectMake(100.5, 100.5, 99, 99) direction:GGLayerGradientDirectionTopLeftToBottomRight colors:@[UIColor.redColor,UIColor.yellowColor,UIColor.greenColor] locations:@[@0,@0.5,@1.0]];
//	layer2.cornerRadius = 15;
//	[self.view.layer addSublayer:layer2];
//
//	CAShapeLayer *layer3 = [CALayer gg_lineLayerWithFrame:CGRectMake(100, 215, 100, 1) lineColor:UIColor.redColor isHorizonal:YES lineDashPattern:nil];
//	[self.view.layer addSublayer:layer3];
//    
//    GGGridView *gridView = [[GGGridView alloc] init];
//    gridView.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:gridView];
//    [gridView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.offset(0);
//        make.width.height.offset(300);
//    }];
//    
//    for (int i=0; i<25; i++) {
//        UIView *item = [[UIView alloc] init];
//        item.backgroundColor = [UIColor gg_randomColor];
//        [gridView insertItem:item];
//    }

//    GGRichTextView *textView = [[GGRichTextView alloc] init];
//    textView.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:textView];
//    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(100);
//        make.left.offset(24);
//        make.right.offset(-24);
//        make.bottom.offset(-100);
//    }];
//
//    [textView addText:@"测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文"];
//    [textView addImage:[UIImage imageNamed:@"TestImage"]];
//    [textView addText:@"测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文本测试文"];
//
//
//    [textView confitContentWithHtml:@"<h1>This is a title</h1><p>Here is some <strong>formatted</strong> text and an <img src=\"https://img2.woyaogexing.com/2023/06/11/39e604291dcc639c0172b7980d5f344d.jpg\" alt=\"example image\" /> image.</p><ul><li>List item 1</li><li>List item 2</li></ul>"];
    
    GGWeakSelf
    self.view.gg_blankPageEmpty = [GGBlankPageEmpty emptyWithImage:nil title:nil subTitle:@"未查询到数据，请更换搜索条件后再试~" buttonTitle:@"重试" click:^{
        [weakSelf requestError];
    }];
    self.view.gg_blankPageLoading = [GGBlankPageLoading loadingWithWithMessage:@"加载中" position:GGBlankPageLoadingPositionCenter offset:0];
    [self requestError];
}

- (void)requestError{
    [self.view gg_showLoading];
    GGWeakSelf
    [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf.view gg_showEmpty];
        [timer invalidate];
    }];
}

- (void)requestSucc{
    [self.view gg_showLoading];
    GGWeakSelf
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf.view gg_dismissAllBlankPage];
        [timer invalidate];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
