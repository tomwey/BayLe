//
//  POICell.h
//  BayLe
//
//  Created by tangwei1 on 15/12/1.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWTableDataConfig.h"

@interface POICell : UITableViewCell <AWTableDataConfig>

- (void)configData:(id)data;

@end
