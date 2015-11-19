//
//  AWTableView.m
//  Wallpapers10000+
//
//  Created by tangwei1 on 15/7/17.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "AWTableView.h"

@implementation AWTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if ( self = [super initWithFrame:frame style:style] ) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if ( [self respondsToSelector:@selector(setSeparatorInset:)] ) {
            self.separatorInset = UIEdgeInsetsZero;
        }
        
        if ( [self respondsToSelector:@selector(setLayoutMargins:)] ) {
            self.layoutMargins = UIEdgeInsetsZero;
        }
        
    }
    
    return self;
}

@end
