//
//  pageTitleView.h
//  scrollDemo
//
//  Created by 于洪志 on 2017/3/8.
//  Copyright © 2017年 于洪志. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PageTitleViewDelegate <NSObject>

-(void) pageTitletView:(id)contentView selectedIndex:(NSInteger)targetIndex;

@end
@interface PageTitleView : UIView

@property(assign,nonatomic)id<PageTitleViewDelegate>delegate;


+(instancetype)initWithFrame:(CGRect)frame titles:(NSArray*)array;


-(void)setTitleWithProgress:(CGFloat)progress sourceIndex:(NSInteger)index targetIndex:(NSInteger)index;
@end
