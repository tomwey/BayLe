//
//  AWCaret.m
//  BayLe
//
//  Created by tangwei1 on 15/11/20.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "AWCaret.h"

@implementation AWCaret

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ( self = [super initWithCoder:aDecoder] ) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    
    _fillColor = [[UIColor whiteColor] retain];
    _direction = CaretDirectionBottom;
}

- (void)dealloc
{
    [_fillColor release];
    
    [super dealloc];
}

- (void)setDirection:(CaretDirection)direction
{
    _direction = direction;
    
    [self setNeedsDisplay];
}

- (void)setFillColor:(UIColor *)fillColor
{
    if ( _fillColor == fillColor ) {
        return;
    }
    
    [_fillColor release];
    _fillColor = [fillColor retain];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGPoint firstPoint, secondPoint, threePoint;
    switch (_direction) {
        case CaretDirectionTop:
        {
            firstPoint.x = 0;
            firstPoint.y = height;
            
            secondPoint.x = width / 2;
            secondPoint.y = 0;
            
            threePoint.x  = width;
            threePoint.y  = height;
        }
            break;
        case CaretDirectionBottom:
        {
            firstPoint.x = 0;
            firstPoint.y = 0;
            
            secondPoint.x = width;
            secondPoint.y = 0;
            
            threePoint.x  = width / 2;
            threePoint.y  = height;
        }
            break;
            
        default:
            break;
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, firstPoint.x, firstPoint.y);
    CGPathAddLineToPoint(path, NULL, secondPoint.x, secondPoint.y);
    CGPathAddLineToPoint(path, NULL, threePoint.x, threePoint.y);
    
    CGContextAddPath(ctx, path);
    
    CGPathRelease(path);
    
    [_fillColor setFill];
    
    CGContextFillPath(ctx);
}

@end
