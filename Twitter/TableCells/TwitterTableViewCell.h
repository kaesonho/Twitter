//
//  TwitterTableViewCell.h
//  Twitter
//
//  Created by Kaeson Ho on 1/30/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TwitterTableViewCell : UITableViewCell

@property (weak, nonatomic) UIViewController *viewController;

- (void) initFromTweetObject: (Tweet *)tweet;

@end
