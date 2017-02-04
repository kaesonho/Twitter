//
//  TwitterClient.m
//  Twitter
//
//  Created by Kaeson Ho on 1/30/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"
#import "User.h"

NSString * const kTwitterConsumerKey = @"DJyR0jAaGBuKXcIts0YZe9oj3";
NSString * const kTwitterConsumerSecret = @"rVRKiQ2mJmtICTDnCEUbOkap779nKRseU63wQGyWqRweR4ScGv";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *user, NSError *error);

@end

@implementation TwitterClient

+ (TwitterClient *) sharedInstance {
    static TwitterClient *instance = nil;
    // static dispatch_once_t onceToken;
    if (instance == nil) {
        instance = [[TwitterClient alloc] initWithBaseURL: [NSURL URLWithString: kTwitterBaseUrl] consumerKey: kTwitterConsumerKey consumerSecret: kTwitterConsumerSecret];
    }
    
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion {
    
    self.loginCompletion = completion;
    
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"get the request token!");
        
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        
        [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        NSLog(@"failed to get the requedt token");
        self.loginCompletion(nil, error);
    }];
}

- (void) openURL: (NSURL *) url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"got the access token");
        
        // just set access token to access token manager
        // [[AccessTokenManager sharedInstance]  setAccessToken:accessToken];
        [self verifyCredential:^(User *user, NSError *error) {
            self.loginCompletion(user, error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"failed to get the access token");
    }];

}

- (void)verifyCredential:(void (^)(User *user, NSError *error))completion
{
    // BDBOAuth1Credential *accessToken = [[AccessTokenManager sharedInstance] getAccessToken];
    // [self.requestSerializer saveAccessToken:accessToken];
    [self GET:@"1.1/account/verify_credentials.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        {
            User *user = [[User alloc] initWithDictionary:responseObject];
            NSLog(@"credential verified, current user name %@", user.name);
            self.user = user;
            completion(user, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to veirfy");
        completion(nil, error);
    }];
}

- (void)getTweets:(NSString *) category completion:(void (^)(NSArray<Tweet *> *tweets, NSError *error))completion
{
    NSString *path = [NSString stringWithFormat:@"1.1/statuses/%@.json", category];
    
    [self GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        {
            NSArray *tweets = [Tweet tweetsWithArray:responseObject];
            completion(tweets, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to get tweets");
        [self printRateLimit:@"statuses"];
        completion(nil, error);
    }];
}

- (void)getUserTweets:(NSString *)screenName completion:(void (^)(NSArray<Tweet *> *tweets, NSError *error))completion
{
    [self GET:@"1.1/statuses/user_timeline.json" parameters: @{@"screen_name": screenName} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        {
            NSArray *tweets;
            if (responseObject) {
                tweets = [Tweet tweetsWithArray:responseObject];
            }
            completion(tweets, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to get user tweets");
        [self printRateLimit:@"statuses"];
        completion(nil, error);
    }];

}

- (void)likeTweet:(NSString *) tweetId completion:(void (^)(NSDictionary *response, NSError *error))completion;
{
    [self POST:@"1.1/favorites/create.json" parameters:@{@"id": tweetId} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self setDirty:YES];
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to like tweet");
        [self printRateLimit:@"favorites"];
        completion(nil, error);
    }];
}

- (void)reTweet:(NSString *) tweetId completion:(void (^)(NSDictionary *response, NSError *error))completion;
{
    NSString *path = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId];
    [self POST:path parameters:@{@"id": tweetId} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self setDirty:YES];
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to retweet");
        [self printRateLimit:@"statuses"];
        completion(nil, error);
    }];
}

- (void)postTweet:(NSString *)text replyTo:(NSString *)replyId completion:(void (^)(NSDictionary *response, NSError *error))completion;
{
    NSDictionary *parameters;
    if (replyId) {
        parameters = @{@"status": text, @"in_reply_to_status_id": replyId};
    } else {
        parameters = @{@"status": text};
    }
    
    [self POST:@"1.1/statuses/update.json" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self setDirty:YES];
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to post tweet");
        [self printRateLimit:@"statuses"];
        completion(nil, error);
    }];
}

- (void)printRateLimit:(NSString *) category
{
    [self GET:@"1.1/application/rate_limit_status.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject[@"resources"][category]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to get rate limit");
    }];
}

- (bool) checkIfDirty
{
    // clear dirty and return;
    bool dirty = self.dirty;
    self.dirty = NO;
    return dirty;
}

@end
