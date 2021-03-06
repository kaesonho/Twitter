//
//  TwitterListViewController.m
//  Twitter
//
//  Created by Kaeson Ho on 1/30/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import "TwitterListViewController.h"
#import "TwitterTableViewCell.h"
#import "TwitterClient.h"
#import "DetailViewController.h"
#import "Tweet.h"

@interface TwitterListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Tweet *> *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TwitterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 250;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.tableView setAllowsSelection:YES];

    UINib *nib = [UINib nibWithNibName:@"TwitterTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TwitterTableViewCell"];
    [[TwitterClient sharedInstance] getTweets:self.category completion:^(NSArray<Tweet *> *tweets, NSError *error) {
        if (error == nil) {
            self.tweets = tweets;
            [self.tableView reloadData];
        }
    }];
}

- (void) onRefresh
{
    [[TwitterClient sharedInstance] getTweets:self.category completion:^(NSArray<Tweet *> *tweets, NSError *error) {
        if (error == nil) {
            self.tweets = tweets;
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void) viewWillAppear:(BOOL)animated {
    // remove this for the rate limit
    TwitterClient *instance = [TwitterClient sharedInstance];
    if (instance.dirty) {
        [instance getTweets:self.category completion:^(NSArray<Tweet *> *tweets, NSError *error) {
            if (error == nil) {
                self.tweets = tweets;
                [self.tableView reloadData];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TwitterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TwitterTableViewCell" forIndexPath:indexPath];
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];
    [cell setTweet:tweet];
    [cell updateUI];
    [cell setViewController:self];
    [cell needsUpdateConstraints];

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *viewController = [[DetailViewController alloc]init];
    [viewController setTweet:[self.tweets objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:viewController animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
