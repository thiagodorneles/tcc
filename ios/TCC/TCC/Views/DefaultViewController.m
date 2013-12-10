
//  DefaultViewController.m
//  TCC
//
//  Created by Thiago Dorneles on 11/23/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import "DefaultViewController.h"
#import "Publish.h"
#import "User.h"
#import "constants.h"
#import <RestKit/RestKit.h>
#import "ProgressHUD.h"
#import "PublishCell.h"
#import "DetailViewController.h"
#import "LoginViewController.h"

@interface DefaultViewController () <RKObjectLoaderDelegate, RKRequestDelegate>

@property NSMutableArray *publishData;
@property NSMutableArray *searchResults;

@end

@implementation DefaultViewController

@synthesize tableView, publishData, searchResults;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([User getUser] && [self.publishData count] < 1) {
        [self sendRequestWithURL:URL_DEFAULT isLoadMore:false];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([User getUser] == nil) {
        [self performSegueWithIdentifier:@"login" sender:self];
    }
    
    self.refreshControl =[[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self sendRequestWithURL:URL_DEFAULT isLoadMore:false];
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - RestKit Requesting Data
- (void)sendRequestWithURL:(NSString*)URL isLoadMore:(BOOL)loadMore
{
    [ProgressHUD show:@"Carregando..."];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSDictionary *parameters = nil;
    if(loadMore)
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.request_info.count+1], @"page", nil];
    
    RKURL *KURL = [RKURL URLWithBaseURL:[objectManager baseURL] resourcePath:URL queryParameters:parameters];
    [objectManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?%@", [KURL resourcePath], [KURL query]] delegate:self];
    if(!loadMore)
        self.publishData = nil;
}

#pragma mark - RestKit Delegate
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [ProgressHUD dismiss];
    NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"response code: %d", [response statusCode]);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:objects];
    [ProgressHUD dismiss];
    
    if ([array count] > 0)
    {
        // Get Pagina and Numero_Paginas data
        NSMutableArray *requestArray = [NSMutableArray array];
        for(BaseRequest *item in array){
            if([[item class] isSubclassOfClass:[BaseRequest class] ]) {
                [requestArray addObject:item];
                self.request_info = item;
            }
        }
        
        // Need to clean imoveis array from the BaseRequest class
        [array removeObjectsInArray:requestArray];
        if (!publishData)
            publishData = [NSMutableArray new];
        
        [publishData addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if (table == self.searchDisplayController.searchResultsTableView)
    {
        return [self.searchResults count];
    }
    return [publishData count];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PublishCell";
    Publish *publish;
    UITableViewCell *genericCell;
    
    if (table == self.searchDisplayController.searchResultsTableView) {
        UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        publish = [self.searchResults objectAtIndex:indexPath.row];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.text = publish.title;
        genericCell = cell;
        
    }
    else {
        PublishCell *cell = (PublishCell*)[table dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
        cell.autoresizesSubviews = YES;
        
        publish = [self.publishData objectAtIndex:indexPath.row];
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"dd/MM HH:mm"];
        
        cell.labelTitle.text = publish.title;
//        cell.labelTitle.numberOfLines = 0;
        cell.labelUser.text = publish.user_name;
        cell.labelTags.text = [publish.tags componentsJoinedByString:@", "];
        cell.labelDate.text= [dateFormatter stringFromDate:publish.date];

        if ([publish.thumbs count] > 0) {
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@", URL_MEDIA, [publish.thumbs objectAtIndex:0]];
            NSURL *URL = [NSURL URLWithString:imageUrl];
            NSData *data = [NSData dataWithContentsOfURL:URL];
            cell.image.image = [UIImage imageWithData:data];
        }
        else {
            cell.image.image = [UIImage imageNamed:@"nao_disponivel"];
        }

        
//        [cell.labelTitle sizeToFit];
//        [cell.labelTags sizeToFit];
//        [cell.labelUser sizeToFit];
        genericCell = cell;
    }
    return genericCell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [cell sizeToFit];
//    [((PublishCell *)cell).labelTitle sizeToFit];
//}

-(CGFloat)tableView:(UITableView *)table heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (table == self.searchDisplayController.searchResultsTableView)
        return 44;
    return 110.0f;
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (table == self.searchDisplayController.searchResultsTableView) {
//        DetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
//        detailVC.publish = [self.searchResults objectAtIndex:indexPath.row];
//        [self.navigationController pushViewController:detailVC animated:YES];
        [self performSegueWithIdentifier:@"publishDetail" sender:self.searchDisplayController.searchResultsTableView];
    }
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self.searchResults removeAllObjects];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"publishDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Publish *detail = [publishData objectAtIndex:indexPath.row];
        DetailViewController *detailView = segue.destinationViewController;
        detailView.publish = detail;
    }
}

#pragma mark - Content Filtering

- (void)updateFilteredContent:(NSString *)text
{
    [self.searchResults removeAllObjects]; // First clear the filtered array.
    self.searchResults = [NSMutableArray array];
    
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;

    for (Publish *publish in self.publishData)
    {
        
        if ([publish.title rangeOfString:text options:searchOptions].length > 0) {
            [self.searchResults addObject:publish];
            continue;
        }
        else if ([publish.description rangeOfString:text options:searchOptions].length > 0) {
            [self.searchResults addObject:publish];
            continue;
        }
        else if ([[publish.tags componentsJoinedByString:@"," ] rangeOfString:text options:searchOptions].length > 0) {
            [self.searchResults addObject:publish];
            continue;
        }
        
    }
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (searchString.length < 3) {
        return NO;
    }
    
    [self updateFilteredContent:searchString];
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    NSString *searchString = [self.searchDisplayController.searchBar text];
    [self updateFilteredContent:searchString];
    return YES;
}


//#pragma mark - State restoration
//
//static NSString *SearchDisplayControllerIsActiveKey = @"SearchDisplayControllerIsActiveKey";
//static NSString *SearchBarScopeIndexKey = @"SearchBarScopeIndexKey";
//static NSString *SearchBarTextKey = @"SearchBarTextKey";
//static NSString *SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";
//
//static NSString *SearchDisplayControllerSelectedRowKey = @"SearchDisplayControllerSelectedRowKey";
//static NSString *TableViewSelectedRowKey = @"TableViewSelectedRowKey";
//
//
//- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
//{
//    [super encodeRestorableStateWithCoder:coder];
//    
//    UISearchDisplayController *searchDisplayController = self.searchDisplayController;
//    
//    BOOL searchDisplayControllerIsActive = [searchDisplayController isActive];
//    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchDisplayControllerIsActiveKey];
//    
//    if (searchDisplayControllerIsActive)
//    {
//        [coder encodeObject:[searchDisplayController.searchBar text] forKey:SearchBarTextKey];
//        [coder encodeInteger:[searchDisplayController.searchBar selectedScopeButtonIndex] forKey:SearchBarScopeIndexKey];
//        
//        NSIndexPath *selectedIndexPath = [searchDisplayController.searchResultsTableView indexPathForSelectedRow];
//        if (selectedIndexPath != nil)
//        {
//            [coder encodeObject:selectedIndexPath forKey:SearchDisplayControllerSelectedRowKey];
//        }
//        
//        BOOL searchFieldIsFirstResponder = [searchDisplayController.searchBar isFirstResponder];
//        [coder encodeBool:searchFieldIsFirstResponder forKey:SearchBarIsFirstResponderKey];
//    }
//    
//    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
//    if (selectedIndexPath != nil)
//    {
//        [coder encodeObject:selectedIndexPath forKey:TableViewSelectedRowKey];
//    }
//}
//
//
//- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
//{
//    [super decodeRestorableStateWithCoder:coder];
//    
//    BOOL searchDisplayControllerIsActive = [coder decodeBoolForKey:SearchDisplayControllerIsActiveKey];
//    
//    if (searchDisplayControllerIsActive)
//    {
//        [self.searchDisplayController setActive:YES];
//        
//        /*
//         Order is important here. Setting the search bar text causes searchDisplayController:shouldReloadTableForSearchString: to be invoked.
//         */
//        NSInteger searchBarScopeIndex = [coder decodeIntegerForKey:SearchBarScopeIndexKey];
//        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:searchBarScopeIndex];
//        
//        NSString *searchBarText = [coder decodeObjectForKey:SearchBarTextKey];
//        if (searchBarText != nil)
//        {
//            [self.searchDisplayController.searchBar setText:searchBarText];
//        }
//        
//        NSIndexPath *selectedIndexPath = [coder decodeObjectForKey:SearchDisplayControllerSelectedRowKey];
//        if (selectedIndexPath != nil)
//        {
//            [self.searchDisplayController.searchResultsTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
//        }
//        
//        BOOL searchFieldIsFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
//        if (searchFieldIsFirstResponder)
//        {
//            [self.searchDisplayController.searchBar becomeFirstResponder];
//        }
//        
//    }
//    NSIndexPath *selectedIndexPath = [coder decodeObjectForKey:TableViewSelectedRowKey];
//    if (selectedIndexPath != nil)
//    {
//        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
//    }
//}

@end
