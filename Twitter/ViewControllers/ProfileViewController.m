//
//  ProfileViewController.m
//  Twitter
//
//  Created by Kaeson Ho on 2/1/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import "ProfileViewController.h"
#import "TwitterClient.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handlingLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (self.user == nil) {
        [[TwitterClient sharedInstance] verifyCredential:^(User *user, NSError *error) {
            self.user = user;
            [self updateView];
        }];
    } else {
        [self updateView];
    }
}

- (void) updateView {
    [self.bannerImage setImageWithURL:self.user.bannerImageUrl];
    [self.profileImage setImageWithURL:self.user.profileImageUrl];
    self.nameLabel.text = self.user.name;
    self.locationLabel.text = self.user.location;
    self.handlingLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenName];
    self.followerLabel.text = self.user.followersCount;
    self.followingLabel.text = self.user.followingsCount;
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

@end
