//
//  UIView+GGBlankPage.m
//  GGToolKit_Example
//
//  Created by yg on 2023/6/14.
//  Copyright © 2023 yyyggg. All rights reserved.
//

#import "UIView+GGBlankPage.h"
#import <objc/runtime.h>

@implementation UIView (GGBlankPage)

- (GGBlankPageComponent *)gg_blankPageLoading
{
    return objc_getAssociatedObject(self, @selector(gg_blankPageLoading));
}

- (void)setGg_blankPageLoading:(GGBlankPageComponent *)gg_blankPageLoading
{
    objc_setAssociatedObject(self, @selector(gg_blankPageLoading), gg_blankPageLoading, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GGBlankPageComponent *)gg_blankPageEmpty
{
    return objc_getAssociatedObject(self, @selector(gg_blankPageEmpty));
}

- (void)setGg_blankPageEmpty:(GGBlankPageComponent *)gg_blankPageEmpty
{
    objc_setAssociatedObject(self, @selector(gg_blankPageEmpty), gg_blankPageEmpty, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)gg_showLoading{
    [self.gg_blankPageEmpty removeFromSuperview];
    [self addSubview:self.gg_blankPageLoading];
    self.gg_blankPageLoading.alpha = 0;
    [UIView animateWithDuration:0.2 delay:NO options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.gg_blankPageLoading.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)gg_dismissLoading{
    [self.gg_blankPageLoading removeFromSuperview];
}

- (void)gg_showEmpty{
    [self.gg_blankPageLoading removeFromSuperview];
    [self addSubview:self.gg_blankPageEmpty];
    self.gg_blankPageEmpty.alpha = 0;
    [UIView animateWithDuration:0.2 delay:NO options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.gg_blankPageEmpty.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)gg_dismissEmpty{
    [self.gg_blankPageEmpty removeFromSuperview];
}

- (void)gg_dismissAllBlackPage{
    for (GGBlankPageComponent *temp in self.subviews) {
        [temp removeFromSuperview];
    }
}

@end
