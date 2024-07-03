//
//  GGViewController.m
//  GGToolKit
//
//  Created by yg on 01/16/2024.
//  Copyright (c) 2024 yg. All rights reserved.
//

#import "GGViewController.h"
#import "GGToolsHeader.h"

@interface GGViewController ()<GGExcelViewDelegate>

@end

@implementation GGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    GGExcelView *excelView = [[GGExcelView alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width - 20, 400)];
    excelView.contentView.layer.borderWidth = 1;
    excelView.contentView.layer.borderColor = [UIColor grayColor].CGColor;
    excelView.contentView.layer.cornerRadius = 7.5;
    excelView.contentView.layer.masksToBounds = YES;
    excelView.delegate = self;
    excelView.fixedPath = [NSIndexPath indexPathForRow:1 inSection:1];
    [self.view addSubview:excelView];
    [excelView registerClass:[GGExcelTextCell class] forCellWithReuseIdentifier:@"cell"];
    
//    [GGLoadingView showInView:self.view];
}

//返回一共有多少行
- (NSInteger)numberOfSectionsInExcelView:(GGExcelView *)excelView{
    return 100;
}

//返回每一行显示多少个Cell
- (NSInteger)excelView:(GGExcelView *)excelView numberOfItemsInSection:(NSInteger)section{
    return 70;
}

- (CGSize)excelView:(GGExcelView *)excelView sizeForCellAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(50, 25);
}

- (BOOL)excelView:(GGExcelView *)excelView hiddenForItemAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (GGExcelBaseCell *)excelView:(GGExcelView *)excelView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GGExcelTextCell *cell = [excelView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld-%ld",(long)indexPath.section,(long)indexPath.row];
    cell.separatorLeftScale = 0.5;
    cell.separatorRightScale = 0.5;
    cell.separatorTopScale = 0.5;
    cell.separatorBottomScale = 0.5;
    return cell;
}

- (void)excelView:(GGExcelView *)excelView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了 第%ld行 第%ld列",indexPath.section,indexPath.row);
}


@end
