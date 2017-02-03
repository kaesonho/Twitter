//
//  DetailViewController.m
//  Twitter
//
//  Created by Kaeson Ho on 2/1/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import "DetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "ComposeViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) Tweet *tweet;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
 
    self.nameLabel.text = self.tweet.user.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.contentLabel.text = self.tweet.text;
    [self.profileImage setImageWithURL:self.tweet.user.profileImageUrl];
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    
    self.likeCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    self.timeLabel.text = [dateFormatter stringFromDate:self.tweet.createdAt];
    if (self.tweet.liked) {
        [self.likeButton.imageView setImage:[UIImage imageNamed:@"favor-icon-red@2x.png"]];
    } else {
        [self.likeButton.imageView setImage:[UIImage imageNamed:@"favor-icon@2x.png"]];
    }
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
- (IBAction)onReplyClick:(id)sender {
    
    ComposeViewController *viewController = [[ComposeViewController alloc] init];
    [viewController setIsRetweet:NO];
    [viewController setTweet:self.tweet];
    
    [self presentViewController:viewController animated:YES completion:nil];
}
- (IBAction)onRetweetClick:(id)sender {
    ComposeViewController *viewController = [[ComposeViewController alloc] init];
    [viewController setIsRetweet:YES];
    [viewController setTweet:self.tweet];
    
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
