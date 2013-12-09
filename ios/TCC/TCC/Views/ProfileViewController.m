//
//  ProfileViewController.m
//  TCC
//
//  Created by Thiago Dorneles on 11/24/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import "ProfileViewController.h"
#import "PublishCell.h"
#import "Publish.h"
#import "TDAppDelegate.h"
#import <RestKit/RestKit.h>
#import "constants.h"
#import "DetailViewController.h"
#import "ProgressHUD.h"

@interface ProfileViewController () <RKObjectLoaderDelegate, RKRequestDelegate>

@property User *user;

@end

@implementation ProfileViewController

@synthesize labelUserName, labelTotalPublishs, labelUserCreated;
@synthesize user;

#pragma mark - Views

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

    user = [User getUser];
    
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateFormat:@"MM/yyyy"];
    

    self.labelUserName.text = self.user.name;
    self.labelUserCreated.text = [NSString stringWithFormat:@"Desde: %@", [format stringFromDate:self.user.created_at]];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.clearsSelectionOnViewWillAppear = YES;
    [self sendRequest:[NSString stringWithFormat:URL_USERS, self.user.pk]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Search refresh

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self sendRequest:[NSString stringWithFormat:URL_USERS, self.user.pk]];
    [refreshControl endRefreshing];
}


#pragma mark - RestKit Delegate

-(void)sendRequest:(NSString*)URL
{
    [ProgressHUD show:@"Carregando..."];
    self.user.publishs = nil;
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    RKURL *KURL = [RKURL URLWithBaseURL:[objectManager baseURL] resourcePath:URL];
    [objectManager loadObjectsAtResourcePath:[KURL resourcePath] delegate:self];
}

- (void)requestWillPrepareForSend:(RKRequest *)request
{
    NSLog(@"requestWillPrepareForSend");
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"response code: %d", [response statusCode]);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:objects];
    self.user = (User*)[array objectAtIndex:0];
    if (self.user.publishs != nil) {
        self.labelTotalPublishs.text = [NSString stringWithFormat:@"Publicações: %d", [self.user.publishs count]];
    }
    [self.tableView reloadData];
    [ProgressHUD dismiss];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.user.publishs != nil)
        return [self.user.publishs count];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PublishCell";
    PublishCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    
    Publish *publish = [self.user.publishs objectAtIndex:indexPath.row];
    
    if ([publish.thumbs count] > 0) {
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@", URL_MEDIA, [publish.thumbs objectAtIndex:0]];
        NSURL *URL = [NSURL URLWithString:imageUrl];
        NSData *data = [NSData dataWithContentsOfURL:URL];
        cell.image.image = [UIImage imageWithData:data];
    }
    else {
        cell.image.image = [UIImage imageNamed:@"nao_disponivel"];
    }
    
    cell.labelTitle.numberOfLines = 0;
    cell.labelTitle.text = publish.title;
    cell.labelUser.text = publish.user_name;
    cell.labelTags.text = [publish.tags componentsJoinedByString:@", "];
    //    cell.labelDate.text= publish.date;
    
    [cell.labelTitle sizeToFit];
    [cell.labelTags sizeToFit];
    [cell.labelUser sizeToFit];
    
    return cell;
 
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0f;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"detail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Publish *detail = [self.user.publishs objectAtIndex:indexPath.row];
        DetailViewController *detailView = segue.destinationViewController;
        detailView.publish = detail;
    }}

@end
