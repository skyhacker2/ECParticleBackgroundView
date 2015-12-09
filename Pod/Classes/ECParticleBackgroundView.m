//
//  ECParticleBackgroundView.m
//  Pods
//
//  Created by Eleven Chen on 15/12/8.
//
//

#import "ECParticleBackgroundView.h"
#import "ECParticle.h"

CGFloat distance(CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2)
{
    return sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
}

@interface ECParticleBackgroundView()

@property (strong, nonatomic) CADisplayLink *displayLink;
@property (strong, nonatomic) NSMutableArray *particles;
@end

@implementation ECParticleBackgroundView

- (instancetype) init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup
{
    _particleNumber = 30;
    _particles = [NSMutableArray array];
    _particleColor = [UIColor blackColor];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(step)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self createParticles];
}

- (void) step
{
    for (int i = 0; i < _particleNumber; i++) {
        ECParticle* p = _particles[i];
        if (p.x <= 0 || p.x >= self.bounds.size.width) {
            p.d = CGPointMake(-p.d.x, p.d.y);
        }
        if (p.y <= 0 || p.y >= self.bounds.size.height) {
            p.d = CGPointMake(p.d.x, -p.d.y);
        }
        p.x += p.v * p.d.x;
        p.y += p.v * p.d.y;
    }
    [self setNeedsDisplay];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self createParticles];
}

- (void) setParticleNumber:(NSUInteger)particleNumber
{
    _particleNumber = particleNumber;
    [self createParticles];
}

- (void) createParticles
{
    if (self.bounds.size.width == 0 && self.bounds.size.height == 0) {
        return;
    }
    [_particles removeAllObjects];
    NSLog(@"width %f, height %f", self.frame.size.width, self.frame.size.height);
    for (int i = 0; i < _particleNumber; i++) {
        ECParticle *particle = [[ECParticle alloc] init];
        particle.r = arc4random() % 3 + 1;
        particle.x = arc4random() % (int)(self.frame.size.width-particle.r*2) + particle.r;
        particle.y = arc4random() % (int)(self.frame.size.height-particle.r*2) + particle.r;
        particle.v = (arc4random() % 5) / 10.0f + 0.1 ;
        particle.d = CGPointMake((arc4random() % 10) / 10.0f * (arc4random() % 2 == 1? -1 : 1) , (arc4random() % 10) / 10.0f * (arc4random() % 2 == 1? -1 : 1));
        [_particles addObject:particle];
    }
}


#define MAX_DIS (self.frame.size.width * 0.3)
- (void)drawRect:(CGRect)rect
{
    for (int i = 0; i < _particleNumber; i++) {
        ECParticle *p = _particles[i];
        UIBezierPath *point = [UIBezierPath bezierPathWithArcCenter:CGPointMake(p.x, p.y) radius:p.r startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        [_particleColor setFill];
        [point fill];
    }
    for (int i = 0; i < _particleNumber; i++) {
        ECParticle *p1 = _particles[i];
        for (int j = 0; j < _particleNumber; j++) {
            ECParticle *p2 = _particles[j];
            if (p1 != p2) {
                float dis=distance(p1.x, p1.y, p2.x, p2.y);
                if (dis <= MAX_DIS) {
                    // Draw a line from p1 to p2
                    UIBezierPath *line = [UIBezierPath bezierPath];
                    [line moveToPoint:CGPointMake(p1.x, p1.y)];
                    [line addLineToPoint:CGPointMake(p2.x, p2.y)];
                    line.lineWidth = 1;
                    float alpha = 1.0f - (dis / MAX_DIS);
                    UIColor *lineColor = [_particleColor colorWithAlphaComponent:alpha];
//                    UIColor *lineColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
                    [lineColor setStroke];
                    [line stroke];
                }
            }
        }
    }
}


@end
