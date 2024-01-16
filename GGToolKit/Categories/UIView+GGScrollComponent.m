//
//  UIView+GGScrollComponent.m
//  unzip
//
//  Created by yg on 2021/11/27.
//

#import "UIView+GGScrollComponent.h"
#import "NSObject+GG.h"

@implementation UIView (GGScrollComponent)

- (void)gg_updateLayoutWihtRight:(CGFloat)right bottom:(CGFloat)bottom{
	self.gg_scrollView.frame = self.bounds;
	if (self.gg_scrollDirection == GGScrollComponentDirectionAny) {
		self.gg_scrollView.contentSize = CGSizeMake(right, bottom);
		self.gg_contentView.frame = CGRectMake(0, 0, self.gg_scrollView.contentSize.width, self.gg_scrollView.contentSize.height);
	}else if (self.gg_scrollDirection == GGScrollComponentDirectionVertical){
		self.gg_scrollView.contentSize = CGSizeMake(self.bounds.size.width, bottom);
		self.gg_contentView.frame = CGRectMake(0, 0, self.gg_scrollView.contentSize.width, self.gg_scrollView.contentSize.height);
	}else if (self.gg_scrollDirection == GGScrollComponentDirectionHorizontal){
		self.gg_scrollView.contentSize = CGSizeMake(right, self.bounds.size.height);
		self.gg_contentView.frame = CGRectMake(0, 0, self.gg_scrollView.contentSize.width, self.gg_scrollView.contentSize.height);
	}else{
		self.gg_scrollView.contentSize = CGSizeMake(right, bottom);
		self.gg_contentView.frame = CGRectMake(0, 0, self.gg_scrollView.contentSize.width, self.gg_scrollView.contentSize.height);
	}
}

static const void *GGScrollComponentContentView = &GGScrollComponentContentView;
- (GGScrollContentView *)gg_contentView{
	GGScrollContentView *contentView = objc_getAssociatedObject(self, GGScrollComponentContentView);
	if (contentView == nil) {
		contentView = [[GGScrollContentView alloc] init];
		contentView.backgroundColor = [UIColor clearColor];
		[self.gg_scrollView addSubview:contentView];
		
		__weak typeof(self) weakSelf = self;
		contentView.didLayoutSubViewsBlock = ^(CGFloat right,CGFloat bottom) {
			[weakSelf gg_updateLayoutWihtRight:right bottom:bottom];
		};
		
		objc_setAssociatedObject(self, GGScrollComponentContentView, contentView, OBJC_ASSOCIATION_RETAIN);
	}
	return objc_getAssociatedObject(self, GGScrollComponentContentView);
}

static const void *GGScrollComponentScrollView = &GGScrollComponentScrollView;
- (UIScrollView *)gg_scrollView{
	UIScrollView *scrollView = objc_getAssociatedObject(self, GGScrollComponentScrollView);
	if (scrollView == nil) {
		scrollView = [[UIScrollView alloc] init];
		scrollView.backgroundColor = [UIColor clearColor];
		[self addSubview:scrollView];
		
		if (@available(iOS 11.0, *)) {
			scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
		} else {
			if (@available(iOS 13.0, *)) {
				scrollView.automaticallyAdjustsScrollIndicatorInsets = NO;
			}
		}
		
		objc_setAssociatedObject(self, GGScrollComponentScrollView, scrollView, OBJC_ASSOCIATION_RETAIN);
	}
	return scrollView;
}

- (void)setGg_scrollDirection:(GGScrollComponentDirection)gg_scrollDirection{
	objc_setAssociatedObject(self, "GGScrollComponentDirectionKey", [NSString stringWithFormat:@"%ld",(long)gg_scrollDirection], OBJC_ASSOCIATION_COPY_NONATOMIC);
	[self.gg_contentView layoutSubviews];
}

- (GGScrollComponentDirection)gg_scrollDirection{
	return [objc_getAssociatedObject(self, "GGScrollComponentDirectionKey") integerValue];
}

@end

@implementation GGScrollContentView : UIView

- (void)layoutIfNeeded{
	[super layoutIfNeeded];
}

- (void)layoutSubviews{
	[super layoutSubviews];
	UIView *bottomView = nil;
	UIView *rightView = nil;
	for (UIView *view in self.subviews) {
		if (bottomView.frame.size.height + bottomView.frame.origin.y < view.frame.size.height + view.frame.origin.y) {
			bottomView = view;
		}
		if (rightView.frame.size.width + rightView.frame.origin.x < view.frame.size.width + view.frame.origin.x) {
			rightView = view;
		}
	}
	
	if (_currentBottom != bottomView.frame.size.height + bottomView.frame.origin.y || _currentRight != rightView.frame.size.width + rightView.frame.origin.x) {
		_currentBottom = bottomView.frame.size.height + bottomView.frame.origin.y;
		_currentRight = rightView.frame.size.width + rightView.frame.origin.x;
		if (self.didLayoutSubViewsBlock) {
			self.didLayoutSubViewsBlock(_currentRight,_currentBottom);
		}
	}
}

@end

