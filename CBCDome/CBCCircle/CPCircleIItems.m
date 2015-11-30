//
//  CPCircleImageView.m
//  CBCDome
//
//  Created by chenpeng on 15/11/26.
//  Copyright © 2015年 chenpeng. All rights reserved.
//

#import "CPCircleIItems.h"

@implementation CPCircleIItems

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = frame.size.height/2.0f;
        self.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
    }
    return self;
}

@end
