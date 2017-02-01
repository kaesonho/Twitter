//
//  TwitterTableViewCell.m
//  Twitter
//
//  Created by Kaeson Ho on 1/30/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import "TwitterTableViewCell.h"
#import "Tweet.h"
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;


@end


@implementation TwitterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.text = @"My Name";
    self.handleLabel.text = @"@geniepotatogeniepotatogeniepotatogeniepotato";
    self.timeLabel.text = @"4h";
    self.contentLabel.text = @"This is a Long Message. This is a Long Message. This is a Long Message. This is a Long Message. This is a Long Message. This is a Long Message. ";

}

- (void) initFromTweetObject: (Tweet *)tweet
{
    self.contentLabel.text = tweet.text;
    self.nameLabel.text = tweet.user.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    // self.timeLabel.text = [tweet.createdAt timeIntervalSinceNow];
    NSURL *profileImageUrl = [NSURL URLWithString:tweet.user.profileImageUrl];
    [self.profileImageView setImageWithURL: profileImageUrl];
    
    if (tweet.retweetUser == nil) {
        self.retweetHeightConstaints.constant = 0;
    } else {
        self.retweetLabel.text = [NSString stringWithFormat:@"%@ Retweeted",  tweet.retweetUser.name ];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
