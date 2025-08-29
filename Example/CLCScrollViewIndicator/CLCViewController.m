//
//  CLCViewController.m
//  CLCScrollViewIndicator
//
//  Created by ClockLoveCoding on 08/29/2025.
//  Copyright (c) 2025 ClockLoveCoding. All rights reserved.
//

#import "CLCViewController.h"
#import "CLCScrollViewIndicator.h"

@interface CLCViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CLCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.clc_showVerticalScrollIndicator = YES;
    self.tableView.clc_indicatorSize = 12;
    self.tableView.clc_indicatorColor = UIColor.brownColor;
    self.tableView.clc_indicatorRoundCorner = YES;
    self.tableView.clc_indicatorInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    self.tableView.clc_indicatorDynamic = NO;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

@end
