//
//  FormTextInput.m
//  BayLe
//
//  Created by tangwei1 on 15/12/11.
//  Copyright © 2015年 tangwei1. All rights reserved.
//

#import "FormTextInput.h"
#import "Defines.h"

@implementation FormTextInput
{
    id  _target;
    SEL _action;
}

@synthesize nameLabel = _nameLabel;
@synthesize textField = _textField;

@synthesize bottomLine = _bottomLine;

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        self.bottomLine.hidden = YES;
    }
    return self;
}

- (UILabel *)nameLabel
{
    if ( !_nameLabel ) {
        _nameLabel = AWCreateLabel(CGRectZero,
                                   nil,
                                   NSTextAlignmentRight,
                                   AWSystemFontWithSize(15, NO),
                                   [UIColor blackColor]);
        [self addSubview:_nameLabel];
    }
    
    return _nameLabel;
}

- (UIView *)bottomLine
{
    if ( !_bottomLine ) {
        _bottomLine = AWCreateLine(CGSizeMake(0, 0.6), AWColorFromRGB(224, 224, 224));
        [self addSubview:_bottomLine];
    }
    
    return _bottomLine;
}

- (UITextField *)textField
{
    if ( !_textField ) {
        _textField = [[[UITextField alloc] init] autorelease];
        [self addSubview:_textField];
        
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return _textField;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.nameLabel.text = self.label;
    self.textField.placeholder = self.placeholder;
    
    self.nameLabel.font = self.textField.font;
    
    self.nameLabel.frame = CGRectMake(0, self.height / 2 - 37 / 2, 58, 37);
    
    CGRect frame = self.nameLabel.frame;
    frame.origin.x = self.nameLabel.right + 10;
    frame.size.width = self.width - self.nameLabel.width - 10;
    self.textField.frame = frame;
    
    self.bottomLine.frame = CGRectMake(0, self.height - 0.6, self.width, 0.6);
}

- (void)addTarget:(id)target forAction:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)textFieldDidChange:(UITextField *)sender
{
    if ( [_target respondsToSelector:_action] ) {
        [_target performSelector:_action withObject:self];
    }
}

@end
