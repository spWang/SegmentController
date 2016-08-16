//
//  WWTopMenuView.m
//  SegmentController
//
//  Created by wangshuaipeng on 16/8/16.
//  Copyright © 2016年 Mac－pro. All rights reserved.
//

#import "WWTopMenuView.h"

@interface WWTopMenuView()
@property (nonatomic, strong) UIScrollView *menuScrollView;
@property (nonatomic, strong) UIButton *preBtn;/** 菜单上个选中的按钮 */
@property (nonatomic, assign) NSInteger selectIndex;/** 菜单当前选中按钮索引 */
@property (strong, nonatomic) UIView *animateView;
@property (weak, nonatomic)   NSLayoutConstraint *animateconstraintLeft;
@property (nonatomic, strong) NSArray <NSString *>*menuTextArray;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, assign) NSInteger maxBtnCountShowInScreen;
@property (nonatomic, strong) NSMutableArray <UIButton *>*menuBtns;
@property (nonatomic, assign) CGFloat maxOffsetXInMenu;/** 菜单能滚动的最大offsetX */

@end

@implementation WWTopMenuView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame menuTextArray:(NSArray *)menuTextArray maxBtnCountShowInScreen:(NSInteger)maxBtnCountShowInScreen {
    self = [super initWithFrame:frame];
    if (self) {
        self.menuTextArray = menuTextArray;
        
        if (maxBtnCountShowInScreen == 0 || maxBtnCountShowInScreen >= menuTextArray.count) {
            self.maxBtnCountShowInScreen = menuTextArray.count;
        }else {
            self.maxBtnCountShowInScreen = maxBtnCountShowInScreen;
        }
        
        [self setupScrollView];
        [self setupSubBtn];
        
        
        if ([self canShowAnimateView]) {
            [self setupAnimateView];
        }
        [self setupBottomLine];
    }
    return self;
}


#pragma mark - setup
- (void)setupScrollView {
    [self addSubview:self.menuScrollView];
    CGFloat btnW = self.bounds.size.width / self.maxBtnCountShowInScreen;
    self.menuScrollView.contentSize = CGSizeMake(btnW * self.menuTextArray.count, 0);
}

- (void)setupSubBtn {
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = self.bounds.size.width/self.maxBtnCountShowInScreen;
    CGFloat btnH = self.bounds.size.height;
    for (int i = 0; i < self.menuTextArray.count; i++) {
        btnX = i*btnW;
        UIButton *btn = [self ww_button];
        [btn setTitle:self.menuTextArray[i] forState:UIControlStateNormal];
        
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.menuScrollView addSubview:btn];
        [self.menuBtns addObject:btn];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

- (void)setupAnimateView {
    [self addSubview:self.animateView];
    
    NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem:self.animateView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:self.bounds.size.width/self.maxBtnCountShowInScreen];
    NSLayoutConstraint *constraintHeight = [NSLayoutConstraint constraintWithItem:self.animateView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:2];
    NSLayoutConstraint *constraintBottom = [NSLayoutConstraint constraintWithItem:self.animateView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *constraintLeft = [NSLayoutConstraint constraintWithItem:self.animateView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    self.animateconstraintLeft = constraintLeft;
    
    [self addConstraint:constraintWidth];
    [self addConstraint:constraintHeight];
    [self addConstraint:constraintBottom];
    [self addConstraint:constraintLeft];
}

- (void)setupBottomLine {
    [self addSubview:self.bottomLineView];
    self.bottomLineView.frame = CGRectMake(0, CGRectGetMaxY(self.frame)-0.5, self.bounds.size.width, 0.5);
}

#pragma mark - action
- (void)btnClick:(UIButton *)btn {
    if (!_scollView || self.preBtn == btn) return;
    
    [self selectBtnWithBtn:btn];
    
    CGFloat offSetX = _scollView.contentSize.width/self.menuTextArray.count * btn.tag;
    !self.clickMenuBlock ?: self.clickMenuBlock(offSetX);
}

- (void)selectBtnWithBtn:(UIButton *)btn {
    self.preBtn.selected = NO;
    btn.selected = YES;
    self.preBtn = btn;
}

#pragma mark - private
- (BOOL)canShowAnimateView {
    return !self.maxBtnCountShowInScreen || self.maxBtnCountShowInScreen>=self.menuTextArray.count;
}

#pragma mark - Public
- (void)animateViewWithOffsetX:(CGFloat)offsetX {
    //1.改动滚动条
    if ([self canShowAnimateView]) {
        CGFloat progress = offsetX / self.scollView.contentSize.width;
        self.animateconstraintLeft.constant = progress * self.menuWidth;
        [self layoutIfNeeded];
    }
    
    //2.选中按钮
    self.selectIndex = round(offsetX / self.scollView.bounds.size.width);
    [self selectBtnWithBtn:self.menuBtns[self.selectIndex]];
    
    //3.包含滚动条说明不需要滚动
    if ([self.subviews containsObject:self.animateView]) return;
    
    //4.没到第一个可以滚动的索引时,不滚动
    NSInteger minIndexCanScroll = (self.maxBtnCountShowInScreen-1)/2+1;
    if (self.selectIndex < minIndexCanScroll) {
        [self.menuScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        return;
    }
    
    //5.屏幕展示btn为偶数时,调整选中按钮居中
    CGFloat menuOffsetX = (self.selectIndex-1)*self.preBtn.bounds.size.width;
    if (self.maxBtnCountShowInScreen%2 == 0) {
        menuOffsetX -= 0.5*self.preBtn.bounds.size.width;
        if (self.maxBtnCountShowInScreen == 2) {
            menuOffsetX += self.preBtn.bounds.size.width;
        }
    }
    
    
    //6.最大的offsetX
    menuOffsetX = (menuOffsetX > self.maxOffsetXInMenu) ? self.maxOffsetXInMenu : menuOffsetX;
    
    //7.设置偏移量
    [self.menuScrollView setContentOffset:CGPointMake(menuOffsetX, 0) animated:YES];
}

#pragma mark - getters and setters
- (void)setMenuWidth:(CGFloat)menuWidth {
    _menuWidth = menuWidth;
    CGRect frame = self.frame;
    frame.size.width = menuWidth;
    self.frame = frame;
}

- (UIButton *)ww_button {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    return btn;
}

- (UIView *)animateView {
    if (!_animateView) {
        _animateView = [[UIView alloc]init];
        _animateView.translatesAutoresizingMaskIntoConstraints = NO;
        _animateView.backgroundColor = [UIColor blueColor];
    }
    return _animateView;
}

- (NSMutableArray *)menuBtns {
    if (!_menuBtns) {
        _menuBtns = [NSMutableArray arrayWithCapacity:1];
    }
    return _menuBtns;
}

- (UIScrollView *)menuScrollView {
    if (!_menuScrollView) {
        _menuScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _menuScrollView.showsHorizontalScrollIndicator = NO;
        _menuScrollView.bounces = NO;
    }
    return _menuScrollView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]init];
        _bottomLineView.backgroundColor = [UIColor lightGrayColor];;
    }
    return _bottomLineView;
}

- (CGFloat)maxOffsetXInMenu {
    if (_maxOffsetXInMenu != 0) return _maxOffsetXInMenu;
    _maxOffsetXInMenu = self.menuScrollView.contentSize.width-self.menuScrollView.bounds.size.width;
    return _maxOffsetXInMenu;
}
@end
