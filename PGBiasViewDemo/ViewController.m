//
//  ViewController.m
//  PGBiasViewDemo
//
//  Created by PinGuo on 15/5/4.
//  Copyright (c) 2015年 PinGuo. All rights reserved.
//

#import "ViewController.h"
#import "PGShutterView.h"

@interface ViewController ()

@property (nonatomic) PGShutterView *shutter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.5];
    self.shutter = [[PGShutterView alloc] init];
    [self.view addSubview:self.shutter];
    self.shutter.hideTheDoor = NO;
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(20, 200, 200, 30)];
    [slider addTarget:self action:@selector(changeS:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setShutterLocation:)];
    [self.view addGestureRecognizer:tap];
}

- (void)setShutterLocation:(UIGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self.view];
    self.shutter.center = point;
}

- (void)changeS:(UISlider *)slider
{
    self.shutter.value = slider.value;
}


@end
