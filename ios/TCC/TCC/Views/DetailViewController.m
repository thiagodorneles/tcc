//
//  DetailViewController.m
//  TCC
//
//  Created by Thiago Dorneles on 11/24/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import "DetailViewController.h"
#import <RestKit/RestKit.h>
#import "ProgressHUD.h"
#import "PublishBlock.h"

//#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DetailViewController () <RKObjectLoaderDelegate>


//@property (strong, nonatomic) UIPopoverController *activityPopover;

@end

@implementation DetailViewController

@synthesize publish;
@synthesize labelTitle, labelUser, labelDate, labelTags, labelDescription, imagePicture;
//@synthesize  activityPopover;

#pragma mark - View

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
    
    UIBarButtonItem *buttonShare = [[UIBarButtonItem alloc] init];
    buttonShare.image = [UIImage imageNamed:@"share"];
    buttonShare.style = UIBarButtonItemStylePlain;
    buttonShare.target = self;
    buttonShare.action = @selector(buttonSharedTouched:);
    
    UIBarButtonItem *buttonBlock = [[UIBarButtonItem alloc] init];
    buttonBlock.image = [UIImage imageNamed:@"block"];
    buttonBlock.style = UIBarButtonItemStylePlain;
    buttonBlock.target = self;
    buttonBlock.action = @selector(buttonBlockedTouched:);
    
    NSMutableArray *arrayButtons = [NSMutableArray arrayWithObjects:buttonShare, buttonBlock, nil];
    self.navigationItem.rightBarButtonItems = arrayButtons;
    
    
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
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    RKURL *KURL = [RKURL URLWithBaseURL:[manager baseURL] resourcePath:[NSString stringWithFormat:@"/publishs/%ld/", (long)self.publish.pk]];
    [manager loadObjectsAtResourcePath:[KURL resourcePath] delegate:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Buttons navigation bar

- (IBAction)buttonSharedTouched:(id)sender {
    NSLog(@"Shared");
    
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

- (IBAction)buttonBlockedTouched:(id)sender {
    NSLog(@"Block");
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Avisar conteúdo impróprio" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:@"Confirmar" otherButtonTitles:nil];
    [action showInView:self.view];
}

#pragma mark - UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [ProgressHUD show:@"Informando bloqueio..."];
        RKObjectManager *objectManager = [RKObjectManager sharedManager];
        
        // -------------------------------------------------------------------------------------
        // Mapeamento do objeto de Publish para BLOCK
        // -------------------------------------------------------------------------------------
        RKObjectMapping *blockMapping = [RKObjectMapping mappingForClass:[PublishBlock class]];
        [blockMapping mapKeyPath:@"id" toAttribute:@"pk"];
        [blockMapping  mapKeyPath:@"quant_blocks" toAttribute:@"quant_blocks"];
        [objectManager.mappingProvider setMapping:blockMapping forKeyPath:@""];
        
        RKObjectMapping *blockSerializer = [blockMapping inverseMapping];
        [objectManager.mappingProvider setSerializationMapping:blockSerializer forClass:[PublishBlock class]];
        [objectManager.router routeClass:[PublishBlock class] toResourcePath:@"/block/" forMethod:RKRequestMethodPOST];
        
        PublishBlock *publishBlock = [PublishBlock new];
        publishBlock.pk = self.publish.pk;
        [objectManager postObject:publishBlock delegate:self];
        NSLog(@"Bloquear");
    }
}

#pragma mark - TableView DataSources

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.publish.city length] > 0) {
        return 4;
    }
    return 3;
}

#pragma mark - RestKit

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"error = %@", [error description]);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    if ([[objectLoader resourcePath] rangeOfString:@"publishs"].location == NSNotFound) {
        [ProgressHUD showSuccess:@"Obrigado!"];
        PublishBlock *p = (PublishBlock*)[objects objectAtIndex:0];
        if (p.quant_blocks >= 3) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        [NSThread sleepForTimeInterval:5];

    }
    [ProgressHUD dismiss];
}

@end
