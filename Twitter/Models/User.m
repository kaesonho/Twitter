//
//  User.m
//  Twitter
//
//  Created by Kaeson Ho on 1/30/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import "User.h"

@implementation User

- (id) initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profileImageUrl = [NSURL URLWithString:dictionary[@"profile_image_url"]];
        self.bannerImageUrl = [NSURL URLWithString:dictionary[@"profile_banner_url"]];
        self.tagline = dictionary[@"description"];
        
        int followerCount = [dictionary[@"followers_count"] integerValue];
        int followingsCount = [dictionary[@"friends_count"] integerValue];
        
        if (followerCount > 1000) {
            self.followersCount = [NSString stringWithFormat:@"%dk", followerCount/1000];
        } else {
            self.followersCount = [NSString stringWithFormat:@"%d", followerCount];
        }
        
        if (followingsCount > 1000) {
            self.followingsCount = [NSString stringWithFormat:@"%dk", followingsCount/1000];
        } else {
            self.followingsCount = [NSString stringWithFormat:@"%d", followingsCount];
        }

        self.location = dictionary[@"location"];
    }
    return self;
}

@end
