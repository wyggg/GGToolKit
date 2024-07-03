//
//  GGScrollContainer.m
//  Operator
//
//  Created by yg on 2024/7/2.
//  Copyright © 2024 北京泰利玛营销顾问有限公司. All rights reserved.
//

#import "GGScrollContainer.h"

@interface GGScrollContainer()


@end


@implementation GGScrollContainer

@synthesize scrollView = _scrollView,contentView = _contentView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _direction = GGScrollContainerDirectionVertical;
    }
    return self;
}

- (void)addComponentSubview:(UIView *)view{
    [self.contentView addSubview:view];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIView *bottomView = nil;
    UIView *rightView = nil;
    CGSize contentSize = CGSizeMake(0, 0);
    for (UIView *view in self.subviews) {
        if (bottomView.frame.size.height + bottomView.frame.origin.y < view.frame.size.height + view.frame.origin.y) {
            bottomView = view;
        }
        if (rightView.frame.size.width + rightView.frame.origin.x < view.frame.size.width + view.frame.origin.x) {
            rightView = view;
        }
        contentSize.width = rightView.frame.size.width + rightView.frame.origin.x;
        contentSize.height = bottomView.frame.size.height + bottomView.frame.origin.y;
    }
    if (self.direction == GGScrollContainerDirectionAny) {
        self.scrollView.frame = self.bounds;
        self.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height);
        self.contentView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    }else if (self.gg_scrollDirection == GGScrollContainerDirectionVertical){
        self.scrollView.frame = self.bounds;
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, contentSize.height);
        self.contentView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);;
    }else if (self.gg_scrollDirection == GGScrollContainerDirectionHorizontal){
        self.scrollView.frame = self.bounds;
        self.scrollView.contentSize = CGSizeMake(contentSize.width, self.bounds.size.height);
        self.contentView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    }else{
        self.scrollView.frame = self.bounds;
        self.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height);
        self.contentView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    }
    
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if (@available(iOS 13.0, *)) {
            _scrollView.automaticallyAdjustsScrollIndicatorInsets = NO;
        }
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.scrollView addSubview:_contentView];
    }
    return _contentView;
}

@end
