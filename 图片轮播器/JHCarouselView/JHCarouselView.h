//
//  JHCarouselView.h
//  图片轮播器
//
//  Created by 徐仲平 on 16/4/29.
//  Copyright © 2016年 JungHsu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHCarouselView;
typedef NS_ENUM(NSUInteger,JHCarouselDirection){
    
    JHCarouselDirectionHorizontal = 0, //水平
    JHCarouselDirectionVertical //垂直
};

typedef NS_ENUM(NSUInteger,JHPageControlLocation){
    
    JHPageControlLocationLeft = 0, //左边
    JHPageControlLocationCenter,
    JHPageControlLocationRight
};


@protocol JHCarouselViewDelegate <NSObject>
@optional
/** 监听点击的图片的索引 */
-(void)carouselViewDidClick:(JHCarouselView *)carouselView didClickImageIndex:(NSInteger)index;

@end

@interface JHCarouselView : UIView

/** 快速创建一个图片轮播器 */
+(__kindof JHCarouselView *)carousel;
/** 滚动方向  默认为水平滚动*/
@property (nonatomic,assign)JHCarouselDirection direction;
/** page摆放的位置  默认为中间*/
@property (nonatomic,assign)JHPageControlLocation pageControlLocation;
/** 所有的图片名 */
@property (nonatomic,strong)NSArray<NSString *> *imageStrs;
/** 所有的图片链接 */
@property (nonatomic,strong)NSArray<NSString *> *imageUrls;
/** 占位图片 */
@property (nonatomic,strong)UIImage *placeholderImage;
/** page的光标颜色  默认为黑色*/
@property (nonatomic,strong)UIColor *pageIndicatorTintColor;
/** page的此时停留位置的光标颜色   默认为白色*/
@property (nonatomic,strong)UIColor *currentPageIndicatorTintColor;
/** 轮播间隔时间  默认为2.0秒*/
@property (nonatomic,assign)NSTimeInterval interval;
/** 是否隐藏page控件 */
@property (nonatomic,assign,getter=isHidderPage)BOOL hiddenPage;

/** 点击图片的回调 */
@property (nonatomic,copy) void (^clickBlockType)(NSInteger);

/** 代理 */
@property (nonatomic,weak)id <JHCarouselViewDelegate> delegate;
@end

/************************************ JHExtension ***********************************/
@interface UIView (JHExtension)

@property (nonatomic,assign)CGFloat jh_width;

@property (nonatomic,assign)CGFloat jh_height;

@property (nonatomic,assign)CGFloat jh_x;

@property (nonatomic,assign)CGFloat jh_y;

@property (nonatomic,assign)CGSize jh_size;

@property (nonatomic,assign)CGPoint jh_origin;

@property (nonatomic,assign)CGFloat jh_centerX;

@property (nonatomic,assign)CGFloat jh_centerY;
@end
