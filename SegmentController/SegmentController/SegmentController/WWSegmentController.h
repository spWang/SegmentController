//
//  WWSegmentController.h
//  SegmentController
//
//  Created by wangshuaipeng on 16/8/16.
//  Copyright © 2016年 Mac－pro. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  分页控制器
 */
@interface WWSegmentController : UIViewController
#pragma mark - require
/** 初始化时到哪个位置 0,1,2,3... */
- (instancetype)initWithDefaultIndex:(NSInteger)defaultIndex;

/** 菜单栏文字的数组 */
@property (nonatomic, strong) NSArray <NSString *>*menuTextArray;

/** 子控制器 */
@property (nonatomic, strong) NSArray <UIViewController *>*subControllers;


#pragma mark - optional
/** 一个屏幕上最多展示多少个按钮(不支持1,没有什么卵用) */
@property (nonatomic, assign) NSInteger maxBtnCountShowInScreen;

/** 滚动条的颜色 */
@property (nonatomic, strong) UIColor *scrollBarColor;

/** 菜单栏高度 */
@property (nonatomic, assign) CGFloat menuHeight;

/** 根据状态设置menu文字颜色 */
- (void)setMenuBtnTextColor:(UIColor *)color forState:(UIControlState)state;

/** 根据状态设置menu文字字体大小(暂不能用) */
//- (void)setMenuBtnTextFont:(UIFont *)font forState:(UIControlState)state animated:(BOOL)animated;

@end

