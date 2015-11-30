//
//  CPCircleImageView.h
//  CBCDome
//
//  Created by chenpeng on 15/11/26.
//  Copyright © 2015年 chenpeng. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, CurrentLocation) {
    CurrentLocation_first = 0 ,
    CurrentLocation_second = 1,
    CurrentLocation_third = 2,
    CurrentLocation_fourth = 3
};
@interface CPCircleIItems : UIImageView

@property (assign, nonatomic) CGFloat current_radianY;
@property (assign, nonatomic) CGFloat current_radianX;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) CGPoint current_center;
@property (assign, nonatomic) CGPoint last_center;
@property (assign, nonatomic) CurrentLocation current_location;
@property (assign, nonatomic) CurrentLocation last_location;
@property (assign, nonatomic) BOOL     clockWise;

@end
