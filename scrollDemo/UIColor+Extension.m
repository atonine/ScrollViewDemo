//
//  UIColor+Extension.m
//  scrollDemo
//
//  Created by 于洪志 on 2017/3/11.
//  Copyright © 2017年 于洪志. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+(UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue{
    UIColor*c  = [[UIColor alloc]initWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
    return c;
    
}

@end
