//
//  User.h
//  Twitter
//
//  Created by Kaeson Ho on 1/30/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSURL *profileImageUrl;
@property (nonatomic, strong) NSURL *bannerImageUrl;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *followersCount;
@property (nonatomic, strong) NSString *followingsCount;

- (id) initWithDictionary:(NSDictionary *) dictionary;

@end
