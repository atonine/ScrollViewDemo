//
//  pageTitleView.m
//  scrollDemo
//
//  Created by 于洪志 on 2017/3/8.
//  Copyright © 2017年 于洪志. All rights reserved.
//

#define kScrollLineH 2
#define kSelectedColor @[@255,@128,@0]
#define kNomalColor  @[@85,@85,@85]

#define kSelectedRed 255
#define kSelectedGreen 128
#define kSelectedBlue 0

#define kNomalRed 85
#define kNomalGreen 85
#define kNomalBlue 85

#import "PageTitleView.h"
#import "UIColor+Extension.h"
@interface PageTitleView ()

@property(copy,nonatomic)NSArray*titles;

@property(strong,nonatomic)UIScrollView*scrollView;


@property(strong,nonatomic)UIView*scrollLine;

@property(copy,nonatomic)NSMutableArray*titleLabels;
@property(assign,nonatomic)NSInteger currentIndex;

@end

@implementation PageTitleView



-(UIScrollView *)scrollView{
    //UIScrollView*scrollView = [[UIScrollView alloc]init];
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.pagingEnabled = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.bounces = NO;
        
      
        
    }
    return _scrollView;
}
-(UIView *)scrollLine{
    if (!_scrollLine) {
        _scrollLine = [[UIView alloc]init];
        _scrollLine.backgroundColor = [UIColor orangeColor];
        
    }
    return _scrollLine;
}


-(NSMutableArray *)titleLabels{
    if (!_titleLabels) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}
+(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)array{
    PageTitleView*pageTitleView = [[PageTitleView alloc]initWithFrame:frame];
    
    pageTitleView.titles = array;
    [pageTitleView setTitleLabels];
    [pageTitleView setupUI];
    [pageTitleView setupBottomLineAndScrollLine];
    pageTitleView.currentIndex = 0;
    return pageTitleView;
    
}




-(void)setupUI{
    
    [self addSubview:self.scrollView];
    self.scrollView.frame = self.bounds;
    
}
-(void)setTitleLabels{
    NSInteger index = 0;
    CGFloat labelW = self.frame.size.width/(CGFloat)self.titles.count;
    
    NSLog(@"%f",self.frame.size.height);
    CGFloat labelH = self.frame.size.height-2;
    NSLog(@"%f",labelH);
    
    
    CGFloat labelY = 0;
    for (NSString*title in self.titles) {
        UILabel*label = [[UILabel alloc]init];
        NSLog(@"%@",title);
        label.text = title;
        label.tag = index;
        label.font = [UIFont systemFontOfSize:16.0];
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        //
        CGFloat labelX  = labelW*index;
        NSLog(@"%f",labelX);
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        [self.scrollView addSubview:label];
        [self.titleLabels addObject:label];
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleLabelClickedWithGes:)];
        [label addGestureRecognizer:tapGes];
        index++;
    }
}


-(void)setupBottomLineAndScrollLine{
    UIView*bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    CGFloat lineH = 0.5;
    bottomLine.frame = CGRectMake(0, self.frame.size.height-lineH, self.frame.size.width, lineH);
    [self addSubview:bottomLine];
    
    if(self.titleLabels!=nil){
        UILabel*firstLabel = [self.titleLabels firstObject];
        firstLabel.textColor = [UIColor colorWithRed:kSelectedRed green:kSelectedGreen blue:kSelectedBlue];
        self.scrollLine.frame = CGRectMake(firstLabel.frame.origin.x, self.frame.size.height-kScrollLineH, firstLabel.frame.size.width, 2.0);
        [self.scrollView addSubview:self.scrollLine];
        
        
    }else{
        return;
    }
    
    
    
    
    
    
}
#pragma mark - listening to click label

-(void)titleLabelClickedWithGes:(UITapGestureRecognizer*)ges{
    
    if (ges.view) {
        UILabel *currentLabel = (UILabel*)ges.view;
        UILabel*oldLabel = self.titleLabels[self.currentIndex];
        self.currentIndex = currentLabel.tag;
        currentLabel.textColor = [UIColor orangeColor];
        oldLabel.textColor = [UIColor darkGrayColor];
        CGFloat scrollLineX = currentLabel.tag*self.scrollLine.frame.size.width;
        [UIView animateWithDuration:0.15 animations:^{
            self.scrollLine.frame = CGRectMake(scrollLineX, self.frame.size.height-kScrollLineH, currentLabel.frame.size.width, 2.0);
        }];
        [self.delegate pageTitletView:self selectedIndex:self.currentIndex];
    }else{
        return;
    }
}

#pragma mark - public method of setting title View with Progress
-(void)setTitleWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex{
    UILabel *souceLabel = self.titleLabels[sourceIndex];
    UILabel *targetLabel = self.titleLabels[targetIndex];
    
    
    CGFloat moveTotalX = targetLabel.frame.origin.x-souceLabel.frame.origin.x;
    CGFloat moveX = moveTotalX * progress;
    self.scrollLine.frame = CGRectMake(souceLabel.frame.origin.x+moveX , self.frame.size.height-kScrollLineH, souceLabel.frame.size.width, 2.0);
    
    float deltaRed = kSelectedRed - kNomalRed;
    
    float deltaGreen = kSelectedGreen - kNomalGreen;
    float deltaBlue = kSelectedBlue - kNomalBlue;
    
    souceLabel.textColor = [UIColor colorWithRed:kSelectedRed-deltaRed*progress green:kSelectedGreen-deltaGreen*progress blue:kSelectedBlue - deltaBlue*progress];
    targetLabel.textColor=  [UIColor colorWithRed:kNomalRed+deltaRed*progress green:kNomalGreen+deltaGreen*progress blue:kNomalBlue+deltaBlue*progress];
    self.currentIndex = targetIndex;
}

@end
