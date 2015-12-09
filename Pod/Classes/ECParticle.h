//
//  ECParticle.h
//  Pods
//
//  Created by Eleven Chen on 15/12/8.
//
//

#import <UIKit/UIKit.h>

@interface ECParticle : NSObject
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGPoint d;    // direction
@property (assign, nonatomic) CGFloat v;    // velocity
@property (assign, nonatomic) CGFloat r;    // radius
@end
