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

@interface GGViewController ()

@end

@implementation GGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	CAShapeLayer *layer = [CALayer gg_borderLayerWithFrame:CGRectMake(100, 100, 100, 100) lineWidth:1 strokeColor:[UIColor orangeColor] fillColor:[[UIColor grayColor] colorWithAlphaComponent:0.1] cornerRadius:15 lineDashPattern:@[@5]];
	layer.backgroundColor = [UIColor clearColor].CGColor;
	layer.path = [UIBezierPath bezierPathWithRoundedRect:layer.bounds cornerRadius:15].CGPath;
	[self.view.layer addSublayer:layer];


	CAGradientLayer *layer2 = [CALayer gg_gradientLayerWithFrame:CGRectMake(100.5, 100.5, 99, 99) direction:GGLayerGradientDirectionTopLeftToBottomRight colors:@[UIColor.redColor,UIColor.yellowColor,UIColor.greenColor] locations:@[@0,@0.5,@1.0]];
	layer2.cornerRadius = 15;
	[self.view.layer addSublayer:layer2];

	CAShapeLayer *layer3 = [CALayer gg_lineLayerWithFrame:CGRectMake(100, 215, 100, 1) lineColor:UIColor.redColor isHorizonal:YES lineDashPattern:nil];
	[self.view.layer addSublayer:layer3];
    
    GGGridView *gridView = [[GGGridView alloc] init];
    gridView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:gridView];
    [gridView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
        make.width.height.offset(300);
    }];
    
    for (int i=0; i<25; i++) {
        UIView *item = [[UIView alloc] init];
        item.backgroundColor = [UIColor gg_randomColor];
        [gridView insertItem:item];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
