# JHCarouselView
## 一款简单的图片无限轮播器
* 支持网络图片及本地图片
* 支持水平和垂直方向滚动
* 支持page控件的摆放位置调整，默认为中间
* 注意：本控件依赖SDWebImage，请注意集成
### 基本使用
```objc
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
```
### 监听方法
```objc
-(void)carouselViewDidClick:(JHCarouselView *)carouselView didClickImageIndex:(NSInteger)index{

    NSLog(@"点击了第%zd张图片",index);
}
```

