//
//  RankingViewController.m
//  MemoryTest
//
//  Created by SDT-1 on 2014. 1. 22..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "RankingViewController.h"
#import "User.h"
#import "UserCell.h"

@interface RankingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation RankingViewController

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID" forIndexPath:indexPath];
    User *one = [self.data objectAtIndex:indexPath.row];
    
    cell.name.text = one.name;
    cell.score.text = [NSString stringWithFormat:@"%d", one.score];
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSLog(@"%d", self.score);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
