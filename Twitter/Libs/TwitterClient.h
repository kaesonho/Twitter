//
//  TwitterClient.h
//  Twitter
//
//  Created by Kaeson Ho on 1/30/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import <BDBOAuth1Manager/BDBOAuth1SessionManager.h>
#import "Tweet.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1SessionManager
@property (nonatomic, strong) User *user;

+ (TwitterClient *) sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)verifyCredential:(void (^)(User *user, NSError *error))completion;
- (void)getTweets:(NSString *)category completion:(void (^)(NSArray<Tweet *> *tweets, NSError *error))completion;
- (void)getUserTweets:(NSString *)screenName completion:(void (^)(NSArray<Tweet *> *tweets, NSError *error))completion;
- (void)openURL:(NSURL *) url;
- (void)likeTweet:(NSString *) tweetId completion:(void (^)(NSDictionary *response, NSError *error))completion;
- (void)postTweet:(NSString *)text completion:(void (^)(NSDictionary *response, NSError *error))completion;
- (void)reTweet:(NSString *) tweetId completion:(void (^)(NSDictionary *response, NSError *error))completion;

@end
