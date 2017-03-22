//
//  HomeViewController.m
//  scrollDemo
//
//  Created by 于洪志 on 2017/3/8.
//  Copyright © 2017年 于洪志. All rights reserved.
//



#import "HomeViewController.h"
#import "pageTitleView.h"

#import "PageContentView.h"
#import "UIColor+Extension.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width 
#define kScreenH [UIScreen mainScreen].bounds.size.height 
#define kStatusBarH (CGFloat)20

#define kNavigationBarH (CGFloat)44

#define kTabBarH (CGFloat)44


#define kTitleViewH (CGFloat)40

@interface HomeViewController ()<PageTitleViewDelegate,PageContentViewDelegate>

@property(strong,nonatomic)PageTitleView*pageTitleView;

@property(strong,nonatomic)PageContentView*pageContentView;

@end

@implementation HomeViewController
-(PageTitleView *)pageTitleView{
    
    CGRect frame = CGRectMake(0,  64, [[UIScreen mainScreen] bounds].size.width, 40  );
    NSArray*titles = @[@"游戏",@"推荐",@"国际",@"国内"];
    if (!_pageTitleView) {
        __weak typeof(self) weakSelf=self;
        _pageTitleView= [PageTitleView initWithFrame:frame titles:titles];
        _pageTitleView.delegate = weakSelf;
        [self.view addSubview:_pageTitleView];
    }
   
    return _pageTitleView;
}

-(PageContentView *)pageContentView{
    if (!_pageContentView) {
        NSMutableArray*childVcs = [NSMutableArray array];
        CGFloat contentH = kScreenH - kStatusBarH - kNavigationBarH-kTitleViewH - kTabBarH;
        CGRect contentFrame = CGRectMake(0, kStatusBarH+kNavigationBarH+kTitleViewH, kScreenW, contentH);
        for (int i = 0; i<4; i++) {
            UIViewController*vc = [[UIViewController alloc]init];
            vc.view.backgroundColor = [UIColor colorWithRed:(CGFloat)arc4random_uniform(255) green:(CGFloat)arc4random_uniform(255)  blue:(CGFloat)arc4random_uniform(255) ];
            [childVcs addObject:vc];
            
        }
        __weak typeof(self) weakSelf=self;
        _pageContentView  = [PageContentView initWithFrame:contentFrame ChildViewControllers:childVcs parentViewController:self];
        _pageContentView.delegate = weakSelf;
    }
    return _pageContentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self pageTitleView];
    [self setupUI];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupUI{
    
    [self.view addSubview:self.pageContentView];
    self.pageContentView.backgroundColor = [UIColor purpleColor];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark-title view's delegate method

-(void)pageTitletView:(id)contentView selectedIndex:(NSInteger)targetIndex{
    [self.pageContentView setCurrentIndex:targetIndex];
}
#pragma mark-content view's delegate
-(void)pageContentView:(id)contentView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex{
    
    [self.pageTitleView setTitleWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
}
@end
