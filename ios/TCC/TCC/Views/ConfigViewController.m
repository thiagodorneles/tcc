//
//  ConfigViewController.m
//  TCC
//
//  Created by Thiago Dorneles on 11/27/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import "ConfigViewController.h"
#import <MessageUI/MessageUI.h>

@interface ConfigViewController () <MFMailComposeViewControllerDelegate>

@property MFMailComposeViewController *mailController;

@end

@implementation ConfigViewController

@synthesize mailController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)buttonContactTouched:(id)sender {
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil) {
        if ([MFMailComposeViewController canSendMail])
        {
            mailController = [MFMailComposeViewController new];
            [mailController.navigationBar setTintColor:[UIColor redColor]];
            mailController.mailComposeDelegate = self;
            [mailController setToRecipients:[NSArray arrayWithObject:@"thiagodornelesrs@gmail.com"]];
            [self presentViewController:mailController animated:YES completion:NULL];
            
        }
    }
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (error){
        NSString *errorTitle = @"Mail Error";
        NSString *errorDescription = [error localizedDescription];
        UIAlertView *errorView = [[UIAlertView alloc]initWithTitle:errorTitle message:errorDescription delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [errorView show];
    }
    [mailController dismissViewControllerAnimated:YES completion:nil];
    
}

@end
