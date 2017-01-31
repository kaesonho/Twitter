//
//  TwitterListViewController.m
//  Twitter
//
//  Created by Kaeson Ho on 1/30/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import "TwitterListViewController.h"
#import "TwitterTableViewCell.h"

@interface TwitterListViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TwitterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    UINib *nib = [UINib nibWithNibName:@"TwitterTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TwitterTableViewCell"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TwitterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TwitterTableViewCell" forIndexPath:indexPath];
    
    if (indexPath.row % 2) {
        cell.retweetHeightConstaints.constant = 0;
    } else {
        cell.retweetHeightConstaints.constant = 24;
    }
    
    [cell needsUpdateConstraints];
    
    return cell;
}


@end
