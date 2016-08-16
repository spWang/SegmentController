//
//  WWTopMenuView.h
//  SegmentController
//
//  Created by wangshuaipeng on 16/8/16.
//  Copyright © 2016年 Mac－pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWTopMenuView : UIView

- (instancetype)initWithFrame:(CGRect)frame menuTextArray:(NSArray *)menuTextArray maxBtnCountShowInScreen:(NSInteger)maxBtnCountShowInScreen;

- (void)animateViewWithOffsetX:(CGFloat)offsetX;

@property (nonatomic, assign) CGFloat menuWidth;

@property (nonatomic, weak)   UIScrollView *scollView;

@property (nonatomic, copy)   void(^clickMenuBlock)(CGFloat offSetX);

@end
