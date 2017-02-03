//
//  ComposeViewController.h
//  Twitter
//
//  Created by Kaeson Ho on 2/1/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface ComposeViewController : UIViewController
@property (weak, nonatomic) Tweet *tweet;
@property BOOL isRetweet;

@end
