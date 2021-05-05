//
//  DetailViewController.m
//  TCC
//
//  Created by Thiago Dorneles on 11/24/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import "DetailViewController.h"
#import <RestKit/RestKit.h>
#import <UIKit/UIActivityViewController.h>
#import "ProgressHUD.h"
#import "PublishBlock.h"
#import "constants.h"
#import "MWPhotoBrowser.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 280.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface DetailViewController () <RKObjectLoaderDelegate, MKMapViewDelegate, UIActivityItemSource, MWPhotoBrowserDelegate>

@property NSMutableArray *photosBrowser;

@end

@implementation DetailViewController

@synthesize publish, photosBrowser;

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
    
//    self.tableView.allowsSelection = NO;
    self.tableView.dataSource = self;
    
    if (self.publish.quant_blocks < 3)
    {
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
        
        RKObjectManager *manager = [RKObjectManager sharedManager];
        RKURL *KURL = [RKURL URLWithBaseURL:[manager baseURL] resourcePath:[NSString stringWithFormat:@"/publishs/%ld/", (long)self.publish.pk]];
        [manager loadObjectsAtResourcePath:[KURL resourcePath] delegate:self];
    }
    else {
        self.navigationItem.title = @"Bloqueada";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Buttons navigation bar

- (IBAction)buttonSharedTouched:(id)sender
{
    UIActivityViewController *shareViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.publish]
                                                                                      applicationActivities:nil];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self presentViewController:shareViewController animated:YES completion:nil];
    }
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

        RKObjectManager *objectManager = [RKObjectManager managerWithBaseURLString:URL_SERVER];
        objectManager.acceptMIMEType = RKMIMETypeJSON;
        objectManager.serializationMIMEType = RKMIMETypeJSON;

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

 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 3;
    else
        return 1;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0)
        return 0;
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
//        
//        NSMutableArray *photos = [[NSMutableArray alloc] init];
        
        self.photosBrowser = [[NSMutableArray alloc] init];
        
        MWPhoto *photo;
        for(NSString* imageStr in self.publish.images){
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@", URL_MEDIA, imageStr];
            NSURL * imageURL = [NSURL URLWithString:imageUrl];
            photo = [MWPhoto photoWithURL:imageURL];
            [photosBrowser addObject:photo];
        }

        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
        browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
        browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
        [browser setCurrentPhotoIndex:1]; // Example: allows second image to be presented first

        
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.navigationController presentViewController:nc animated:YES completion:nil];
    
        // Release
        
        // Deselect
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        static NSString *cellPrincipal = @"cell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellPrincipal];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellPrincipal];
        }
        
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.userInteractionEnabled = NO;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
                cell.textLabel.text = self.publish.title;
                break;
                
            case 1:
            {
                UILabel *lblUser = [UILabel new];
                lblUser.text = self.publish.user_name;
                lblUser.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
                lblUser.frame = CGRectMake(25.0f, CELL_CONTENT_MARGIN, cell.frame.size.width / 2 - 25.0f, 44);
                [cell addSubview:lblUser];
                
                NSDateFormatter *inFormat = [[NSDateFormatter alloc] init];
                [inFormat setDateFormat:@"dd/MM HH:mm"];

                UILabel *lblDate = [UILabel new];
                lblDate.textAlignment = NSTextAlignmentRight;
                lblDate.text = [inFormat stringFromDate:self.publish.date];
                lblDate.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
                lblDate.frame = CGRectMake(cell.frame.size.width - 105.0f, CELL_CONTENT_MARGIN, 80.0f, 44);
                [cell addSubview:lblDate];
                
                break;
            }
                
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"Tags: %@", [self.publish.tags componentsJoinedByString:@", "]];
                cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
                break;
        }
    }
    else if (indexPath.section == 1) {
        static NSString *cellPictures = @"cellPictures";
        cell = [tableView dequeueReusableCellWithIdentifier:cellPictures];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellPictures];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 150.0f)];
        if ([publish.thumbs count] > 0) {
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@", URL_MEDIA, [publish.thumbs objectAtIndex:0]];
            NSURL *dataUrl = [NSURL URLWithString:imageUrl];
            NSData *data = [NSData dataWithContentsOfURL:dataUrl];
            imageView.image = [UIImage imageWithData:data];
            cell.userInteractionEnabled = YES;
        }
        else {
            imageView.image = [UIImage imageNamed:@"nao_disponivel"];
        }
        
        [cell addSubview:imageView];
    }
    else if (indexPath.section == 2) {
        static NSString *cellDescription = @"cellDescription";
        cell = [tableView dequeueReusableCellWithIdentifier:cellDescription];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellDescription];
        }
        
        cell.textLabel.textAlignment = NSTextAlignmentJustified;
        cell.textLabel.text = self.publish.description;
        cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        cell.textLabel.numberOfLines = 0;
        [cell.textLabel sizeToFit];
        
    }
    else if (indexPath.section == 3 && self.publish.location) {
        static NSString *cellMap = @"cellMap";
        cell = [tableView dequeueReusableCellWithIdentifier:cellMap];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellMap];
        }
        
        NSArray *location = [self.publish.location componentsSeparatedByString:@", " ];
        MKMapView *map = [[MKMapView alloc] init];
        map.delegate = self;
        map.userInteractionEnabled = false;
        map.frame = CGRectMake(0, 0, cell.frame.size.width, 200.0f);
        
        CLLocationCoordinate2D startCoord;
        startCoord.latitude = [[location objectAtIndex:0] floatValue];
        startCoord.longitude = [[location objectAtIndex:1] floatValue];
        
        MKAnnotationView *point = [[MKAnnotationView alloc] init];
        [point.annotation setCoordinate:startCoord];
        [map addAnnotation:point.annotation];
        [map setRegion:MKCoordinateRegionMakeWithDistance(startCoord, 200, 200) animated:YES];
        [cell addSubview:map];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 3) {
        return 200;
    }
    else if (indexPath.section == 1) {
        return 150;
    }
    else if (indexPath.section == 2) {
        return [self calculateHeightForTableViewCellwithText:self.publish.description
                                                     andFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    }
    else if (indexPath.section == 0) {
        if (indexPath.row == 0){
            return [self calculateHeightForTableViewCellwithText:self.publish.title
                                                         andFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
        }
        else if (indexPath.row == 2) {
            NSString *tags = [self.publish.tags componentsJoinedByString:@", "];
            return [self calculateHeightForTableViewCellwithText:tags
                                                         andFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
        }
    }
    return 44;
}

-(CGFloat)calculateHeightForTableViewCellwithText:(NSString *)text andFont:(UIFont*)font
{
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = CGSizeZero;
    size = [text boundingRectWithSize: constraint
                              options: NSStringDrawingUsesLineFragmentOrigin
                           attributes: @{ NSFontAttributeName: font }
                              context: nil].size;
    
    return size.height + (CELL_CONTENT_MARGIN * 2);
}

#pragma mark - UIActivityView

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return nil;
}
- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    return activityType;
}

#pragma mark - MWPhotoBrowser

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photosBrowser.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photosBrowser.count)
        return [self.photosBrowser objectAtIndex:index];
    return nil;
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
            self.navigationController.navigationItem.rightBarButtonItems = nil;
            [self.navigationController popViewControllerAnimated:YES];
        }
        [NSThread sleepForTimeInterval:5];
    }
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [ProgressHUD dismiss];
    });
}

@end
