//
//  ComposeViewController.m
//  Twitter
//
//  Created by Kaeson Ho on 2/1/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import "ComposeViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textField;

@property (weak, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [TwitterClient sharedInstance].user;
    
    if (!self.user) {
        [[TwitterClient sharedInstance] verifyCredential:^(User *user, NSError *error) {
            self.user = user;
            [self.profileImage setImageWithURL:self.user.profileImageUrl];
        }];
    } else {
        [self.profileImage setImageWithURL:self.user.profileImageUrl];
    }
    
    if (self.isRetweet) {
        self.textField.text = self.tweet.text;
    } else {
        if (self.tweet) {
            self.textField.text = [NSString stringWithFormat: @"@%@", self.tweet.user.screenName];
        } else {
            self.textField.text = @"";
        }
    }
}
- (IBAction)closeModal:(id)sender {
     [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)onTweetClicked:(id)sender {
    if (self.isRetweet) {
        [[TwitterClient sharedInstance] reTweet:self.tweet.id completion:^(NSDictionary *response, NSError *error) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }];
    } else {
        [[TwitterClient sharedInstance] postTweet:self.textField.text completion:^(NSDictionary *response, NSError *error) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

@end
