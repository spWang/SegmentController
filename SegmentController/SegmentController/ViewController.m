//
//  ViewController.m
//  SegmentController
//
//  Created by wangshuaipeng on 16/8/16.
//  Copyright © 2016年 Mac－pro. All rights reserved.
//

#import "ViewController.h"
#import "WWSegmentController.h"

#define WWRandomColor [UIColor colorWithRed:arc4random_uniform(255.0)/255.0 green:arc4random_uniform(255.0)/255.0 blue:arc4random_uniform(255.0)/255.0 alpha:1.0]


@interface ViewController ()
@end

@implementation ViewController

#pragma mark - lefe cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDemo];
}

#pragma mark - setup
- (void)setupDemo {
    WWSegmentController *segmentVC = [[WWSegmentController alloc]initWithDefaultIndex:1];
    segmentVC.subControllers = [self subControllersWithCount:5];
    segmentVC.menuTextArray = [self menuTitlesWithCount:6];
    //segmentVC.maxBtnCountShowInScreen = 4;
    //一切设置应该放在前边,然后在添加
    [self addChildViewController:segmentVC];
    [self.view addSubview:segmentVC.view];
    
    segmentVC.view.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64);
}

#pragma mark - getters and setters
- (NSArray <UIViewController *>*)subControllersWithCount:(NSInteger)count{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    if (!count) return  array;
    
    for (int i =0; i<count; i++) {
        [array addObject:[self controller]];
    }
    
    return array.copy;
}

- (NSArray <NSString *>*)menuTitlesWithCount:(NSInteger)count {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    if (!count) return  array;
    
    for (int i =0; i<count; i++) {
        NSString *str = [NSString stringWithFormat:@"标题%d",i];
        [array addObject:str];
    }
    
    return array.copy;
}

- (UIViewController *)controller {
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = WWRandomColor;
    return vc;
}

@end
