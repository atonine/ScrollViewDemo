//
//  PageContentView.m
//  scrollDemo
//
//  Created by 于洪志 on 2017/3/11.
//  Copyright © 2017年 于洪志. All rights reserved.
//

#import "PageContentView.h"

#define kCellID  @"kCellID"
@interface PageContentView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)NSMutableArray*childVcs;

@property(nonatomic,weak )UIViewController*parentViewController;

@property(nonatomic,strong)UICollectionView*collectionView;

@property(nonatomic,assign)CGFloat startOffset;

@end
@implementation PageContentView
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout*layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize  = self.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = true;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:UICollectionViewCell.self forCellWithReuseIdentifier:kCellID];
//        _collectionView = collectionView;
    }
    return _collectionView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(instancetype)initWithFrame:(CGRect)frame ChildViewControllers:(NSMutableArray *)controllers parentViewController:(UIViewController *)parentVc{
    PageContentView* pageContentView = [[PageContentView alloc]initWithFrame:frame];
    pageContentView.childVcs = controllers;
    pageContentView.parentViewController = parentVc;
    pageContentView.startOffset = 0;
    [pageContentView setUpUI];
    return pageContentView;
    
}
#pragma mark-set up UI method

-(void)setUpUI{
    for (UIViewController*vc in self.childVcs) {
        [self.parentViewController addChildViewController:vc];
        
    }
    [self addSubview:self.collectionView];
    self.collectionView.frame = self.bounds;
    
    
}
#pragma mark - collectionView data source's method

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.childVcs.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    UIViewController*childVc = self.childVcs[indexPath.item];
//    for (UIView*view in cell.subviews) {
//        [view removeFromSuperview];
//    }
    childVc.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVc.view];
    return cell;
    
}
#pragma mark - collection View delegate method
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //获取数据
  
    CGFloat progress = 0;
    NSInteger sourceIndex = 0;
    NSInteger targetIndex = 0;
    
    
    //判断左右滑
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    if (currentOffsetX>self.startOffset) {
        //左滑
        progress = currentOffsetX/scrollViewW-floor(currentOffsetX/scrollViewW);
        sourceIndex = (NSInteger)(currentOffsetX/scrollViewW);
        targetIndex = sourceIndex+1;
        if (targetIndex>=self.childVcs.count) {
            targetIndex = self.childVcs.count-1;
        }
        if (currentOffsetX-self.startOffset==scrollViewW) {
            progress = 1;
            targetIndex = sourceIndex;
        }
    }else{
        
        
        //右滑
   
        progress = 1-(currentOffsetX/scrollViewW-floor(currentOffsetX/scrollViewW));
        targetIndex = (NSInteger)(currentOffsetX/scrollViewW);
        sourceIndex = targetIndex+1;
        if (sourceIndex>=self.childVcs.count) {
            sourceIndex=self.childVcs.count-1;
        }
    }
    [self.delegate pageContentView:self progress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
    
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
      self.startOffset  = scrollView.contentOffset.x;
    
}
#pragma mark-set current index
-(void)setCurrentIndex:(NSInteger)index{
    CGFloat offsetX = index*self.collectionView.frame.size.width;
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0)];
}

@end
