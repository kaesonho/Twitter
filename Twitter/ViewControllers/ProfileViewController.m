//
//  ProfileViewController.m
//  Twitter
//
//  Created by Kaeson Ho on 2/1/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import "ProfileViewController.h"
#import "TwitterClient.h"
#import "TwitterTableViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ProfileViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handlingLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<Tweet *> *tweets;
@property (weak, nonatomic) IBOutlet UILabel *tagLine;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // for tableview
    self.tableView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"TwitterTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TwitterTableViewCell"];
    self.tableView.estimatedRowHeight = 250;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // fetch user data and tweets
    if (self.user == nil) {
        [[TwitterClient sharedInstance] verifyCredential:^(User *user, NSError *error) {
            self.user = user;
            [self updateView];
            [self fetchTweets];

        }];
    } else {
        [self updateView];
        [self fetchTweets];
    }
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.tableView setAllowsSelection:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    // [self fetchTweets];
    TwitterClient *instance = [TwitterClient sharedInstance];
    if (instance.dirty) {
        [self fetchTweets];
    }
    
}

- (void) onRefresh
{
    [[TwitterClient sharedInstance] getUserTweets:self.user.screenName completion:^(NSArray<Tweet *> *tweets, NSError *error) {
        if (error == nil) {
            self.tweets = tweets;
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void) fetchTweets
{
    [[TwitterClient sharedInstance] getUserTweets:self.user.screenName completion:^(NSArray<Tweet *> *tweets, NSError *error) {
        if (error == nil) {
            self.tweets = tweets;
            [self.tableView reloadData];
        }
    }];
}

- (void) updateView {
    [self.bannerImage setImageWithURL:self.user.bannerImageUrl];
    [self.profileImage setImageWithURL:self.user.profileImageUrl];
    self.nameLabel.text = self.user.name;
    self.locationLabel.text = self.user.location;
    self.handlingLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
    self.followerLabel.text = self.user.followersCount;
    self.followingLabel.text = self.user.followingsCount;
    self.tagLine.text = self.user.tagline;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table View

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TwitterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TwitterTableViewCell" forIndexPath:indexPath];
    Tweet *tweet = [self.tweets objectAtIndex:indexPath.row];
    [cell setViewController:self];
    [cell setTweet:tweet];
    [cell updateUI];
    [cell needsUpdateConstraints];

    return cell;
}

@end
