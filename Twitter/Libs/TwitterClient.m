//
//  TwitterClient.m
//  Twitter
//
//  Created by Kaeson Ho on 1/30/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

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
        NSLog(@"failed to veirfy");
        completion(nil, error);
    }];
}

- (void)getUserTweets:(NSString *)screenName completion:(void (^)(NSArray<Tweet *> *tweets, NSError *error))completion
{
    [self GET:@"1.1/statuses/user_timeline.json" parameters: @{@"screen_name": screenName} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        {
            NSArray *tweets = [Tweet tweetsWithArray:responseObject];
            completion(tweets, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failed to veirfy");
        completion(nil, error);
    }];
}


@end
