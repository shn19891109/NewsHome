//
//  SHNHomeLabel.m
//  网易新闻首页
//
//  Created by 苏浩楠 on 16/2/20.
//  Copyright © 2016年 suhaonan. All rights reserved.
//

#import "SHNHomeLabel.h"
#import "SHNConst.h"
//const CGFloat XMGRed = 0.4;
//const CGFloat XMGGreen = 0.6;
//const CGFloat XMGBlue = 0.7;


@implementation SHNHomeLabel



- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:15];
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor colorWithRed:XMGRed green:XMGGreen blue:XMGBlue alpha:1.0];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    CGFloat red = XMGRed + (1 - XMGRed)*scale;
    CGFloat green = XMGGreen + (0 - XMGGreen)*scale;
    CGFloat blue = XMGBlue + (0 - XMGBlue)*scale;

    self.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    //大小缩放比例
    CGFloat transformScale = 1 + scale*0.3;//[1-1.3];
    self.transform = CGAffineTransformMakeScale(transformScale, transformScale);
}
@end
