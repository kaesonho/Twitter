//
//  Tweet.h
//  Twitter
//
//  Created by Kaeson Ho on 1/30/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) User *retweetUser;
@property bool liked;
@property int favoriteCount;
@property int retweetCount;
@property bool retweeted;

- (id) initWithDictionary:(NSDictionary *) dictionary;
+ (NSArray *) tweetsWithArray: (NSArray *) array;

@end
