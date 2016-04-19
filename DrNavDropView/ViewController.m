//
//  ViewController.m
//  DrNavDropView
//
//  Created by 明瑞 on 16/4/19.
//  Copyright © 2016年 DrustZ. All rights reserved.
//

#import "ViewController.h"
#import "DrNavDropView.h"

@interface ViewController () <DrNavDropViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGRect rect = CGRectMake(0, 0, 200, 40);
    UIView * container_view = [[UIView alloc] initWithFrame:rect];
    DrNavDropView * view = [[[NSBundle mainBundle] loadNibNamed:@"DrNavDropView" owner:self options:nil] objectAtIndex:0];
    [view setFrame:container_view.bounds];
    container_view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [container_view addSubview:view];
    [view setBackgroundColor:[UIColor clearColor]];
    [view configureMenuWithItems:@[@"life",@"is",@"sweet!"] withRowHeight:60 withViewController:self];
    view.delegate = self;
    self.navigationItem.titleView = container_view;
    
    [self.view setBackgroundColor:[UIColor yellowColor]];
}

- (void)menuSelectedAtIndex:(NSUInteger)index{
    switch (index) {
        case 0:
            [self.view setBackgroundColor:[UIColor yellowColor]];
            break;
        case 1:
            [self.view setBackgroundColor:[UIColor blueColor]];
            break;
        default:
            [self.view setBackgroundColor:[UIColor orangeColor]];
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
