
#import "NavigationManager.h"
#import "LoginViewController.h"
#import "TwitterListViewController.h"

@interface NavigationManager ()

@property (nonatomic, assign) BOOL isLoggedIn;
@property (nonatomic, strong) UINavigationController *navigationController;

@end

@implementation NavigationManager

+ (instancetype)shared
{
    static NavigationManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NavigationManager alloc] init];
    });
    return sharedInstance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isLoggedIn = NO;
        
        UIViewController *root = self.isLoggedIn ? [self loggedInVC] : [self loggedOutVC];
        
        self.navigationController = [[UINavigationController alloc] init];
        self.navigationController.viewControllers = @[root];
        [self.navigationController setNavigationBarHidden:YES];
    }
    return self;
}


- (UIViewController *)rootViewController
{
    return self.navigationController;
}

- (UIViewController *)loggedInVC
{
    // Create root VC for the tab's navigation controller
    TwitterListViewController *vc = [[TwitterListViewController alloc] initWithNibName:@"TwitterListViewController" bundle:nil];
    vc.title = @"Home";
    // create tab item
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"Home" image:nil tag:0];
    vc.tabBarItem = item;
    // create navigation controller
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    // Create root VC for the tab's navigation controller
    TwitterListViewController *vc2 = [[TwitterListViewController alloc] initWithNibName:@"TwitterListViewController" bundle:nil];
    vc2.title = @"Home2";
    // create tab item
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"Home22" image:nil tag:0];
    vc.tabBarItem = item2;
    // create navigation controller
    UINavigationController *navController2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    
    // create tab bar view controller
    UITabBarController *tabController = [[UITabBarController alloc] init];
    // Add navigation controller to tab bar controller
    tabController.viewControllers = @[navController, navController2];
    
    return tabController;
}

- (UIViewController *)loggedOutVC
{
    LoginViewController *vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    return vc;
}

- (void)logIn
{
    self.isLoggedIn = YES;
    
    NSArray *vcs = @[[self loggedInVC]];
    [self.navigationController setViewControllers:vcs];
}


- (void)logOut
{
    self.isLoggedIn = NO;
    self.navigationController.viewControllers = @[[self loggedOutVC]];
}

@end
