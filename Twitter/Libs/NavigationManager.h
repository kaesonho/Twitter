//
//  NavigationManager.h
//  Twitter
//
//  Created by Kaeson Ho on 2/1/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NavigationManager : NSObject
+ (instancetype) shared;
- (UIViewController *) rootViewController;
- (void) logIn;
- (void) logOut;
- (void) openComposer;

@end
