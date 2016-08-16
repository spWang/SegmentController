//
//  WWSegmentController.m
//  SegmentController
//
//  Created by wangshuaipeng on 16/8/16.
//  Copyright © 2016年 Mac－pro. All rights reserved.
//

#import "WWSegmentController.h"
#import "WWTopMenuView.h"

#define WWCheckData if (!self.menuTextArray.count || !self.subControllers.count) return;
@interface WWSegmentController ()<UIScrollViewDelegate>
@property (nonatomic,strong) WWTopMenuView * menuView;
@property (nonatomic,strong) UIScrollView * segmentScrollView;
@property (nonatomic, assign) NSInteger defaultIndex;

@end

@implementation WWSegmentController

#pragma mark - life cycle
- (instancetype)initWithDefaultIndex:(NSInteger)defaultIndex {
    if (self = [super init]) {
        defaultIndex = (defaultIndex == 0) ? 1 : defaultIndex;
        self.defaultIndex = defaultIndex;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.defaultIndex = self.defaultIndex > self.menuTextArray.count ? 1 : self.defaultIndex;
    
    WWCheckData
    
    [self setupSubView];
    [self setupFrame];
    
    if (self.defaultIndex != 1) return;
    [self.menuView animateViewWithOffsetX:0];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    WWCheckData
    //去添加第一个控制器
    [self scrollViewDidEndDecelerating:self.segmentScrollView];
}

#pragma mark - setup
- (void)setupSubView {
    [self.view addSubview:self.segmentScrollView];
    [self.view addSubview:self.menuView];
    
    __weak typeof(self) weakSelf = self;
    [self.menuView setClickMenuBlock:^(CGFloat offSetX) {
        [weakSelf.segmentScrollView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
        [weakSelf addSubControllerWithOffSetX:offSetX];
    }];
}

- (void)setupFrame {
    
    CGFloat w = self.view.frame.size.width;
    self.menuView.menuWidth = w;
    CGFloat y = CGRectGetMaxY(self.menuView.bounds);
    CGFloat h = self.view.frame.size.height - y;
    
    _segmentScrollView.frame = CGRectMake(0, y, w, h);
    _segmentScrollView.contentSize = CGSizeMake(w * self.subControllers.count, 0);
    _segmentScrollView.contentOffset = CGPointMake((self.defaultIndex - 1)* _segmentScrollView.bounds.size.width, 0);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.menuView animateViewWithOffsetX:scrollView.contentOffset.x];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.menuView.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.menuView.userInteractionEnabled = YES;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self addSubControllerWithOffSetX:scrollView.contentOffset.x];
}

#pragma mark - private
- (void)addSubControllerWithOffSetX: (CGFloat)offSetX {
    CGFloat progress = offSetX / _segmentScrollView.contentSize.width;
    self.defaultIndex = (NSInteger)(progress*self.menuTextArray.count);
    UIViewController *subVC = self.subControllers[self.defaultIndex];
    
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height - CGRectGetMaxY(self.menuView.bounds);
    if ([self.childViewControllers containsObject:subVC]){
        subVC.view.frame = CGRectMake(w * self.defaultIndex, 0, w, h);
        return;
    }
    
    [self addChildViewController:subVC];
    [self.segmentScrollView addSubview:subVC.view];
    subVC.view.frame = CGRectMake(w * self.defaultIndex, 0, w, h);
}

//以最少数量的数组为准
- (NSArray *)dealBigArray:(NSArray *)bigArray withSmallArray:(NSArray *)smallArray {
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:smallArray.count];
    for (int i = 0; i<smallArray.count; i++) {
        [temp addObject:bigArray[i]];
    }
    return temp.copy;
}

#pragma mark - public
- (void)setMenuBtnTextColor:(UIColor *)color forState:(UIControlState)state {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!color) return;
        
        for (UIButton *btn in [_menuView valueForKeyPath:@"menuBtns"]) {
            [btn setTitleColor:color forState:state];
        }
    });
}

//- (void)setMenuBtnTextFont:(UIFont *)font forState:(UIControlState)state animated:(BOOL)animated{
//    for (UIButton *btn in _menuView.menuBtns) {
//        btn.titleLabel.font = btn.state == state ? font : btn.titleLabel.font;
//    }
//}

#pragma mark - getters and setters
- (UIScrollView *)segmentScrollView {
    if (!_segmentScrollView) {
        _segmentScrollView = [[UIScrollView alloc]init];
        _segmentScrollView.delegate = self;
        _segmentScrollView.bounces = NO;
        _segmentScrollView.pagingEnabled = YES;
        _segmentScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _segmentScrollView;
}

- (NSArray<NSString *> *)menuTextArray {
    if (_menuTextArray.count <= _subControllers.count) return _menuTextArray;
    
    _menuTextArray = [self dealBigArray:_menuTextArray withSmallArray:_subControllers];
    return _menuTextArray;
}

- (NSArray<UIViewController *> *)subControllers {
    if (_subControllers.count <= _menuTextArray.count) return _subControllers;
    
    _subControllers = [self dealBigArray:_subControllers withSmallArray:_menuTextArray];
    return _subControllers;
}

- (UIView *)menuView {
    if (!_menuView) {
        _menuView = [[WWTopMenuView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.menuHeight) menuTextArray:self.menuTextArray maxBtnCountShowInScreen:self.maxBtnCountShowInScreen];
        _menuView.scollView = _segmentScrollView;
    }
    return _menuView;
}

- (CGFloat)menuHeight {
    return _menuHeight == 0 ? 40 : _menuHeight;
}

- (void)setScrollBarColor:(UIColor *)scrollBarColor {
    _scrollBarColor = scrollBarColor;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_menuView setValue:scrollBarColor forKeyPath:@"_animateView.backgroundColor"];
    });
}
@end
