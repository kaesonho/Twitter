
#import "NavigationManager.h"
#import "LoginViewController.h"
#import "TwitterListViewController.h"
#import "ProfileViewController.h"
#import "ComposeViewController.h"
#import "TwitterClient.h"

@interface NavigationManager ()

@property (nonatomic, assign) BOOL isLoggedIn;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) UITabBarController *tabBarController;

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

- (UINavigationController *) generateTabController: (UIViewController *)viewController forTitle:(NSString *)title  forImg:(NSString *)img forTag:(int) tag
{
    viewController.title = title;
    UITabBarItem *homeTabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[UIImage imageNamed:img] tag:tag];
    viewController.tabBarItem = homeTabBarItem;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [navController.navigationBar setBarTintColor:[UIColor colorWithRed:0.21 green:0.47 blue:0.71 alpha:1.0]];
    [navController.navigationBar setTintColor:[UIColor whiteColor]];
    [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"edit-icon@2x.png"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(onTweetClicked:)];
    navController.navigationBar.topItem.rightBarButtonItem = tweetButton;
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Logout"
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onLogoutCLicked:)];
    navController.navigationBar.topItem.rightBarButtonItem = tweetButton;
    navController.navigationBar.topItem.leftBarButtonItem = logoutButton;

    return navController;
}

- (IBAction)onTweetClicked:(id)sender
{
    ComposeViewController *viewController = [[ComposeViewController alloc] init];
    [viewController setIsRetweet:NO];
    
    [self.tabBarController.selectedViewController presentViewController:viewController animated:YES completion:nil];
}

- (IBAction)onLogoutCLicked:(id)sender
{
    [self logOut];
}

- (UIViewController *)loggedInVC
{
    // home
    TwitterListViewController *homeViewController = [[TwitterListViewController alloc] initWithNibName:@"TwitterListViewController" bundle:nil];
    UINavigationController *homeNavController = [self generateTabController: homeViewController forTitle:@"Home" forImg: @"home-icon@2x.png" forTag:0];
    [homeViewController setCategory:@"home_timeline"];
    
    // mentions?
    TwitterListViewController *mentionsViewController = [[TwitterListViewController alloc] initWithNibName:@"TwitterListViewController" bundle:nil];
    UINavigationController *mentionsNavController = [self generateTabController: mentionsViewController forTitle:@"Mentions" forImg: @"moment-icon@2x.png" forTag:1];
    [mentionsViewController setCategory:@"mentions_timeline"];
    
    // profile
    ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    UINavigationController *profileNavController = [self generateTabController: profileViewController forTitle:@"Profile" forImg: @"profile-icon@2x.png" forTag:1];

    UITabBarController *tabController = [[UITabBarController alloc] init];
    [tabController.tabBar setTintColor:[UIColor whiteColor]];
    [tabController.tabBar setUnselectedItemTintColor:[UIColor lightTextColor]];
    [tabController.tabBar setBarTintColor:[UIColor colorWithRed:0.21 green:0.47 blue:0.71 alpha:1.0]];
    tabController.viewControllers = @[homeNavController, mentionsNavController, profileNavController];
    self.tabBarController = tabController;
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
