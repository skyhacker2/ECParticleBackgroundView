//
//  ECParticleBackgroundView.h
//  Pods
//
//  Created by Eleven Chen on 15/12/8.
//
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface ECParticleBackgroundView : UIView
@property (assign, nonatomic) IBInspectable NSUInteger particleNumber;
@property (strong, nonatomic) IBInspectable UIColor *particleColor;
@end
