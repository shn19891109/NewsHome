//
//  SHNHomeViewController.m
//  网易新闻首页
//
//  Created by 苏浩楠 on 16/2/20.
//  Copyright © 2016年 suhaonan. All rights reserved.
//

#import "SHNHomeViewController.h"
#import "SHNSocialViewController.h"
#import "SHNEconomyViewController.h"
#import "SHNEntertainmentViewController.h"
#import "SHNInternationalViewController.h"
#import "SHNMilitaryViewController.h"
#import "SHNScienceViewController.h"
#import "SHNSportsViewController.h"
#import "SHNHomeLabel.h"
@interface SHNHomeViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@end

@implementation SHNHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加自控制器
    [self setUpChildVC];
    //添加标题
    [self setUpTitle];
    //默认显示第0个控制器
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
    

}

#pragma mark ---初始化标题
- (void)setUpTitle {
    
    CGFloat labelW = 100;
    CGFloat labelY = 0;
    CGFloat labelH = self.titleScrollView.frame.size.height;

    for (NSInteger i = 0; i < 7; i++) {
        SHNHomeLabel *label = [[SHNHomeLabel alloc] init];
        label.text = [self.childViewControllers[i] title];
        CGFloat labelX = i * labelW;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
        label.userInteractionEnabled = YES;
        label.tag = i;
        [self.titleScrollView addSubview:label];
        
        if (i == 0) { //最前面的label
            label.scale = 1.0;
        }
    }
    //设置contentSize
    self.titleScrollView.contentSize = CGSizeMake(7 * labelW, 0);
    self.contentScrollView.contentSize = CGSizeMake(7 * [UIScreen mainScreen].bounds.size.width, 0);
}
#pragma mark --添加自控制器
- (void)setUpChildVC {
    SHNSocialViewController *socialVC = [[SHNSocialViewController alloc] init];
    socialVC.title = @"社会";
    [self addChildViewController:socialVC];
    
    SHNEconomyViewController *economyVC = [[SHNEconomyViewController alloc] init];
    economyVC.title = @"经济";
    [self addChildViewController:economyVC];
    
    SHNEntertainmentViewController *entertainmnetVC = [[SHNEntertainmentViewController alloc] init];
    entertainmnetVC.title = @"娱乐";
    [self addChildViewController:entertainmnetVC];
    
    SHNInternationalViewController *internationalVC = [[SHNInternationalViewController alloc] init];
    internationalVC.title = @"国际";
    [self addChildViewController:internationalVC];
    SHNMilitaryViewController *militaryVC = [[SHNMilitaryViewController alloc] init];
    militaryVC.title = @"军事";
    [self addChildViewController:militaryVC];
    SHNScienceViewController *scienceVC = [[SHNScienceViewController alloc] init];
    scienceVC.title = @"科技";
    [self addChildViewController:scienceVC];
    SHNSportsViewController *sportsVC = [[SHNSportsViewController alloc] init];
    sportsVC.title = @"体育";
    [self addChildViewController:sportsVC];
}

/**
 *  监听顶部label点击
 */
- (void)labelClick:(UITapGestureRecognizer *)gesture {
    NSInteger index = gesture.view.tag;
    //让底部的内容scrollView滚动到对应的位置
    CGPoint offSet  = self.contentScrollView.contentOffset;
    offSet.x = index * self.contentScrollView.frame.size.width;
    [self.contentScrollView setContentOffset:offSet animated:YES];
    
}
#pragma mark ----UIScrollViewDelegate--
/**
 *  scrollview结束滚动动画以后就会调用这个方法（比如调用- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated的方法执行的电话结束后）
*/
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    CGFloat offsetX = scrollView.contentOffset.x;

    
    //当前位置需要显示的控制器的索引
    NSInteger index =  offsetX / width;
    
    //让对应的顶部标题居中显示
    UILabel *label = self.titleScrollView.subviews[index];
    CGPoint titleOffSet = self.titleScrollView.contentOffset;
    titleOffSet.x = label.center.x - width*0.5;
    //左边超出处理
    if (titleOffSet.x < 0) {
        titleOffSet.x = 0;
    }
    //右边超出处理
    CGFloat maxTitleOffSetX = self.titleScrollView.contentSize.width - width;
    if (titleOffSet.x > maxTitleOffSetX) {
        titleOffSet.x = maxTitleOffSetX;
    }
    
    
    [self.titleScrollView setContentOffset:titleOffSet animated:YES];
    
    //让其他label回到最初的状态(防止滑动比较快时其他label颜色设置一半)
    for (SHNHomeLabel *otherLabel in self.titleScrollView.subviews) {
        if (otherLabel != label) {
            otherLabel.scale = 0.0;
        }
    }
    
    
    //取出需要显示的控制器
    UIViewController *willShowVC = self.childViewControllers[index];
    
    //如果当前位置的view已经显示过了，就会直接返回
//    if ([willShowVC isViewLoaded])return;
    if (willShowVC.view.superview) return;
    
    //添加控制器的view到contentScrollView中
    willShowVC.view.frame = CGRectMake(offsetX, 0, width, height);
    [self.contentScrollView addSubview:willShowVC.view];
}
/**
 *  手动松开scrollview后，scrollview停止减速后就会调用这个方法
*/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
/**
 *只要scrollview在滚动，就会调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat scale = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    if (scale < 0 || scale > self.titleScrollView.subviews.count - 1) return;
    
    //获得需要操作的左边label
    NSInteger leftIndex = scale;
    SHNHomeLabel *leftLabel = self.titleScrollView.subviews[leftIndex];
    
    //获得要操作的右边的label
    NSInteger rightIndex = leftIndex +1;
    SHNHomeLabel *rightLabel = (rightIndex == self.titleScrollView.subviews.count) ?nil :self.titleScrollView.subviews[rightIndex];

    //右边比例
    CGFloat rightSacle = scale - leftIndex;
    //左边比例
    CGFloat leftScale = 1 - rightSacle;
    
    //设置label的比例
    leftLabel.scale = leftScale;
    rightLabel.scale = rightSacle;
 
}

@end
