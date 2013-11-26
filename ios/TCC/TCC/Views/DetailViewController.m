//
//  DetailViewController.m
//  TCC
//
//  Created by Thiago Dorneles on 11/24/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import "DetailViewController.h"

//#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DetailViewController ()


//@property (strong, nonatomic) UIPopoverController *activityPopover;

@end

@implementation DetailViewController

@synthesize publish;
@synthesize labelTitle, labelUser, labelDate, labelTags, labelDescription, imagePicture;
//@synthesize  activityPopover;

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
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor redColor]];
    NSDateFormatter *inFormat = [[NSDateFormatter alloc] init];
    [inFormat setDateFormat:@"dd/MM HH:mm"];
    
    self.tableView.allowsSelection = NO;
    
    // Carregando os dados
    labelTitle.numberOfLines = 0;
    labelDescription.numberOfLines = 0;
    
    labelTitle.text = self.publish.title;
    [labelTitle sizeToFit];
    labelUser.text = self.publish.user_name;
    labelDate.text = [inFormat stringFromDate:self.publish.date];
    labelDescription.text = self.publish.description;
    
    if (self.publish.tags)
    {
        NSMutableString *tag = [[NSMutableString alloc] initWithString:@"Tags: "];
        [tag appendString:[self.publish.tags componentsJoinedByString:@","]];;
        labelTags.text = tag;
    }
    
//    [labelTitle sizeToFit];
    [labelUser sizeToFit];
    [labelDate sizeToFit];
    [labelTags sizeToFit];
    [labelDescription sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)buttonSharedTouched:(id)sender {
//    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.publish] applicationActivities:nil];
//    
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        //iPhone, present activity view controller as is.
//        [self presentViewController:activityViewController animated:YES completion:nil];
//    }
//    else
//    {
//        //iPad, present the view controller inside a popover.
//        if (![self.activityPopover isPopoverVisible]) {
//            self.activityPopover = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
//            [self.activityPopover presentPopoverFromBarButtonItem:self.buttonShare permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//        }
//        else
//        {
//            //Dismiss if the button is tapped while popover is visible.
//            [self.activityPopover dismissPopoverAnimated:YES];
//        }
//    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.publish.city length] > 0) {
        return 4;
    }
    return 3;
}

@end
