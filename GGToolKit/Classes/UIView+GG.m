	//
	//  UIView+GG.m
	//  unzip
	//
	//  Created by yg on 2021/11/15.
	//

#import "UIView+GG.h"
#import <objc/runtime.h>

#define LINEVIEWTAG 139003

@implementation UIView (GG)

//absoluteFrame:相对于屏幕坐标系的frame
- (CGRect)gg_absoluteFrame{
	return [self convertRect:self.bounds toView:nil];
}

- (CGFloat)gg_left {
	return self.frame.origin.x;
}
- (void)setGg_left:(CGFloat)gg_x {
	CGRect frame = self.frame;
	frame.origin.x = gg_x;
	self.frame = frame;
}

- (CGFloat)gg_top {
	return self.frame.origin.y;
}

- (void)setGg_top:(CGFloat)gg_top {
	CGRect frame = self.frame;
	frame.origin.y = gg_top;
	self.frame = frame;
}

- (CGFloat)gg_right {
	return self.frame.origin.x + self.gg_width;
}
- (void)setGg_right:(CGFloat)gg_right {
	CGRect frame = self.frame;
	frame.origin.x = gg_right - frame.size.width;
	self.frame = frame;
}

- (CGFloat)gg_bottom {
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setGg_bottom:(CGFloat)gg_bottom {
	CGRect frame = self.frame;
	frame.origin.y = gg_bottom - frame.size.height;
	self.frame = frame;
}

- (CGFloat)gg_centerX {
	return self.center.x;
}

- (void)setGg_centerX:(CGFloat)gg_centerX {
	self.center = CGPointMake(gg_centerX, self.center.y);
}

- (CGFloat)gg_centerY {
	return self.center.y;
}

- (void)setGg_centerY:(CGFloat)gg_centerY {
	self.center = CGPointMake(self.center.x, gg_centerY);
}

- (CGFloat)gg_width {
	return self.frame.size.width;
}

- (void)setGg_width:(CGFloat)gg_width {
	CGRect frame = self.frame;
	frame.size.width = gg_width;
	self.frame = frame;
}

- (CGFloat)gg_height {
	return self.frame.size.height;
}

- (void)setGg_height:(CGFloat)gg_height {
	CGRect frame = self.frame;
	frame.size.height = gg_height;
	self.frame = frame;
}

- (CGPoint)gg_origin {
	return self.frame.origin;
}

- (void)setGg_origin:(CGPoint)gg_origin {
	CGRect frame = self.frame;
	frame.origin = gg_origin;
	self.frame = frame;
}

- (CGSize)gg_size {
	return self.frame.size;
}

- (void)setGg_size:(CGSize)gg_size {
	CGRect frame = self.frame;
	frame.size = gg_size;
	self.frame = frame;
}


/**
 移除所有子视图
 */
- (void)gg_removeAllSubviews {
	NSArray *array = self.subviews;
	for (UIView *temp in array) {
		[temp removeFromSuperview];
	}
}


/**
 当前View的ViewController
 */
- (UIViewController *)gg_viewController {
	for (UIView *view = self; view; view = view.superview) {
		UIResponder *nextResponder = [view nextResponder];
		if ([nextResponder isKindOfClass:[UIViewController class]]) {
			return (UIViewController *)nextResponder;
		}
	}
	return nil;
}

/**
 *  @brief  view截图
 *
 *  @return 截图
 */
- (UIImage *)gg_imageWithIsScroll:(BOOL)isScroll{
	if (isScroll && [self isKindOfClass:[UIScrollView class]]) {
		UIImage *image = nil;
		UIScrollView *scrollView = (UIScrollView *)self;
		UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, 0.0);
		{
			CGPoint savedContentOffset = scrollView.contentOffset;
			CGRect savedFrame = scrollView.frame;
			scrollView.frame = CGRectMake(0 , 0, scrollView.contentSize.width, scrollView.contentSize.height);

			[scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
			image = UIGraphicsGetImageFromCurrentImageContext();

			scrollView.contentOffset = savedContentOffset;
			scrollView.frame = savedFrame;
		}
		UIGraphicsEndImageContext();
		return image;
	}else{
		UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
		if( [self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
		{
			[self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
		}
		else
		{
			[self.layer renderInContext:UIGraphicsGetCurrentContext()];
		}

		UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return screenshot;
	}

}

- (void)gg_layerBorderWidth:(CGFloat )width
					  color:(UIColor *)color{
	self.layer.borderColor = color.CGColor;
	self.layer.borderWidth = width;
}

/**
 *  设置阴影
 */
-(void)gg_layerShadowColor: (UIColor *)color
					offset: (CGSize)offset
				   opacity: (CGFloat)opacity
					radius: (CGFloat)radius
{
	self.clipsToBounds = NO;
	self.layer.shadowColor = color.CGColor;
	self.layer.shadowOffset = offset;
	self.layer.shadowOpacity = opacity;
	self.layer.shadowRadius = radius;
}

- (void)gg_layerCornerRadius: (CGFloat)radius masksToBounds:(BOOL)masksToBounds{
	self.layer.cornerRadius = radius;
	self.layer.masksToBounds = masksToBounds;
}

@end


static char kActionHandlerTapBlockKey;
static char kActionHandlerTapGestureKey;
static char kActionHandlerLongPressBlockKey;
static char kActionHandlerLongPressGestureKey;

@implementation UIView (GGGestures)

- (void)gg_addTapActionWithBlock:(GestureActionBlock)block{
	self.userInteractionEnabled = YES;
	UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kActionHandlerTapGestureKey);
	if (!gesture)
	{
		gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
		[self addGestureRecognizer:gesture];
		objc_setAssociatedObject(self, &kActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
	}
	objc_setAssociatedObject(self, &kActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForTapGesture:(UITapGestureRecognizer*)gesture{

	if (gesture.state == UIGestureRecognizerStateRecognized)
	{
		GestureActionBlock block = objc_getAssociatedObject(self, &kActionHandlerTapBlockKey);
		if (block)
		{
			block(gesture);
		}
	}
}
- (void)gg_addLongPressActionWithBlock:(GestureActionBlock)block
{
	self.userInteractionEnabled = YES;
	UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &kActionHandlerLongPressGestureKey);
	if (!gesture)
	{
		gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForLongPressGesture:)];
		[self addGestureRecognizer:gesture];
		objc_setAssociatedObject(self, &kActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
	}
	objc_setAssociatedObject(self, &kActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForLongPressGesture:(UITapGestureRecognizer*)gesture
{
	if (gesture.state == UIGestureRecognizerStateRecognized)
	{
		GestureActionBlock block = objc_getAssociatedObject(self, &kActionHandlerLongPressBlockKey);
		if (block)
		{
			block(gesture);
		}
	}
}

@end



@implementation UIView (GGGradientBackground)

static char kGradientLayerKey;

- (void)setGradientLayer:(CAGradientLayer *)gradientLayer {
	objc_setAssociatedObject(self, &kGradientLayerKey, gradientLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAGradientLayer *)gradientLayer {
	return objc_getAssociatedObject(self, &kGradientLayerKey);
}

- (void)gg_setGradientBackgroundWithColors:(NSArray<UIColor *> *)colors direction:(GradientDirection)direction viewSize:(CGSize)viewSize{
	if (!self.gradientLayer) {
		self.gradientLayer = [CAGradientLayer layer];
		[self.layer insertSublayer:self.gradientLayer atIndex:0];
	}
	self.gradientLayer.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
	self.gradientLayer.startPoint = [self startPointForDirection:direction];
	self.gradientLayer.endPoint = [self endPointForDirection:direction];
	NSMutableArray *cgColors = [NSMutableArray arrayWithCapacity:colors.count];
	for (UIColor *color in colors) {
		[cgColors addObject:(id)color.CGColor];
	}
	self.gradientLayer.colors = cgColors;
	[self.layer insertSublayer:self.gradientLayer atIndex:0];
}

- (void)gg_setGradientBackgroundWithColors:(NSArray<UIColor *> *)colors direction:(GradientDirection)direction{
	[self gg_setGradientBackgroundWithColors:colors direction:direction viewSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
}

- (void)gg_updateGradientLayerLayout{
	[self layoutIfNeeded];
	self.frame = self.frame;
}


// 根据方向参数返回起始点坐标
- (CGPoint)startPointForDirection:(GradientDirection)direction
{
	switch (direction) {
		case GradientDirectionTopToBottom:
			return CGPointMake(0, 0);
		case GradientDirectionLeftToRight:
			return CGPointMake(0, 0);
		case GradientDirectionBottomToTop:
			return CGPointMake(0, 1);
		case GradientDirectionRightToLeft:
			return CGPointMake(1, 0);
		default:
			return CGPointMake(0, 0);
	}
}

	// 根据方向参数返回结束点坐标
- (CGPoint)endPointForDirection:(GradientDirection)direction
{
	switch (direction) {
		case GradientDirectionTopToBottom:
			return CGPointMake(0, 1);
		case GradientDirectionLeftToRight:
			return CGPointMake(1, 0);
		case GradientDirectionBottomToTop:
			return CGPointMake(0, 0);
		case GradientDirectionRightToLeft:
			return CGPointMake(0, 1);
		default:
			return CGPointMake(1, 1);
	}
}

@end

@implementation GGLineView

- (void)setLineColor:(UIColor *)lineColor{
	_lineColor = lineColor;
	[self layoutIfNeeded];
	[self setNeedsDisplayInRect:self.bounds];
}

- (void)setDashArray:(NSArray *)dashArray{
	_dashArray = dashArray;
	[self layoutIfNeeded];
	[self setNeedsDisplayInRect:self.bounds];
}

- (void)drawRect:(CGRect)rect{

	int direction = (int)(rect.size.width > rect.size.height);//1横向 0纵向
	CGFloat lineWidth = rect.size.width > rect.size.height ? rect.size.width : rect.size.height;

	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextSetLineWidth(context, lineWidth);

	CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);

	CGFloat dashArray[self.dashArray.count];
	for (int i=0; i<_dashArray.count; i++) {
		dashArray[i] = [self.dashArray[i] intValue];
	}
	CGContextSetLineDash(context, 0, dashArray, self.dashArray.count);

	if (direction == 1) {
		CGContextMoveToPoint(context, 0, rect.size.height / 2);
		CGContextAddQuadCurveToPoint(context, 0, rect.size.height / 2, rect.size.width, rect.size.height / 2);
	}else{
		CGContextMoveToPoint(context, rect.size.width / 2, 0);
		CGContextAddQuadCurveToPoint(context, rect.size.width / 2, 0, rect.size.width / 2, rect.size.height);
	}

	CGContextStrokePath(context);
}


@end



@implementation UIView (GGList)

- (void)gg_removeAllSubLineView{
	[self gg_removeSubLineViewBydirection:GGLineViewDirectionLeft];
	[self gg_removeSubLineViewBydirection:GGLineViewDirectionRight];
	[self gg_removeSubLineViewBydirection:GGLineViewDirectionTop];
	[self gg_removeSubLineViewBydirection:GGLineViewDirectionBottom];
}

- (void)gg_removeSubLineViewBydirection:(GGLineViewDirection)direction{
	NSInteger tag = LINEVIEWTAG + direction;
	[[self viewWithTag:tag] removeFromSuperview];
}

- (GGLineView *_Nullable)gg_addBottomLineWithColor:(UIColor *)color margin:(CGFloat)margin{
	return [self gg_addSubLineViewByBorderWidth:1 borderColor:color offset:0 margin:margin dashArray:@[@"1",@"0"] direction:GGLineViewDirectionBottom];
}

- (GGLineView *)gg_addSubLineViewByBorderWidth:(CGFloat)borderWidth
								   borderColor:(UIColor *_Nullable)borderColor
										offset:(CGFloat)offset
										margin:(CGFloat)margin
									 dashArray:(NSArray *_Nullable)dashArray
									 direction:(GGLineViewDirection)direction{
	if (dashArray == nil) {
		dashArray = @[@"1",@"0"];
	}
	NSInteger tag = LINEVIEWTAG + direction;
	GGLineView *lineView = [self viewWithTag:tag];
	[lineView removeFromSuperview];
	if (lineView == nil) {
		lineView = [[GGLineView alloc] init];
		lineView.tag = tag;
	}
	[self addSubview:lineView];

	lineView.backgroundColor = [UIColor clearColor];
	lineView.lineColor = borderColor;
	lineView.dashArray = dashArray;

	lineView.translatesAutoresizingMaskIntoConstraints = NO;
	NSLayoutConstraint *top,*left,*right,*bottom,*width,*height;
	if (direction == GGLineViewDirectionLeft) {
		top = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:margin];
		bottom = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-margin];
		width = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:borderWidth];
		left = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:offset];
		[self addConstraints:@[top,bottom,left]];
		[lineView addConstraints:@[width]];
	}else if (direction == GGLineViewDirectionRight){
		top = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:margin];
		bottom = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-margin];
		width = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:borderWidth];
		right = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-offset];
		[self addConstraints:@[top,bottom,right]];
		[lineView addConstraints:@[width]];
	}else if (direction == GGLineViewDirectionTop){
		top = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:offset];
		left = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:margin];
		right = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-margin];
		height = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:borderWidth];
		[self addConstraints:@[top,left,right]];
		[lineView addConstraints:@[height]];
	}else if (direction == GGLineViewDirectionBottom){
		bottom = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-offset];
		left = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:margin];
		right = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-margin];
		height = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:borderWidth];
		[self addConstraints:@[bottom,left,right]];
		[lineView addConstraint:height];
	}
	[lineView layoutIfNeeded];
	return lineView;
}


@end


