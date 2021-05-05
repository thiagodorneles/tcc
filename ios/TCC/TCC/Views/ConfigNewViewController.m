//
//  ConfigNewViewController.m
//  TCC
//
//  Created by Thiago Dorneles on 12/10/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import "ConfigNewViewController.h"
#import "TDAppDelegate.h"

@interface ConfigNewViewController ()

@end

@implementation ConfigNewViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)switchCamera:(id)sender {
    UISwitch *swCamera = (UISwitch*)sender;
    [[NSUserDefaults standardUserDefaults] setBool:swCamera.isOn forKey:@"NewRecordCamera"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
