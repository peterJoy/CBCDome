//
//  CPCircleView.h
//  CBCDome
//
//  Created by chenpeng on 15/11/26.
//  Copyright © 2015年 chenpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPCircleIItems.h"

@protocol circleTapGestrueDelegate <NSObject>

- (void)didSelectCircleItemsAtIndex:(NSInteger)index;

@end

typedef NS_ENUM(NSInteger,CircleType)
{
    CircleType_M_PI,
    CircleType_CicleRadian
};
//判断旋转方向
typedef NS_ENUM(NSInteger,CircleDirectionType) {
    CircleDirectionType_Negative = 0,
    CircleDirectionType_PosiTive
};

@interface CPCircleView : UIView

@property (weak,nonatomic) id<circleTapGestrueDelegate>delegate;
/**
 *  方向
 */
@property (assign, nonatomic)CircleDirectionType dirctionType;
/**
 *  存放imageItems数组
 */
@property (strong, nonatomic) NSArray *imageItems;
/**
 *  存放circleimageView数组
 */
@property (strong, nonatomic) NSMutableArray *circleItems;

+ (instancetype)createCircleViewWithItems:(NSArray *)imageArray;

@end
