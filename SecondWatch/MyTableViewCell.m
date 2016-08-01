//
//  MyTableViewCell.m
//  SecondWatch
//
//  Created by nd on 16/8/1.
//  Copyright © 2016年 com.nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyTableViewCell.h"

#define KScreenWidth self.contentView.frame.size.width

@interface MyTableViewCell()

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setLabelText:(NSString *) textString;

@end

@implementation MyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
 
    self = [super initWithStyle:style reuseIdentifier:identifier];
    if(self) {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.backgroundColor = [UIColor yellowColor];
        _button.frame = CGRectMake(0, 0, 50, 36);
        [_button setTitle:@"标记" forState:UIControlStateNormal];
        [self.contentView addSubview:_button];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, KScreenWidth-60, 36)];
        _label.backgroundColor = [UIColor whiteColor];
        //_label.text = @"111";
        [self.contentView addSubview:_label];
    }
    
    return self;
}

- (void)setLabelText:(NSString *)textString {
    
    self.label.text = textString;
}
@end