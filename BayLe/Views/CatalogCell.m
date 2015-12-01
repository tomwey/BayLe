//
//  CatalogCell.m
//  BayLe
//
//  Created by tomwey on 12/1/15.
//  Copyright (c) 2015 tangwei1. All rights reserved.
//

#import "CatalogCell.h"

@implementation CatalogCell

- (void)configData:(id)data
{
    self.textLabel.text = [data objectForKey:@"name"];
}

@end
