//
//  UIView+Utils.m
//  KDCommonKit
//
//  Created by Ketil on 16/11/13.
//  Copyright © 2016年 fumi. All rights reserved.
//

#import "UIView+Utils.h"

#import <objc/runtime.h>

static char kKDActionHandlerTapBlockKey;
static char kKDActionHandlerTapGestureKey;
static char kKDActionHandlerLongPressBlockKey;
static char kKDActionHandlerLongPressGestureKey;

@implementation UIView (Utils)

- (CGFloat)left {
	return self.frame.origin.x;
}



- (void)setLeft:(CGFloat)x {
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}



- (CGFloat)top {
	return self.frame.origin.y;
}



- (void)setTop:(CGFloat)y {
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}



- (CGFloat)right {
	return self.frame.origin.x + self.frame.size.width;
}



- (void)setRight:(CGFloat)right {
	CGRect frame = self.frame;
	frame.origin.x = right - frame.size.width;
	self.frame = frame;
}



- (CGFloat)bottom {
	return self.frame.origin.y + self.frame.size.height;
}



- (void)setBottom:(CGFloat)bottom {
	CGRect frame = self.frame;
	frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}



- (CGFloat)centerX {
	return self.center.x;
}



- (void)setCenterX:(CGFloat)centerX {
	self.center = CGPointMake(centerX, self.center.y);
}



- (CGFloat)centerY {
	return self.center.y;
}



- (void)setCenterY:(CGFloat)centerY {
	self.center = CGPointMake(self.center.x, centerY);
}



- (CGFloat)width {
	return self.frame.size.width;
}



- (void)setWidth:(CGFloat)width {
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}



- (CGFloat)height {
	return self.frame.size.height;
}



- (void)setHeight:(CGFloat)height {
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}



- (CGFloat)screenX {
	CGFloat x = 0.0f;
	for (UIView* view = self; view; view = view.superview) {
		x += view.left;
	}
	return x;
}



- (CGFloat)screenY {
	CGFloat y = 0.0f;
	for (UIView* view = self; view; view = view.superview) {
		y += view.top;
	}
	return y;
}



- (CGFloat)screenViewX {
	CGFloat x = 0.0f;
	for (UIView* view = self; view; view = view.superview) {
		x += view.left;
		
		if ([view isKindOfClass:[UIScrollView class]]) {
			UIScrollView* scrollView = (UIScrollView*)view;
			x -= scrollView.contentOffset.x;
		}
	}
	
	return x;
}



- (CGFloat)screenViewY {
	CGFloat y = 0;
	for (UIView* view = self; view; view = view.superview) {
		y += view.top;
		
		if ([view isKindOfClass:[UIScrollView class]]) {
			UIScrollView* scrollView = (UIScrollView*)view;
			y -= scrollView.contentOffset.y;
		}
	}
	return y;
}



- (CGRect)screenFrame {
	return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}



- (CGPoint)origin {
	return self.frame.origin;
}



- (void)setOrigin:(CGPoint)origin {
	CGRect frame = self.frame;
	frame.origin = origin;
	self.frame = frame;
}



- (CGSize)size {
	return self.frame.size;
}



- (void)setSize:(CGSize)size {
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}



- (CGFloat)orientationWidth {
	return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
	? self.height : self.width;
}



- (CGFloat)orientationHeight {
	return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
	? self.width : self.height;
}



- (UIView*)descendantOrSelfWithClass:(Class)cls {
	if ([self isKindOfClass:cls])
	return self;
	
	for (UIView* child in self.subviews) {
		UIView* it = [child descendantOrSelfWithClass:cls];
		if (it)
		return it;
	}
	
	return nil;
}



- (UIView*)ancestorOrSelfWithClass:(Class)cls {
	if ([self isKindOfClass:cls]) {
		return self;
		
	} else if (self.superview) {
		return [self.superview ancestorOrSelfWithClass:cls];
		
	} else {
		return nil;
	}
}

-(void)exclusiveTouchForAllButtons
{
	for (UIView * subview in [self subviews]) {
		if([subview isKindOfClass:[UIButton class]])
		[((UIButton *)subview) setExclusiveTouch:YES];
		else if ([subview isKindOfClass:[UIView class]]){
			[subview exclusiveTouchForAllButtons];
		}
	}
}


- (void)removeAllSubviews {
	while (self.subviews.count) {
		UIView* child = self.subviews.lastObject;
		[child removeFromSuperview];
	}
}



- (CGPoint)offsetFromView:(UIView*)otherView {
	CGFloat x = 0.0f, y = 0.0f;
	for (UIView* view = self; view && view != otherView; view = view.superview) {
		x += view.left;
		y += view.top;
	}
	return CGPointMake(x, y);
}


- (void)setTapActionIsCancelsTouches:(BOOL)isCancel WithBlock:(void (^)(void))block
{
	UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kKDActionHandlerTapGestureKey);
	
	if (!gesture)
	{
		gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForTapGesture:)];
        gesture.cancelsTouchesInView = isCancel;
		[self addGestureRecognizer:gesture];
		objc_setAssociatedObject(self, &kKDActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
	}
	
	objc_setAssociatedObject(self, &kKDActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForTapGesture:(UITapGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateRecognized)
	{
		void(^action)(void) = objc_getAssociatedObject(self, &kKDActionHandlerTapBlockKey);
		
		if (action)
		{
			action();
		}
	}
}

- (void)setLongPressActionWithBlock:(void (^)(void))block
{
	UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &kKDActionHandlerLongPressGestureKey);
	
	if (!gesture)
	{
		gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForLongPressGesture:)];
		[self addGestureRecognizer:gesture];
		objc_setAssociatedObject(self, &kKDActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
	}
	
	objc_setAssociatedObject(self, &kKDActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForLongPressGesture:(UITapGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateBegan)
	{
		void(^action)(void) = objc_getAssociatedObject(self, &kKDActionHandlerLongPressBlockKey);
		
		if (action)
		{
			action();
		}
	}
}

- (void)setLayerShadow:(UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius {
	self.layer.shadowColor = color.CGColor;
	self.layer.shadowOffset = offset;
	self.layer.shadowRadius = radius;
	self.layer.shadowOpacity = 1;
	self.layer.shouldRasterize = YES;
	self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates {
	if (![self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
		return [self snapshotImage];
	}
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
	[self drawViewHierarchyInRect:self.bounds afterScreenUpdates:afterUpdates];
	UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return snap;
}

- (UIImage *)snapshotImage {
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return snap;
}

- (NSData *)snapshotPDF {
	CGRect bounds = self.bounds;
	NSMutableData *data = [NSMutableData data];
	CGDataConsumerRef consumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)data);
	CGContextRef context = CGPDFContextCreate(consumer, &bounds, NULL);
	CGDataConsumerRelease(consumer);
	if (!context) return nil;
	CGPDFContextBeginPage(context, NULL);
	CGContextTranslateCTM(context, 0, bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	[self.layer renderInContext:context];
	CGPDFContextEndPage(context);
	CGPDFContextClose(context);
	CGContextRelease(context);
	return data;
}

- (UIViewController *)viewController {
	for (UIView *view = self; view; view = view.superview) {
		UIResponder *nextResponder = [view nextResponder];
		if ([nextResponder isKindOfClass:[UIViewController class]]) {
			return (UIViewController *)nextResponder;
		}
	}
	return nil;
}

- (void)keyboardCanHide
{
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide)];
	[self addGestureRecognizer:tapGestureRecognizer];
}

- (void)keyboardHide
{
	[self endEditing:YES];
}
- (void)setMaskForCorner:(CGFloat)corner rectCorner:(UIRectCorner)rectCorner{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) byRoundingCorners:rectCorner cornerRadii:CGSizeMake(corner, corner)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}
@end
