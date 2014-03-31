//
//  NSObject+UIImage_ImageEffects.h
//  ChangTalk
//
//  Created by ctkj on 14-3-31.
//  Copyright (c) 2014年 ctkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (BlurEffects)

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end