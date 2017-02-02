
#import "NavigationManager.h"
#import "LoginViewController.h"
#import "TwitterListViewController.h"
#import "ProfileViewController.h"

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
    TwitterListViewController *homeViewController = [[TwitterListViewController alloc] initWithNibName:@"TwitterListViewController" bundle:nil];
    homeViewController.title = @"Home";
    UITabBarItem *homeTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"home-icon@2x.png"] tag:0];
    homeViewController.tabBarItem = homeTabBarItem;
    UINavigationController *homeNavController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    [homeNavController.navigationBar setBarTintColor:[UIColor colorWithRed:0.21 green:0.47 blue:0.71 alpha:1.0]];
    [homeNavController.navigationBar setTintColor:[UIColor whiteColor]];
    [homeNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    TwitterListViewController *mentionsViewController = [[TwitterListViewController alloc] initWithNibName:@"TwitterListViewController" bundle:nil];
    mentionsViewController.title = @"Mentions";
    UITabBarItem *mentionsTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Mentions" image:[UIImage imageNamed:@"moment-icon@2x.png"] tag:1];
    mentionsViewController.tabBarItem = mentionsTabBarItem;
    UINavigationController *mentionsNavController = [[UINavigationController alloc] initWithRootViewController:mentionsViewController];
    [mentionsNavController.navigationBar setBarTintColor:[UIColor colorWithRed:0.21 green:0.47 blue:0.71 alpha:1.0]];
    [mentionsNavController.navigationBar setTintColor:[UIColor whiteColor]];
    [mentionsNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    profileViewController.title = @"Profile";
    UITabBarItem *profileTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"profile-icon@2x.png"] tag:2];
    profileViewController.tabBarItem = profileTabBarItem;
    UINavigationController *profileNavController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
    [profileNavController.navigationBar setBarTintColor:[UIColor colorWithRed:0.21 green:0.47 blue:0.71 alpha:1.0]];
    [profileNavController.navigationBar setTintColor:[UIColor whiteColor]];
    [profileNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    // create tab bar view controller
    UITabBarController *tabController = [[UITabBarController alloc] init];
    [tabController.tabBar setTintColor:[UIColor whiteColor]];
    [tabController.tabBar setBarTintColor:[UIColor colorWithRed:0.21 green:0.47 blue:0.71 alpha:1.0]];
    // Add navigation controller to tab bar controller
    tabController.viewControllers = @[homeNavController, mentionsNavController, profileNavController];
    
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
