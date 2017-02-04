//
//  TwitterTableViewCell.m
//  Twitter
//
//  Created by Kaeson Ho on 1/30/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import "TwitterTableViewCell.h"
#import "ComposeViewController.h"
#import "ProfileViewController.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface TwitterTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetHeightConstraint;


@end


@implementation TwitterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageTapped)];
    singleTap.numberOfTapsRequired = 1;
    
    [self.profileImageView setUserInteractionEnabled:YES];
    [self.profileImageView addGestureRecognizer:singleTap];
}

- (NSString *) getReletiveTime: (NSDate *) createdAt
{
    NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleAbbreviated;
    formatter.allowedUnits = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    formatter.maximumUnitCount = 1;
    NSString *elapsed = [formatter stringFromDate:createdAt toDate:[NSDate date]];
    return elapsed;
}

- (void) updateUI
{
    self.contentLabel.text = self.tweet.text;
    self.nameLabel.text = self.tweet.user.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.timeLabel.text = [self getReletiveTime: self.tweet.createdAt];
    [self.profileImageView setImageWithURL: self.tweet.user.profileImageUrl];
    [self.retweetButton setTitle:[NSString stringWithFormat:@" %d", self.tweet.retweetCount] forState:UIControlStateNormal];

    if (self.tweet.retweetUser == nil) {
        self.retweetHeightConstraint.constant = 0;
    } else {
        self.retweetHeightConstraint.constant = 24;
        self.retweetLabel.text = [NSString stringWithFormat:@"%@ Retweeted",  self.tweet.retweetUser.name ];
    }
    if (self.tweet.retweeted) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green@2x.png"] forState:UIControlStateNormal];
    } else {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon@2x.png"] forState:UIControlStateNormal];
    }
    
    if (self.tweet.liked) {
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red@2x.png"] forState:UIControlStateNormal];
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon@2x.png"] forState:UIControlStateNormal];
    }
    
    [self.likeButton setTitle:[NSString stringWithFormat:@" %d", self.tweet.favoriteCount] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)onReplyClicked:(id)sender {
    ComposeViewController *viewController = [[ComposeViewController alloc]init];
    [viewController setTweet:self.tweet];
    [viewController setIsRetweet:NO];
    [self.viewController presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)onRetweetClicked:(id)sender {
    ComposeViewController *viewController = [[ComposeViewController alloc]init];
    [viewController setTweet:self.tweet];
    [viewController setIsRetweet:YES];
    [self.viewController presentViewController:viewController animated:YES completion:nil];
}

-(void) onImageTapped {
    ProfileViewController *viewController = [[ProfileViewController alloc]init];
    [viewController setUser: self.tweet.user];
    [self.viewController.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onLikeClicked:(id)sender {
    [[TwitterClient sharedInstance] likeTweet:self.tweet.id completion:^(NSDictionary *response, NSError *error) {
        [self.likeButton.imageView setImage:[UIImage imageNamed:@"favor-icon-red@2x.png"]];
    }];
}

@end
