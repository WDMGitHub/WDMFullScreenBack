//
//  DMNavigationController.m
//  DMFullScreenBack
//
//  Created by demin on 16/8/26.
//  Copyright © 2016年 Demin. All rights reserved.
//

/**
 *  导航控制器全屏滑动注意点
 *  1.禁止系统自带滑动手势使用
 *  2.只有导航控制器的非根控制器才需要触发手势，使用手势代理，控制手势触发
 */
#import "DMNavigationController.h"
#import "AppDelegate.h"

@interface DMNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation DMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@", self.interactivePopGestureRecognizer);
    
    //获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    
    //创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:NSSelectorFromString(@"handleNavigationTransition:")];
    
    //设置手势代理，拦截手势触发
    pan.delegate = self;
    
    //给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    
    //禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
}

//什么时候调用：每次触发手势之前都会询问下代理，是否触发
//作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //注意：只有非根控制器才有滑动返回功能，跟控制器没有
    //判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) return NO;
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] || [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIPanGestureRecognizer")] ) //设置该条件是避免跟tableview的删除，筛选界面展开的左滑事件有冲突
    {
        return NO;
    }
    return YES;
}

@end
