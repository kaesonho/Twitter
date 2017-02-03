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
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupButtons];
    
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
        self.nameLabel.text = self.tweet.user.name;
        self.handleLabel.text = self.tweet.user.screenName;
        self.contentLabel.text = self.tweet.text;
        self.textHeightConstraint.constant = 0;
        [self updateViewConstraints];
    } else {
        if (self.tweet) {
            self.textField.text = [NSString stringWithFormat: @"@%@", self.tweet.user.screenName];
        }
    }
}

- (void) setupButtons {

    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0)];

    [self.view addSubview:navBar];
    
    NSString *submitText = @"";
    if (self.isRetweet) {
        submitText = @"Retweet";
    } else {
        submitText = @"Tweet";
    }
    
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc]
                                    initWithTitle:submitText
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onTweetClicked:)];
    
    self.navigationController.navigationBar.topItem.rightBarButtonItem = tweetButton;
        
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Cancel"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(closeModal:)];
    
    UINavigationItem *navigItem = [[UINavigationItem alloc] init];
    
    navigItem.leftBarButtonItem = logoutButton;
    navigItem.rightBarButtonItem = tweetButton;
    
    navBar.items = [NSArray arrayWithObjects: navigItem,nil];
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
