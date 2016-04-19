//
//  DrNavDropView.m
//  DrNavDropView
//
//  Created by 明瑞 on 16/4/19.
//  Copyright © 2016年 DrustZ. All rights reserved.
//

#import "DrNavDropView.h"
@interface DrNavDropView()
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) NSUInteger selIdx;

@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) UIFont  * font;
@property (nonatomic, strong) NSArray * menuItems;
@property (nonatomic, strong) UIColor * selectedColor;
@property (nonatomic, strong) UIView  * maskView;

@property (nonatomic, weak) UIViewController * controller;
@end

@implementation DrNavDropView

- (void)awakeFromNib{
    [self setBackgroundColor:[UIColor clearColor]];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleView)];
    [self addGestureRecognizer:tap];
    
    self.rowHeight = 60;
    [self.titleLabel setUserInteractionEnabled:NO];
    [self.arrow setUserInteractionEnabled:NO];
    self.arrow.clipsToBounds = YES;
    
    _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_maskView setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.2]];
    [_maskView setUserInteractionEnabled:YES];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HideMenu)];
    [_maskView addGestureRecognizer:tap];
}

- (void)configureMenuWithItems:(NSArray*)items withRowHeight:(CGFloat)rowh withViewController:(UIViewController*)controller{
    [self configureMenuWithItems:items defaultSelectedIndex:0 maxHeight:([UIScreen mainScreen].bounds.size.height-controller.navigationController.navigationBar.bounds.size.height-controller.navigationController.navigationBar.frame.origin.y) width:[UIScreen mainScreen].bounds.size.width withRowHeight:rowh withViewController:controller];
}

- (void)configureMenuWithItems:(NSArray*)items defaultSelectedIndex:(NSUInteger)idx maxHeight:(CGFloat)height width:(CGFloat)width withRowHeight:(CGFloat)rowh withViewController:(UIViewController*)controller{
    self.maxHeight = height;
    self.width = width;
    
    self.tableview = [UITableView new];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableview setFrame:CGRectMake(0, 0, width, height)];
    self.rowHeight = rowh;
    _controller = controller;
    self.menuItems = [NSArray arrayWithArray:items];
    _selIdx = idx;
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setText:items[idx]];
    _selectedColor = [UIColor blueColor];
    [self.tableview setHidden:YES];
    [self.maskView setHidden:YES];
    [self.controller.view addSubview:self.maskView];
    [self.controller.view addSubview:self.tableview];
    self.controller.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setSelectedColor:(UIColor*)color{
    self.selectedColor = color;
}

- (void)setCellFont:(UIFont*)font{
    _font = font;
}

//handle tap
- (void)toggleView {
    if (self.maskView.isHidden)
        [self ShowMenu];
    else
        [self HideMenu];
}

- (void)ShowMenu {
    [self.controller.view bringSubviewToFront:self.maskView];
    [self.controller.view bringSubviewToFront:self.tableview];
    CGFloat centerx = [UIScreen mainScreen].bounds.size.width/2;

    if (self.rowHeight * _menuItems.count < self.maxHeight){
        [self.tableview setFrame:CGRectMake(0, 0, self.width, self.rowHeight * _menuItems.count)];
        [self.tableview setScrollEnabled:false];
    }
    [self.tableview setCenter:CGPointMake(centerx, -self.tableview.frame.size.height/2)];
    
    [self.tableview setHidden:NO];
    [self.maskView setHidden:NO];
    
    [UIView animateWithDuration:0.35f animations:^{
        [self.arrow setImage:[UIImage imageNamed:@"arrowup"]];
        [self.tableview setCenter:CGPointMake(centerx, _controller.navigationController.navigationBar.frame.size.height+_controller.navigationController.navigationBar.frame.origin.y+self.tableview.bounds.size.height/2)];
    }];
}

- (void)HideMenu {
    [self.maskView setHidden:YES];
    
    CGFloat centerx = [UIScreen mainScreen].bounds.size.width/2;
    
    [UIView animateWithDuration:0.35f animations:^{
        [self.arrow setImage:[UIImage imageNamed:@"arrowdown"]];
        [self.tableview setCenter:CGPointMake(centerx, -self.tableview.frame.size.height/2)];
    } completion:^(BOOL finished) {
        [self.tableview setHidden:YES];
    }];
}

#pragma mark uitableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.menuItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];

    if (indexPath.row == _selIdx)
        [cell.textLabel setTextColor:_selectedColor];
    else
        [cell.textLabel setTextColor:[UIColor blackColor]];
    [cell setBackgroundColor:[UIColor whiteColor]];
    if (_font)
        [cell.textLabel setFont:_font];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.textLabel setText:self.menuItems[indexPath.row]];
    
    return cell;
}

#pragma mark uitableview delegate
-  (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selIdx inSection:0]];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.textLabel setTextColor:_selectedColor];
    _selIdx = indexPath.row;
    
    if (self.delegate){
        [self.delegate menuSelectedAtIndex:indexPath.row];
    }
    self.titleLabel.text = self.menuItems[indexPath.row];
    [self HideMenu];
}
@end
