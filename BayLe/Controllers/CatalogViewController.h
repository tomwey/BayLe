//
//  CatalogViewController.h
//  BayLe
//
//  Created by tomwey on 12/1/15.
//  Copyright (c) 2015 tangwei1. All rights reserved.
//

#import "BaseViewController.h"

@protocol CatalogViewControllerDelegate <NSObject>

@optional
- (void)didSelectCatalog:(id)catalog;

@end

@interface CatalogViewController : BaseViewController

@property (nonatomic, assign) id delegate;

@end
