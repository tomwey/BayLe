//
//  FormTextInput.h
//  BayLe
//
//  Created by tangwei1 on 15/12/11.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormTextInput : UIView

@property (nonatomic, copy) NSString* label;
@property (nonatomic, copy) NSString* placeholder;

@property (nonatomic, retain, readonly) UILabel*     nameLabel;
@property (nonatomic, retain, readonly) UITextField* textField;

@property (nonatomic, retain, readonly) UIView*      bottomLine;

- (void)addTarget:(id)target forAction:(SEL)action;

@end
