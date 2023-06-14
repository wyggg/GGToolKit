//
//  UIView+GGBlankPage.h
//  GGToolKit_Example
//
//  Created by yg on 2023/6/14.
//  Copyright © 2023 yyyggg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGBlankPageComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (GGBlankPage)

@property (nonatomic, strong) GGBlankPageComponent *gg_blankPageLoading;
@property (nonatomic, strong) GGBlankPageComponent *gg_blankPageEmpty;

- (void)gg_showLoading;
- (void)gg_dismissLoading;
- (void)gg_showEmpty;
- (void)gg_dismissEmpty;
- (void)gg_dismissAllBlackPage;

@end

NS_ASSUME_NONNULL_END
