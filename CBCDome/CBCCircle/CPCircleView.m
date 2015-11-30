//
//  CPCircleView.m
//  CBCDome
//
//  Created by chenpeng on 15/11/26.
//  Copyright © 2015年 chenpeng. All rights reserved.
//

#import "CPCircleView.h"
#import "CPCircleIItems.h"

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

@interface CPCircleView()
@property (assign, nonatomic) CGPoint circleCenter;
@property (assign, nonatomic) CGFloat averageRadian;
@property (assign, nonatomic) CGFloat itemsRadiu; //半径
@property (assign, nonatomic) CGPoint tapPoint;   //触摸点
@property (assign, nonatomic) CGPoint movePoint;  //移动的点
@property (assign, nonatomic) CGPoint velocate;   //速度，矢量
@property (assign, nonatomic) NSInteger dirction; //方向
@end

@implementation CPCircleView

+ (instancetype)createCircleViewWithItems:(NSArray *)imageArray
{
    static CPCircleView *circlrView = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        circlrView = [[CPCircleView alloc]initWithFrame:CGRectMake(10, 100, 300, 300)];
        if (  imageArray && imageArray.count>0) {
            circlrView.imageItems = imageArray;
        }
        else
        {
            //没有图片，使用自定义的图片
            circlrView.imageItems = @[[UIImage imageNamed:@"icon_chat_record"],[UIImage imageNamed:@"icon_config"],[UIImage imageNamed:@"icon_pay_success"],[UIImage imageNamed:@"icon_remedical"],[UIImage imageNamed:@"icon_wei"],[UIImage imageNamed:@"icon_women"]];
        }
        [circlrView configCircleView];
    });
    return circlrView;
}

#pragma mark - event   response

- (void)panGestureWithCircle:(UIPanGestureRecognizer *)panGes
{

    switch (panGes.state) {
        case UIGestureRecognizerStateBegan:
            self.tapPoint = [panGes locationInView:self];
            break;
            
        case UIGestureRecognizerStateChanged:
            self.movePoint = [panGes locationInView:self];
            NSLog(@"tap===%@",NSStringFromCGPoint(self.tapPoint));
            NSLog(@"move===%@",NSStringFromCGPoint(self.movePoint));
            [self panCircleWithTapPoint:self.tapPoint andMovePoint:self.movePoint inCircleCenter:self.circleCenter];
            self.tapPoint = self.movePoint;
            break;
            
        case UIGestureRecognizerStateEnded:
            self.movePoint = [panGes locationInView:self];
            self.velocate = [panGes velocityInView:self];
            NSLog(@"%@",NSStringFromCGPoint(self.velocate));
            [self panCircleWithTapPoint:self.tapPoint andMovePoint:self.movePoint inCircleCenter:self.circleCenter];
            if (self.velocate.x != 0 || self.velocate.y != 0) {
                [self judgeDirction];
            }
            break;
            
        case UIGestureRecognizerStateFailed:
            self.movePoint = [panGes locationInView:self];
            [self panCircleWithTapPoint:self.tapPoint andMovePoint:self.movePoint inCircleCenter:self.circleCenter];
            if (self.velocate.x !=0 || self.velocate.y != 0) {
                [self judgeDirction];
            }
            break;
            
        default:
            
            break;
    }
}

- (void)judgeDirction
{
    CPCircleIItems *items = [self.circleItems firstObject];
    if (items.current_location == CurrentLocation_first) {
        if (items.current_location == items.last_location) {
            if (items.current_center.x - items.last_center.x > 0) {
                items.clockWise = NO;
            }
            else
            {
                items.clockWise = YES;
            }
        }
        else
        {
            
        }
    }
    self.dirction = -2;
    [self customCircleRadian:YES];
}

#pragma mark - private response

//圆滑滚动radian
- (void)customCircleRadian:(BOOL)dirction
{
    for (NSInteger index = 0; index<self.circleItems.count; index++) {
        CPCircleIItems *items = [self.circleItems objectAtIndex:index];
        [self animationCircleWithLayer:items.layer forKey:[NSString stringWithFormat:@"transform.rota.%ld",(long)index] withDirction:-self.dirction];
    }
    [self animationCircleWithLayer:self.layer forKey:@"rotate-layer" withDirction:self.dirction];
}

- (void)animationCircleWithLayer:(CALayer *)layer forKey:(NSString *)key withDirction:(NSInteger)dirction
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.delegate = self;
    animation.duration = 1.0; // 持续时间
    animation.repeatCount = 1; // 重复次数
    animation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    animation.toValue = [NSNumber numberWithFloat:dirction * M_PI]; // 终止角度
    [layer addAnimation:animation forKey:key];
}

//此方法弧度计算出现问题，有待研究
- (void)calRoRorit
{
//            CPCircleIItems *items = [self.circleItems objectAtIndex:index];
//            CAKeyframeAnimation *orbit = [CAKeyframeAnimation animation];
//            CGMutablePathRef path = CGPathCreateMutable();
//            orbit.keyPath = @"position";
//            CGPathAddArc(path, NULL, self.circleCenter.x, self.circleCenter.y, self.itemsRadiu,items.current_radianX,M_PI+items.current_radianX, dirction);
//            orbit.fillMode = kCAFillModeForwards;
//            orbit.delegate = self;
//            orbit.path = path;
//            orbit.duration = 0.5;
//            orbit.repeatCount = 1;
//            orbit.calculationMode = kCAAnimationPaced;
//            orbit.removedOnCompletion = NO;
//            CGPathRelease(path);
//            [items.layer addAnimation:orbit forKey:[NSString stringWithFormat:@"orbit.transform.%ld",(long)index]];
//            [self calculateCenterWithXRadian:items.current_radianX andRadiu:self.itemsRadiu andCenter:self.circleCenter];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    for (NSInteger index = 0; index<self.circleItems.count; index++) {
        CPCircleIItems *items = [self.circleItems objectAtIndex:index];
        [items.layer removeAnimationForKey:[NSString stringWithFormat:@"transform.rota.%ld",(long)index]];
        
    }
    [self.layer removeAnimationForKey:@"rotate-layer"];
}

//交换同弧度的item的位置
- (void)customChangeLocation
{
    for (NSInteger index = 0; index<self.circleItems.count; index++) {
    [UIView animateWithDuration:1.5f animations:^{
            CPCircleIItems *itmes = [self.circleItems objectAtIndex:index];
            CGPoint itemCenter = [self calculateCenterWithYRadian:itmes.current_radianY+M_PI andRadiu:self.itemsRadiu andCenter:self.circleCenter];
            itmes.center = itemCenter;
            itmes.current_radianY = [self getRadianByRadian:itmes.current_radianY+M_PI];
    } completion:nil];
    }
}

- (void)panCircleWithTapPoint:(CGPoint)tapPoint andMovePoint:(CGPoint)movePoint inCircleCenter:(CGPoint)circleCenter
{
    CGFloat tap_radian =[self calculateRadian2fWithX:tapPoint.x-circleCenter.x andY:tapPoint.y-circleCenter.y];
    CGFloat move_radian = [self calculateRadian2fWithX:movePoint.x-circleCenter.x andY:movePoint.y-circleCenter.y];
    CGFloat change_radian = move_radian - tap_radian;
    for (NSInteger index = 0; index<self.circleItems.count; index++) {
        CPCircleIItems *itmes = [self.circleItems objectAtIndex:index];
        CGPoint itemCenter = [self calculateCenterWithYRadian:itmes.current_radianY+change_radian andRadiu:self.itemsRadiu andCenter:self.circleCenter];
        itmes.last_location = itmes.current_location;
        itmes.last_center = itmes.center;
        itmes.center = itemCenter;
        itmes.current_center = itemCenter;
        itmes.current_location = [self calculateCurrentLocation:itemCenter];
        itmes.current_radianY = [self getRadianByRadian:itmes.current_radianY+change_radian];
        itmes.current_radianX = [self getXRadianByYRadian:itmes.current_radianY];
    }
}

- (CGFloat)calculateRadian2fWithX:(CGFloat)x andY:(CGFloat)y
{
    CGFloat radian = atan2f(x,y);
    
    if(radian < 0.0f)
    {
        radian = M_PI * 2 + radian;
    }
    
    return radian;
}

- (CGFloat)getYRadianByXRadian:(CGFloat)radian
{
    CGFloat an_r = M_PI_2 - 2*M_PI + radian ;
    
    if(an_r < 0.0f)
    {
        an_r =  - an_r;
    }
    return an_r;
}

- (CGFloat)getXRadianByYRadian:(CGFloat)radian
{
    
    CGFloat an_r = 2.0f * M_PI -  radian + M_PI_2;
    
    if(an_r < 0.0f)
    {
        an_r =  - an_r;
    }
    return an_r;
}

- (CGFloat)getRadianByRadian:(CGFloat)radian
{
    if(radian > 2 * M_PI)
    {
        return (radian - floorf(radian / (2.0f * M_PI)) * 2.0f * M_PI);
    }
    else if(radian < 0.0f)
    {
        return (2.0f * M_PI + radian - ceilf(radian / (2.0f * M_PI)) * 2.0f * M_PI);
    }
    return radian;
}

- (void)configCircleView
{
    self.layer.cornerRadius = MIN(self.bounds.size.height/2, self.bounds.size.width/2);
    self.layer.masksToBounds = YES;
    self.circleCenter = CGPointMake(self.bounds.size.height/2, self.bounds.size.width/2);
    self.backgroundColor = [UIColor colorWithRed:0.866 green:0.950 blue:1.000 alpha:1.000];
    [self addPanGesture];
    [self configImageItems];
}

- (void)addPanGesture
{
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureWithCircle:)];
    [self addGestureRecognizer:panGes];
}

- (void)configImageItems
{
    self.averageRadian = 2*M_PI / self.imageItems.count;
    self.itemsRadiu = 100.0f;
    for (NSInteger index = 1; index <=self.imageItems.count; index++) {
        CPCircleIItems *circleItem = [[CPCircleIItems alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        circleItem.index = index;
        circleItem.image = self.imageItems[index-1];
        CGPoint itemCenter = [self calculateCenterWithYRadian:self.averageRadian*index andRadiu:self.itemsRadiu andCenter:self.circleCenter];
        circleItem.center = itemCenter;
        circleItem.current_center = itemCenter;
        circleItem.current_location = [self calculateCurrentLocation:itemCenter];
        circleItem.current_radianY = self.averageRadian*index;
        [self addSubview:circleItem];
        [self.circleItems addObject:circleItem];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ResponseTapGes:)];
        tapGes.numberOfTapsRequired = 1.0f;
        tapGes.numberOfTouchesRequired = 1.0f;
        [circleItem addGestureRecognizer:tapGes];
        
    }
}

- (void)ResponseTapGes:(UITapGestureRecognizer *)tapGes
{
    CPCircleIItems *circleItem = (CPCircleIItems *)tapGes.view;
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectCircleItemsAtIndex:)]) {
        [_delegate didSelectCircleItemsAtIndex:circleItem.index];
    }
}

- (CurrentLocation)calculateCurrentLocation:(CGPoint)pointCenter
{
    if (pointCenter.y - self.circleCenter.y >= 0 && pointCenter.x - self.circleCenter.x >= 0) {
        return CurrentLocation_first;
    }
    else if (pointCenter.y - self.circleCenter.y > 0 && pointCenter.x - self.circleCenter.x < 0)
    {
        return CurrentLocation_second;
    }
    else if (pointCenter.y - self.circleCenter.y <= 0 && pointCenter.x - self.circleCenter.x <= 0)
    {
        return CurrentLocation_third;
    }
    else if (pointCenter.y - self.circleCenter.y < 0 && pointCenter.x - self.circleCenter.x > 0)
    {
        return CurrentLocation_fourth;
    }
    return CurrentLocation_first;
}

- (CGPoint)calculateCenterWithYRadian:(CGFloat)radian andRadiu:(CGFloat)radiu andCenter:(CGPoint)center
{
    CGPoint itemCenter;
    itemCenter.x = sinf(radian)*radiu + center.x;
    itemCenter.y = cosf(radian)*radiu + center.y;
    return itemCenter;
}

- (CGPoint)calculateCenterWithXRadian:(CGFloat)radian andRadiu:(CGFloat)radiu andCenter:(CGPoint)center
{
    CGPoint itemCenter;
    itemCenter.y = sinf(radian)*radiu + center.y;
    itemCenter.x = cosf(radian)*radiu + center.x;
    return itemCenter;
}

#pragma mark - getter

- (NSMutableArray *)circleItems
{
    if (!_circleItems) {
        _circleItems = [NSMutableArray array];
    }
    return _circleItems;
}

@end











