//
//  PageContentView.h
//  scrollDemo
//
//  Created by 于洪志 on 2017/3/11.
//  Copyright © 2017年 于洪志. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageContentViewDelegate <NSObject>

-(void) pageContentView:(id)contentView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;

@end

@interface PageContentView : UIView
@property(assign,nonatomic)id<PageContentViewDelegate>delegate;
+(instancetype)initWithFrame:(CGRect)frame ChildViewControllers:(NSMutableArray*)controllers parentViewController:(UIViewController*)parentVc;
-(void)setCurrentIndex:(NSInteger)index;
@end
