//
//  Tweet.m
//  Twitter
//
//  Created by Kaeson Ho on 1/30/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id) initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.text = dictionary[@"text"];
        self.id = dictionary[@"id"];
        if (dictionary[@"retweeted_status"]) {
            self.retweetUser = [[User alloc] initWithDictionary:dictionary[@"user"]];
            self.user = [[User alloc] initWithDictionary:dictionary[@"retweeted_status"][@"user"]];
            self.text = dictionary[@"retweeted_status"][@"text"];
        }
        NSString *createdAtString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:createdAtString];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.liked = [dictionary[@"favorited"] boolValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
    }
    return self;
}

+ (NSArray *) tweetsWithArray: (NSArray *) array
{
    NSMutableArray *tweets = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    
    return tweets;
}

@end
