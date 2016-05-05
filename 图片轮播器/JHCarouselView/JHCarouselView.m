//
//  JHCarouselView.m
//  图片轮播器
//
//  Created by 徐仲平 on 16/4/29.
//  Copyright © 2016年 JungHsu. All rights reserved.
//

#import "JHCarouselView.h"
/** 注意:本控件依赖SDWebImage框架，请务必集成 */
/** 由于使用的是CocoaPods，如果没有使用cocoaPods的coder使用时请记得将<>改成""来导入 */
#import <UIImageView+WebCache.h>

@interface JHCarouselView ()<UIScrollViewDelegate>

/** 内容view */
@property (nonatomic,weak)UIScrollView *contentView;

@property (nonatomic,weak)UIPageControl *page;

@property (nonatomic,weak)UIImageView *imageView;

@property (nonatomic,strong)NSTimer *timer;

@end

@implementation JHCarouselView

#define ALLIMAGEVIEW_COUNT 3
#define DEFAULT_INTERVAL 2.0
#define DEFAULT_PAGECOUNT 5

static CGFloat const PageHeight = 30;
static CGFloat const PageWidth = 150;
static CGFloat const PageInterval = 20;

+(instancetype)carousel{

    return [[self alloc]init];
}
#pragma mark - 懒加载处理
-(UIScrollView *)contentView{

    if (!_contentView) {
        
        //初始化内容scrollView
        UIScrollView *contentView = [[UIScrollView alloc]init];
        
        contentView.bounces = NO;
        //禁止所有滚动条
        contentView.showsHorizontalScrollIndicator = NO;
        contentView.showsVerticalScrollIndicator = NO;
        //开启分页
        contentView.pagingEnabled = YES;
        contentView.delegate = self;
        contentView.contentSize = CGSizeMake(self.jh_width * ALLIMAGEVIEW_COUNT, 0);
        [self addSubview:contentView];
        _contentView = contentView;

    }
    return _contentView;
}
-(UIPageControl *)page{

    if (!_page) {
        
        //初始化page
        UIPageControl *page = [[UIPageControl alloc]init];
        page.pageIndicatorTintColor = [UIColor blackColor];
        page.currentPageIndicatorTintColor = [UIColor whiteColor];
        /** 默认5页 */
        page.numberOfPages = DEFAULT_PAGECOUNT;
        [self addSubview:page];
        _page = page;

    }
    return _page;
}

#pragma mark - 初始化
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        /** 配置初始化 */
        [self initConfig];
 
        
        //添加imageview
        for (NSInteger i = 0; i < ALLIMAGEVIEW_COUNT; i++) {
            
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.userInteractionEnabled = YES;
            imageView.backgroundColor = [UIColor grayColor];
            
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)]];
            
            [self.contentView addSubview:imageView];
            self.imageView = imageView;
        }
    }
    return self;
}
/** 配置初始化 */
-(void)initConfig{

    /** 设置默认为水平滚动 */
    _direction = JHCarouselDirectionHorizontal;
    /** 默认摆在中间 */
    _PageControlLocation = JHPageControlLocationCenter;
    
    /** 默认时间 */
    _interval = DEFAULT_INTERVAL;

}

/** 添加定时器 */
-(void)addTimer{

    self.timer = [NSTimer timerWithTimeInterval:_interval target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
  
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/** 移除定时器 */
-(void)removetimer{

    [self.timer invalidate];
    self.timer = nil;
}

-(void)nextImage{

    if (_direction == JHCarouselDirectionHorizontal) {
        
        [self.contentView setContentOffset:CGPointMake(_contentView.jh_width * 2, 0) animated:YES];
    }else{
        [self.contentView setContentOffset:CGPointMake(0, _contentView.jh_height * 2) animated:YES];
    }
}


-(void)layoutSubviews{

    [super layoutSubviews];
    
    /** scrollView */
    self.contentView.frame = self.bounds;
    
    if (_direction == JHCarouselDirectionHorizontal) { //当设置水平方向滚动
        self.contentView.contentSize = CGSizeMake(self.contentView.jh_width * 3, 0);
    }else {
    
        self.contentView.contentSize = CGSizeMake(0, self.contentView.jh_height * 3);
     }
    
    //imageview
    for (NSInteger i = 0; i < ALLIMAGEVIEW_COUNT; i++) {
        //取出imageview
        UIImageView *imageView = self.contentView.subviews[i];
        imageView.jh_width = self.contentView.jh_width;
        imageView.jh_height = self.contentView.jh_height;
        if (_direction == JHCarouselDirectionHorizontal) {
            imageView.jh_x = self.contentView.jh_width * i;
            imageView.jh_y = 0;
        }else{
                    imageView.jh_x = 0;
            imageView.jh_y = self.contentView.jh_height * i;
        }
    }
    
    //page
    self.page.jh_width = PageWidth;
    self.page.jh_height = PageHeight;
    
     self.page.jh_y = self.contentView.jh_height - self.page.jh_height;
    if (_PageControlLocation == JHPageControlLocationLeft) { //如果摆在左边
        self.page.jh_x = -PageInterval;

    }else if (_PageControlLocation == JHPageControlLocationCenter){ //摆在中间
        self.page.jh_x = (self.contentView.jh_width - self.page.jh_width) * 0.5;
    }else{ //摆在右边
          self.page.jh_x = self.contentView.jh_width - self.page.jh_width + PageInterval;
    }
 
     [self updateImageView];
    
}
/** 更新所有imageview的内容 */
-(void)updateImageView{

     for (NSInteger i = 0; i < self.contentView.subviews.count; i++) {
        
        UIImageView *imageView = self.contentView.subviews[i];
        

        //当前page索引
        NSInteger index = self.page.currentPage;
       
        if (i == 0) {
            index --;
        }else if (i == 2){
        
            index ++;
        }

        /** 处理特殊情况 */
        if (index == -1) {
        
            if (self.imageStrs) {
                index = self.imageStrs.count - 1;
            }else{
             
                index = self.imageUrls.count - 1;
            }
        }else if (index == self.imageStrs.count || index == self.imageUrls.count){
        
            index = 0;
        }
        /** 绑定tag */
        imageView.tag = index;
        if (_imageStrs) {
            UIImage *image = [UIImage imageNamed:self.imageStrs[index]];
            imageView.image = image;
            
        }else{
        
            NSURL *url = [NSURL URLWithString:self.imageUrls[index]];
            [imageView sd_setImageWithURL:url placeholderImage:_placeholderImage];
        }

    }
    
    if (_direction == JHCarouselDirectionHorizontal) {
        self.contentView.contentOffset = CGPointMake(self.contentView.jh_width, 0);
    }else{
        self.contentView.contentOffset = CGPointMake(0, self.contentView.jh_height);
    }


}

-(void)setImageStrs:(NSArray *)imageStrs{

    _imageStrs = imageStrs;
    
    self.page.numberOfPages = imageStrs.count;
    //添加定时器
    [self addTimer];

}

-(void)setImageUrls:(NSArray *)imageUrls{

    _imageUrls = imageUrls;
    
    self.page.numberOfPages = imageUrls.count;
   
    //添加定时器
    [self addTimer];
}

-(void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{

    _pageIndicatorTintColor = pageIndicatorTintColor;
    
    self.page.pageIndicatorTintColor = pageIndicatorTintColor;
}
-(void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor{

    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    
    self.page.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 找出当前显示在最中间的imageView
    NSInteger page = 0;
    CGFloat minDistance = MAXFLOAT;
    for (int i = 0; i<self.contentView.subviews.count; i++) {
        UIImageView *imageView = self.contentView.subviews[i];
        
        CGFloat distance = 0;
        if (_direction == JHCarouselDirectionVertical) {
            distance = ABS(imageView.frame.origin.y - scrollView.contentOffset.y);
        } else {
            distance = ABS(imageView.frame.origin.x - scrollView.contentOffset.x);
        }
        if (distance < minDistance) {
            minDistance = distance;
            page = imageView.tag;
        }
    }
    self.page.currentPage = page;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updateImageView];
 }


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{

    [self updateImageView];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    
    [self removetimer];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    [self addTimer];
}

#pragma mark - 监听图片点击
-(void)imageClick:(UIGestureRecognizer *)tap{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(carouselViewDidClick:didClickImageIndex:)]) {
        [self.delegate carouselViewDidClick:self didClickImageIndex:tap.view.tag];
    }
}


@end

/************************************ JHExtension ***********************************/

@implementation UIView (JHExtension)

-(void)setJh_width:(CGFloat)jh_width{
    
    CGRect frame=self.frame;
    
    frame.size.width=jh_width;
    
    self.frame=frame;
}

-(void)setJh_height:(CGFloat)jh_height{
    
    CGRect frame=self.frame;
    
    frame.size.height=jh_height;
    
    self.frame=frame;
    
}

-(void)setJh_x:(CGFloat)jh_x{
    CGRect frame=self.frame;
    
    frame.origin.x=jh_x;
    
    self.frame=frame;
    
}

-(void)setJh_y:(CGFloat)jh_y{
    CGRect frame=self.frame;
    
    frame.origin.y=jh_y;
    
    self.frame=frame;
    
    
}

-(void)setJh_size:(CGSize)jh_size{
    
    CGRect frame=self.frame;
    
    frame.size=jh_size;
    
    self.frame=frame;
    
}

-(void)setJh_origin:(CGPoint)jh_origin{
    
    CGRect frame=self.frame;
    
    frame.origin=jh_origin;
    
    self.frame=frame;
    
}

-(void)setJh_centerX:(CGFloat)jh_centerX{
    
    CGPoint center=self.center;
    
    center.x=jh_centerX;
    
    self.center=center;
    
}

-(void)setJh_centerY:(CGFloat)jh_centerY{
    CGPoint center=self.center;
    center.y=jh_centerY;
    
    self.center=center;
    
}


-(CGFloat)jh_width{
    
    return self.frame.size.width;
}

-(CGFloat)jh_height{
    
    return self.frame.size.height;
}

-(CGFloat)jh_x{
    
    return self.frame.origin.x;
}

-(CGFloat)jh_y{
    
    return self.frame.origin.y;
}

-(CGSize)jh_size{
    
    return self.frame.size;
}

-(CGPoint)jh_origin{
    
    return self.frame.origin;
}

-(CGFloat)jh_centerX{
    
    return self.center.x;
}

-(CGFloat)jh_centerY{
    
    return self.center.y;
}

@end

