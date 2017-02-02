//
//  TwitterTableViewCell.m
//  Twitter
//
//  Created by Kaeson Ho on 1/30/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import "TwitterTableViewCell.h"
#import "ComposeViewController.h"
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
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetHeightConstraint;


@end


@implementation TwitterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.text = @"My Name";
    self.handleLabel.text = @"@geniepotatogeniepotatogeniepotatogeniepotato";
    self.timeLabel.text = @"4h";
    self.contentLabel.text = @"This is a Long Message. This is a Long Message. This is a Long Message. This is a Long Message. This is a Long Message. This is a Long Message. ";

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

- (void) initFromTweetObject: (Tweet *)tweet
{
    self.contentLabel.text = tweet.text;
    self.nameLabel.text = tweet.user.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    self.timeLabel.text = [self getReletiveTime: tweet.createdAt];
    [self.profileImageView setImageWithURL: tweet.user.profileImageUrl];
    
    self.retweetButton.titleLabel.text = [NSString stringWithFormat:@" %d", tweet.retweetCount];
    self.likeButton.titleLabel.text = [NSString stringWithFormat:@" %d", tweet.favoriteCount];
    
    if (tweet.retweetUser == nil) {
        self.retweetHeightConstraint.constant = 0;
    } else {
        self.retweetHeightConstraint.constant = 24;
        self.retweetLabel.text = [NSString stringWithFormat:@"%@ Retweeted",  tweet.retweetUser.name ];
    }
    
    if (tweet.liked) {
        [self.likeButton.imageView setImage:[UIImage imageNamed:@"favor-icon-red@2x.png"]];
    } else {
        [self.likeButton.imageView setImage:[UIImage imageNamed:@"favor-icon@2x.png"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)onReplyClicked:(id)sender {
    ComposeViewController *viewController = [[ComposeViewController alloc]init];
    [self.viewController presentViewController:viewController animated:YES completion:nil];
}
- (IBAction)onRetweetClicked:(id)sender {
    ComposeViewController *viewController = [[ComposeViewController alloc]init];
    [self.viewController presentViewController:viewController animated:YES completion:nil];
}

@end
