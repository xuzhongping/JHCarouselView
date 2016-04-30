//
//  ViewController.m
//  图片轮播器
//
//  Created by 徐仲平 on 16/4/29.
//  Copyright © 2016年 JungHsu. All rights reserved.
//

#import "ViewController.h"
#import "JHCarouselView.h"

@interface ViewController ()<JHCarouselViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    JHCarouselView *carousel = [JHCarouselView carousel];
    carousel.delegate = self;
    carousel.frame = CGRectMake(0, 0, self.view.jh_width, 250);
    
    /** 分页控件的摆放位置 */
    carousel.PageControlLocation = JHPageControlLocationRight;
    /** 分页控件的光标颜色 */
    carousel.pageIndicatorTintColor = [UIColor redColor];
    carousel.currentPageIndicatorTintColor = [UIColor greenColor];
    
    /** 轮播器的滚动方向 默认水平 */
    carousel.direction = JHCarouselDirectionVertical;
    
    carousel.imageStrs = @[@"1",@"2",@"3",@"4",@"5",@"6"];

    [self.view addSubview:carousel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JHCarouselViewDelegate
-(void)carouselViewDidClick:(JHCarouselView *)carouselView didClickImageIndex:(NSInteger)index{

    NSLog(@"点击了第%zd张图片",index);
}
@end
