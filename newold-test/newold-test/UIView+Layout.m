//
//  UIViewLayout.m
//  TravelSmartiOS
//
//  Created by Alisdair Mills on 12/12/2013.
//  Copyright (c) 2013 On-Sea. All rights reserved.
//

#import "UIView+Layout.h"

static void *imageCloneReadyPropertyKey = &imageCloneReadyPropertyKey;

@implementation UIView (Layout)

-(void)lockCenteredAboveView:(UIView *)view {
    float yPos = view.frame.origin.y - self.frame.origin.y;
    float xDiff = (view.frame.origin.y - self.frame.origin.y) / 2.0f;
    float xPos = view.frame.origin.x + xDiff;
    [self setPoint:CGPointMake(xPos, yPos)];
}

-(float)centerX {
    return self.frame.origin.x + (self.frame.size.width / 2.0f);
}

-(float)centerY {
    return self.frame.origin.y + (self.frame.size.height / 2.0f);
}

-(void)makeSquare:(float)s {
    [self setSize:CGSizeMake(s, s)];
}

-(void)makeCircle:(float)s {
    [self setSize:CGSizeMake(s, s)];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = s / 2.0f;
}

-(void)centerInParent {
    CGRect aRect = self.frame;
    float xPos = roundf((self.superview.frame.size.width - self.frame.size.width) / 2.0f);
    float yPos = roundf((self.superview.frame.size.height - self.frame.size.height) / 2.0f);
    aRect.origin.x = xPos;
    aRect.origin.y = yPos;
    self.frame = aRect;
}

-(void)positionAtParentPosition:(CGPoint)p anchor:(CGPoint)a {
    CGRect aRect = self.frame;
    float xPos = roundf((self.superview.frame.size.width * p.x) - (self.frame.size.width * a.x));
    float yPos = roundf((self.superview.frame.size.height * p.y) - (self.frame.size.height * a.y));
    aRect.origin.x = xPos;
    aRect.origin.y = yPos;
    self.frame = aRect;
}

-(void)positionAtParentRight {
    [self positionAtParentPosition:CGPointMake(1.0f, 0.0f) anchor:CGPointMake(1.0f, 0.0f)];
}

-(void)positionAtParentBottom {
    [self positionAtParentPosition:CGPointMake(0.0f, 1.0f) anchor:CGPointMake(0.0f, 1.0f)];
}

-(void)centerAtPoint:(CGPoint)p {
    CGRect aRect = self.frame;
    float xPos = roundf((p.x) - (self.frame.size.width / 2.0f));
    float yPos = roundf((p.y) - (self.frame.size.height / 2.0f));
    aRect.origin.x = xPos;
    aRect.origin.y = yPos;
    self.frame = aRect;
}

-(void)centerAtParentPosition:(CGPoint)p {
    CGRect aRect = self.frame;
    float xPos = roundf((self.superview.frame.size.width * p.x) - (self.frame.size.width / 2.0f));
    float yPos = roundf((self.superview.frame.size.height * p.y) - (self.frame.size.height / 2.0f));
    aRect.origin.x = xPos;
    aRect.origin.y = yPos;
    self.frame = aRect;
}

-(void)positionUnderView:(UIView *)aView withPadding:(float)padding {
    CGRect aRect = self.frame;
    float yPos = aView.frame.origin.y + aView.frame.size.height + padding;
    aRect.origin.y = yPos;
    self.frame = aRect;
}

-(void)positionAboveView:(UIView *)aView withPadding:(float)padding {
    CGRect aRect = self.frame;
    float yPos = aView.frame.origin.y - aRect.size.height - padding;
    aRect.origin.y = yPos;
    self.frame = aRect;
}

-(void)setY:(float)y {
    CGRect aRect = self.frame;
    aRect.origin.y = y;
    self.frame = aRect;
}

-(void)fillSpaceBetweenTop:(UIView *)topView bottom:(UIView *)bottomView {
    CGRect aRect = self.frame;
    float yPos = topView.frame.origin.y + topView.frame.size.height;
    float height = bottomView.frame.origin.y - yPos;
    aRect.origin.y = yPos;
    aRect.size.height = height;
    self.frame = aRect;
}

-(void)setX:(float)x {
    CGRect aRect = self.frame;
    aRect.origin.x = x;
    self.frame = aRect;
}

-(void)setPoint:(CGPoint)p {
    CGRect aRect = self.frame;
    aRect.origin.x = p.x;
    aRect.origin.y = p.y;
    self.frame = aRect;
}

-(void)fillParent {
    CGRect aRect = self.frame;
    aRect.size.width = self.superview.frame.size.width;
    aRect.size.height = self.superview.frame.size.height;
    self.frame = aRect;
}

-(void)setWidth:(float)w {
    CGRect aRect = self.frame;
    aRect.size.width = w;
    self.frame = aRect;
}

-(void)setHeight:(float)h {
    CGRect aRect = self.frame;
    aRect.size.height = h;
    self.frame = aRect;
}

-(void)fillParentWidth {
    CGRect aRect = self.frame;
    aRect.size.width = self.superview.frame.size.width;
    self.frame = aRect;
}

-(void)move:(CGPoint)p {
    CGRect aRect = self.frame;
    aRect.origin.x += p.x;
    aRect.origin.y += p.y;
    self.frame = aRect;
}

-(void)fillParentHeight {
    CGRect aRect = self.frame;
    aRect.size.height = self.superview.frame.size.height;
    self.frame = aRect;
}

-(void)setSize:(CGSize)size {
    CGRect aRect = self.frame;
    aRect.size.height = size.height;
    aRect.size.width = size.width;
    self.frame = aRect;
}

-(void)setRotation:(float)angle {
    CATransform3D transform = CATransform3DMakeRotation(angle, 0, 0, 1);
    self.layer.transform = transform;
}

-(UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(UIImage *)flippedImage {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [UIScreen mainScreen].scale);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0.0f, self.frame.size.height);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1.0, -1.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(UIImage *)backwardsImage {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [UIScreen mainScreen].scale);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), self.frame.size.width, 0.0f);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), -1.0, 1.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(float)sizeComparedTo6:(float)s even:(BOOL)even {
    float ratio = [UIScreen mainScreen].bounds.size.width / 375.0f;
    float result = roundf(ratio * s);
    if(even && (int)result % 2) result ++;
    return result;
}

-(float)sizeComparedTo5:(float)s even:(BOOL)even {
    float ratio = [UIScreen mainScreen].bounds.size.width / 320.0f;
    float result = roundf(ratio * s);
    if(even && (int)result % 2) result ++;
    return result;
}

-(float)keyboardHeight {
    if([[UIScreen mainScreen] scale] == 3.0) return 271.0f;
    if(self.frame.size.width == 320.0f) return 253.0f;
    return 258.0f;
}

-(void)set3DRotation:(float)angle {
    CATransform3D transform = CATransform3DMakeRotation(angle, 0, 1, 0);
    self.layer.transform = transform;
}

-(void)sizeToContain:(UIView *)view {
    float w = view.frame.origin.x + view.frame.size.width;
    if(w > self.frame.size.width) [self setWidth:w];
    float h = view.frame.origin.y + view.frame.size.height;
    if(h > self.frame.size.height) [self setHeight:h];
}

@end
