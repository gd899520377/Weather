//
//  LZZMainViewController.m
//  Weather
//
//  Created by lucas on 5/16/13.
//  Copyright (c) 2013 lucas. All rights reserved.
//

#import "LZZMainViewController.h"
#import "LZZAddCityViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LZZUniversal.h"

@interface LZZMainViewController ()

@end

@implementation LZZMainViewController

{
    UIView *_rightBlackView;
    int _pageCount;
    LZZAddCityViewController *_acvc;
    
}

@synthesize scrollView = _scrollView;

- (void)dealloc
{
    self.scrollView = nil;
    [_acvc release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(0, 5);
    self.view.layer.shadowRadius = 4;
    self.view.layer.shadowOpacity = 2;
    _acvc = [[LZZAddCityViewController alloc] init];
    
    // 底层scrollview
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [_scrollView release];
    
    
    
    // 上部的橙色条
    UIView *topOrangeLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    topOrangeLine.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:topOrangeLine];
    [topOrangeLine release];

    // 左边的黑色
    UIView *leftBlackView = [[UIView alloc] initWithFrame:CGRectMake(-320, 0, 320, 460)];
    leftBlackView.backgroundColor = [UIColor blackColor];
    [_scrollView addSubview:leftBlackView];
    [leftBlackView release];

    // 右边的黑色
    _rightBlackView = [[UIView alloc] init];
    _rightBlackView.backgroundColor = [UIColor blackColor];
    [_scrollView addSubview:_rightBlackView];
    [_rightBlackView release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _pageCount = [[LZZUniversal allCityInNSUserDefault] count];
    
    _scrollView.contentSize = CGSizeMake(320 * _pageCount, 460);
    _rightBlackView.frame = CGRectMake(_pageCount * 320, 0, 320, 460);
    
    [self setAllCityView];
}

- (void)setAllCityView
{
    NSArray *array = [LZZUniversal allCityInNSUserDefault];
    
    // 重置前清空
    while ([_scrollView.subviews count] > 2) {
        [[_scrollView.subviews objectAtIndex:2] removeFromSuperview];
    }

    // 重置页面
    for (int i = 0; i < _pageCount; i++)
    {
        LZZCityView *cityView = [[LZZCityView alloc] initWithFrame:CGRectMake(i * 320, 0, 320, 460) Type:i CityCode:[array objectAtIndex:i] Delegate:self];
        [_scrollView addSubview:cityView];
        [cityView release];
    }
    
        
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double x = scrollView.contentOffset.x;
    int page = (int)(x-1)/320;
    double xx = x - page*320;
    UIImageView *preView = (UIImageView *)[[(UIView *)[_scrollView.subviews objectAtIndex:page + 2] subviews] objectAtIndex:0];
    preView.frame = CGRectMake(xx/4, 0, 320, 460);
    if (x < (_pageCount - 1) * 320) {
        UIImageView *nextView = (UIImageView *)[[(UIView *)[_scrollView.subviews objectAtIndex:page + 3] subviews] objectAtIndex:0];
        
        nextView.frame = CGRectMake(-80 + xx/4, 0, 320, 460);
    }
}

#pragma mark - LZZCityView Delegate Methods
- (void)addNewsCity
{
    [self presentViewController:_acvc animated:YES completion:^{
        
    }];
}

@end
