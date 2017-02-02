//
//  ComposeViewController.m
//  Twitter
//
//  Created by Kaeson Ho on 2/1/17.
//  Copyright © 2017 Kaeson Ho. All rights reserved.
//

#import "ComposeViewController.h"

@interface ComposeViewController ()

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)closeModal:(id)sender {
     [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
