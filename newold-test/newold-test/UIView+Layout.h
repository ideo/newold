//
//  UIViewLayout.h
//  TravelSmartiOS
//
//  Created by Alisdair Mills on 12/12/2013.
//  Copyright (c) 2013 On-Sea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface UIView (Layout)

-(void)centerInParent;
-(void)centerAtParentPosition:(CGPoint)p;
-(void)positionUnderView:(UIView *)aView withPadding:(float)padding;
-(void)positionAboveView:(UIView *)aView withPadding:(float)padding;
-(void)positionAtParentPosition:(CGPoint)p anchor:(CGPoint)a;
-(void)positionAtParentBottom;
-(void)positionAtParentRight;
-(void)setY:(float)y;
-(void)setX:(float)x;
-(void)setPoint:(CGPoint)p;
-(void)fillParent;
-(void)setWidth:(float)w;
-(void)setHeight:(float)h;
-(void)fillParentWidth;
-(void)fillParentHeight;
-(void)setSize:(CGSize)size;
-(void)setRotation:(float)angle;
-(void)move:(CGPoint)p;
-(void)fillSpaceBetweenTop:(UIView *)topView bottom:(UIView *)bottomView;
-(UIImage *)image;
-(float)sizeComparedTo6:(float)s even:(BOOL)even;
-(float)sizeComparedTo5:(float)s even:(BOOL)even;
-(float)keyboardHeight;
-(void)makeSquare:(float)s;
-(void)makeCircle:(float)s;
-(float)centerX;
-(float)centerY;
-(UIImage *)backwardsImage;
-(UIImage *)flippedImage;
-(void)set3DRotation:(float)angle;
-(void)centerAtPoint:(CGPoint)p;
-(void)lockCenteredAboveView:(UIView *)view;
-(void)sizeToContain:(UIView *)view;

@end
