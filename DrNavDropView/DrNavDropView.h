//
//  DrNavDropView.h
//  DrNavDropView
//
//  Created by 明瑞 on 16/4/19.
//  Copyright © 2016年 DrustZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DrNavDropViewDelegate <NSObject>
- (void)menuSelectedAtIndex:(NSUInteger)index;
@end

@interface DrNavDropView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableview;
@property (nonatomic, weak) id<DrNavDropViewDelegate> delegate;

- (void)configureMenuWithItems:(NSArray*)items withRowHeight:(CGFloat)rowh withViewController:(UIViewController*)controller;

- (void)configureMenuWithItems:(NSArray*)items defaultSelectedIndex:(NSUInteger)idx maxHeight:(CGFloat)height width:(CGFloat)width withRowHeight:(CGFloat)rowh withViewController:(UIViewController*)controller;

- (void)setSelectedColor:(UIColor*)color;

@end
