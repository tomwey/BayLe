//
//  TextInputComponent.m
//  EAT
//
//  Created by tangwei1 on 15/5/12.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import "TextInputComponent.h"
#import "Defines.h"

@interface TextInputComponent () <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, copy) NSString* originText;

@end

@implementation TextInputComponent
{
    UILabel*    _placeholderLabel;
    UILabel*    _textLimitLabel;
    UITextView* _textView;
    
    UITextField*_textField;
    
    UIView*     _inputControl;
    UIView*     _bottomLine;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ( self = [super initWithCoder:aDecoder] ) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
//    CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]) - 30;
//    self.frame = CGRectMake(15, 0, width, width * 0.518);
    
    self.backgroundColor = [UIColor whiteColor];
    
    _componentType = TextInputComponentTypeSingle;
    
//    self.layer.borderWidth = .6;
//    self.layer.borderColor = [RGB(207, 207, 207) CGColor];
    
    self.textLength = -1;
    self.placeholder = @"请输入内容";
    self.textColor = AWColorFromRGB(58, 58, 58);
    self.font = [UIFont systemFontOfSize:18];
    
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AWFullScreenWidth(), 0.3)];
    [self addSubview:_bottomLine];
    [_bottomLine release];
    
    _bottomLine.backgroundColor = MAIN_LIGHT_GRAY_COLOR;
    
    [self initUI];
    
    self.componentType = TextInputComponentTypeSingle;
    
//    self.frame = MainScreenBounds;
    
    UIView* topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AWFullScreenWidth(), 0.6)];
    [self addSubview:topLine];
    [topLine release];
    
    topLine.backgroundColor = MAIN_LIGHT_GRAY_COLOR;
}

- (BOOL)isChinese
{
//    NSLog(@"%@", [[self textInputMode] primaryLanguage]);
    return [[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString: @"zh-Hans"];
}

- (BOOL)isEmoji
{
    return [[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString: @"emoji"];
}

- (void)initUI
{
    
    CGFloat dty = self.componentType == TextInputComponentTypeMultiple ? 5 : CGRectGetHeight(_inputControl.frame) / 2 - 10;
    _placeholderLabel = AWCreateLabel(CGRectMake(CGRectGetMinX(_inputControl.frame) + 5,
                                                 dty,
                                                 CGRectGetWidth(_inputControl.frame), 20), nil, NSTextAlignmentLeft, AWSystemFontWithSize(15, NO), AWColorFromRGB(207, 207, 207));
    
    [self addSubview:_placeholderLabel];
    
    _textLimitLabel = AWCreateLabel(CGRectMake(CGRectGetMinX(_inputControl.frame),
                                               CGRectGetHeight(_inputControl.frame) - 30,
                                               CGRectGetWidth(_inputControl.frame) - 10,
                                               20), nil, NSTextAlignmentRight, AWSystemFontWithSize(14, NO), [UIColor blackColor]);
    [self addSubview:_textLimitLabel];
}

- (void)setComponentType:(TextInputComponentType)componentType
{
    _componentType = componentType;
    
    if ( _componentType == TextInputComponentTypeSingle ) {
        
        self.frame = CGRectMake(0, 0, AWFullScreenWidth(), 57);
        
        CGRect frame = _bottomLine.frame;
        frame.origin.y = CGRectGetHeight(self.frame);
        _bottomLine.frame = frame;
        
        if ( !_textField ) {
            
            frame = self.bounds;
            frame.origin.x = 15;
            frame.size.width = CGRectGetWidth(frame) - 30;
            
            _textField = [[[UITextField alloc] initWithFrame:frame] autorelease];
            [self addSubview:_textField];
            
            _textField.delegate = self;
            
            [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
        
        _inputControl = _textField;
    } else {
        
        self.frame = CGRectMake(0, 0, AWFullScreenWidth(), AWFullScreenWidth() * 0.518);
        
        CGRect frame = _bottomLine.frame;
        frame.origin.y = CGRectGetHeight(self.frame);
        _bottomLine.frame = frame;
        
        if ( !_textView ) {
            
            frame = self.bounds;
            frame.origin.x = 15;
            frame.size.width = CGRectGetWidth(frame) - 30;
            
            _textView = [[[UITextView alloc] initWithFrame:frame] autorelease];
            [self addSubview:_textView];
            
            [_textView setDelegate:self];
            
            _textView.contentInset = UIEdgeInsetsZero;
        }
        
        _inputControl = _textView;
        
    }
    
    _inputControl.backgroundColor = [UIColor clearColor];
    
    CGFloat dtx = self.componentType == TextInputComponentTypeMultiple ? CGRectGetMinX(_inputControl.frame) + 5 :
                                        CGRectGetMinX(_inputControl.frame) + 2;
    
    CGFloat dty = self.componentType == TextInputComponentTypeMultiple ? 8 : CGRectGetHeight(_inputControl.frame) / 2 - 10;
    
    _placeholderLabel.frame = CGRectMake(dtx, dty, CGRectGetWidth(_inputControl.frame), 20);
    
    if ( self.componentType == TextInputComponentTypeSingle ) {
        _textLimitLabel.frame = CGRectMake(CGRectGetMinX(_inputControl.frame),
                                           CGRectGetMaxY(_bottomLine.frame) + 10,
                                           CGRectGetWidth(_inputControl.frame) - 10,
                                           20);
    } else {
        _textLimitLabel.frame = CGRectMake(CGRectGetMinX(_inputControl.frame),
                                           CGRectGetHeight(_inputControl.frame) - 30,
                                           CGRectGetWidth(_inputControl.frame) - 10,
                                           20);
    }

    [self bringSubviewToFront:_placeholderLabel];
    
    [self bringSubviewToFront:_textLimitLabel];
    
    [self bringSubviewToFront:_bottomLine];
}

- (void)hideKeyboard
{
    if ( self.componentType == TextInputComponentTypeSingle ) {
        [_textField resignFirstResponder];
    } else {
        [_textView resignFirstResponder];
    }
}

- (BOOL)textChanged
{
    if ( self.componentType == TextInputComponentTypeSingle ) {
        return ![self.originText isEqualToString:_textField.text];
    }
    
    return ![self.originText isEqualToString:_textView.text];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ( [textView.text length] == 0 ) {
        _placeholderLabel.hidden = NO;
    } else {
        _placeholderLabel.hidden = YES;
    }
    
    if ( _textLength >= 0 ) {
        
        if ( [self isChinese] ) {
            UITextRange *selectedRange = [textView markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
            
            if ( !position ) {
                
                if ( textView.text.length > _textLength ) {
                    textView.text = [textView.text substringToIndex:_textLength];
                }
                
                _textLimitLabel.text = [NSString stringWithFormat:@"还剩%ld个字", (unsigned long)(_textLength - [textView.text length])];
            }
            
        } else if ( [self isEmoji] ) {
            if ( textView.text.length > _textLength ) {
                int dn = textView.text.length - _textLength;
                if ( dn == 2 ) {
                    textView.text = [textView.text substringToIndex:_textLength];
                } else {
                    textView.text = [textView.text substringToIndex:_textLength - dn];
                }
                
            }
            
            _textLimitLabel.text = [NSString stringWithFormat:@"还剩%ld个字", (unsigned long)(_textLength - [textView.text length])];
        } else {
            if ( textView.text.length > _textLength ) {
                textView.text = [textView.text substringToIndex:_textLength];
            }
            
            _textLimitLabel.text = [NSString stringWithFormat:@"还剩%ld个字", (unsigned long)(_textLength - [textView.text length])];
        }
    }
    
//    if ( _textLength >= 0 ) {
//        _textLimitLabel.text = [NSString stringWithFormat:@"还剩%ld个字", (unsigned long)(_textLength - [textView.text length])];
//    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if ( [textField.text length] == 0 ) {
        _placeholderLabel.hidden = NO;
    } else {
        _placeholderLabel.hidden = YES;
    }
    
    if ( _textLength >= 0 ) {
        
        if ( [self isChinese] ) {
            UITextRange *selectedRange = [textField markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            
            if ( !position ) {
                
                if ( textField.text.length > _textLength ) {
                    textField.text = [textField.text substringToIndex:_textLength];
                }
                
                _textLimitLabel.text = [NSString stringWithFormat:@"还剩%ld个字", (unsigned long)(_textLength - [textField.text length])];
            }
            
        } else if ( [self isEmoji] ) {
            if ( textField.text.length > _textLength ) {
                int dn = textField.text.length - _textLength;
                if ( dn == 2 ) {
                    textField.text = [textField.text substringToIndex:_textLength];
                } else {
                    textField.text = [textField.text substringToIndex:_textLength - dn];
                }
                
            }
            
            _textLimitLabel.text = [NSString stringWithFormat:@"还剩%ld个字", (unsigned long)(_textLength - [textField.text length])];
        } else {
            if ( textField.text.length > _textLength ) {
                textField.text = [textField.text substringToIndex:_textLength];
            }
            
            _textLimitLabel.text = [NSString stringWithFormat:@"还剩%ld个字", (unsigned long)(_textLength - [textField.text length])];
        }
    }
}

- (void)setTextLength:(NSInteger)textLength
{
    _textLength = textLength;
    
    if ( _textLength <= -1 ) {
        _textLimitLabel.hidden = YES;
    } else {
        _textLimitLabel.hidden = NO;
    }
    
//    if ( self.componentType == TextInputComponentTypeMultiple ) {
        _textLimitLabel.text = [NSString stringWithFormat:@"还剩%ld个字", (unsigned long)(_textLength - self.text.length )];
//    }
}

- (void)setText:(NSString *)text
{
    self.originText = text;
    
    if ( text.length > 0 ) {
        _placeholderLabel.hidden = YES;
    } else {
        _placeholderLabel.hidden = NO;
    }
    
    if ( self.componentType == TextInputComponentTypeSingle ) {
        _textField.text = text;
    } else {
        _textView.text = text;
    }
    
    _textLimitLabel.text = [NSString stringWithFormat:@"还剩%ld个字", (unsigned long)(_textLength - self.text.length )];
}

- (NSString *)text
{
    if ( self.componentType == TextInputComponentTypeSingle ) {
        return _textField.text;
    }
    
    return _textView.text;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    [_placeholder release];
    _placeholder = [placeholder copy];
    
    _placeholderLabel.text = placeholder;
}

- (void)setTextColor:(UIColor *)textColor
{
    [_textColor release];
    _textColor = [textColor retain];
    
//    _textView.textColor = _textColor;
    if ( self.componentType == TextInputComponentTypeSingle ) {
        _textField.textColor = _textColor;
    } else {
        _textView.textColor = _textColor;
    }
}

- (void)setFont:(UIFont *)font
{
    [_font release];
    _font = [font retain];
    
//    _textView.font = font;
    
    if ( self.componentType == TextInputComponentTypeSingle ) {
        _textField.font = font;
    } else {
        _textView.font = font;
    }
    
    _placeholderLabel.font = font;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    _keyboardType = keyboardType;
    
    if ( self.componentType == TextInputComponentTypeSingle ) {
        _textField.keyboardType = keyboardType;
    } else {
        _textView.keyboardType = keyboardType;
    }
}

- (void)dealloc
{
    self.placeholder = nil;
    self.textColor = nil;
    self.font = nil;
    
    self.originText = nil;
    
    [super dealloc];
}

@end
