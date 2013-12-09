//
//  PreNewViewController.m
//  TCC
//
//  Created by Thiago Dorneles on 12/9/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import "PreNewViewController.h"
#import "NewViewController.h"

@interface PreNewViewController ()

@end

@implementation PreNewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NewViewController *modalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewController"];
    
    [self presentViewController:modalVC animated:YES completion:^{
//        double delayInSeconds = 2.0;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [modalVC dismissViewControllerAnimated:YES completion:nil];
//            self.tabBarController.selectedIndex = 0;
//        });
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
