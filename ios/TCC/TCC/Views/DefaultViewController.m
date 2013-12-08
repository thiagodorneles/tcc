
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
#import "MBProgressHUD.h"
#import "PublishCell.h"
#import "DetailViewController.h"
#import "LoginViewController.h"

@interface DefaultViewController () <RKObjectLoaderDelegate, RKRequestDelegate>


@property (nonatomic, strong) MBProgressHUD *HUD;
@property NSMutableArray *publishData;

@end

@implementation DefaultViewController

@synthesize HUD, tableView, publishData;

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
    self.refreshControl =[[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self sendRequestWithURL:URL_DEFAULT isLoadMore:false];
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
    [self presentHUD];
    
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
    [self dismissHUD];
    [self timeout];
    NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"response code: %d", [response statusCode]);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:objects];
    [self dismissHUD];
//
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if (table == self.searchDisplayController.searchResultsTableView)
    {
        return [publishData count];
    }
    return [publishData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PublishCell";
    PublishCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    
    Publish *publish = [self.publishData objectAtIndex:indexPath.row];
    
    cell.image.frame = CGRectMake(0, 7, 126, 91);
    cell.image.image = [UIImage imageNamed:@"acidente"];
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

#pragma mark - MBProgressHUD

- (void)presentHUD
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Carregando...";
    [HUD show:YES];
}

- (void)timeout
{
    [HUD hide:YES afterDelay:2.0];
    HUD = nil;
}

- (void)dismissHUD
{
    [HUD hide:YES afterDelay:2.0];
    HUD = nil;
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
//        [segue.destinationViewController setValue:detail forUndefinedKey:@"publish"];
    }
}

#pragma mark - Content Filtering

- (void)updateFilteredContentForProductName:(NSString *)productName type:(NSString *)typeName
{
//    /*
//     Update the filtered array based on the search text and scope.
//     */
//    if ((productName == nil) || [productName length] == 0)
//    {
//        // If there is no search string and the scope is "All".
//        if (typeName == nil)
//        {
//            self.searchResults = [self.products mutableCopy];
//        }
//        else
//        {
//            // If there is no search string and the scope is chosen.
//            NSMutableArray *searchResults = [[NSMutableArray alloc] init];
//            for (APLProduct *product in self.products)
//            {
//                if ([product.type isEqualToString:typeName])
//                {
//                    [searchResults addObject:product];
//                }
//            }
//            self.searchResults = searchResults;
//        }
//        return;
//    }
//    
//    
//    [self.searchResults removeAllObjects]; // First clear the filtered array.
//    /*
//     Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
//     */
//    for (APLProduct *product in self.products)
//    {
//        if ((typeName == nil) || [product.type isEqualToString:typeName])
//        {
//            NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
//            NSRange productNameRange = NSMakeRange(0, product.name.length);
//            NSRange foundRange = [product.name rangeOfString:productName options:searchOptions range:productNameRange];
//            if (foundRange.length > 0)
//            {
//                [self.searchResults addObject:product];
//            }
//        }
//    }
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSString *scope;
    
    NSInteger selectedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    if (selectedScopeButtonIndex > 0)
    {
//        scope = [[APLProduct deviceTypeNames] objectAtIndex:(selectedScopeButtonIndex - 1)];
    }
    
    [self updateFilteredContentForProductName:searchString type:scope];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    NSString *searchString = [self.searchDisplayController.searchBar text];
    NSString *scope;
    
    if (searchOption > 0)
    {
//        scope = [[APLProduct deviceTypeNames] objectAtIndex:(searchOption - 1)];
    }
    
    [self updateFilteredContentForProductName:searchString type:scope];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


#pragma mark - State restoration

static NSString *SearchDisplayControllerIsActiveKey = @"SearchDisplayControllerIsActiveKey";
static NSString *SearchBarScopeIndexKey = @"SearchBarScopeIndexKey";
static NSString *SearchBarTextKey = @"SearchBarTextKey";
static NSString *SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";

static NSString *SearchDisplayControllerSelectedRowKey = @"SearchDisplayControllerSelectedRowKey";
static NSString *TableViewSelectedRowKey = @"TableViewSelectedRowKey";


- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    
    UISearchDisplayController *searchDisplayController = self.searchDisplayController;
    
    BOOL searchDisplayControllerIsActive = [searchDisplayController isActive];
    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchDisplayControllerIsActiveKey];
    
    if (searchDisplayControllerIsActive)
    {
        [coder encodeObject:[searchDisplayController.searchBar text] forKey:SearchBarTextKey];
        [coder encodeInteger:[searchDisplayController.searchBar selectedScopeButtonIndex] forKey:SearchBarScopeIndexKey];
        
        NSIndexPath *selectedIndexPath = [searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        if (selectedIndexPath != nil)
        {
            [coder encodeObject:selectedIndexPath forKey:SearchDisplayControllerSelectedRowKey];
        }
        
        BOOL searchFieldIsFirstResponder = [searchDisplayController.searchBar isFirstResponder];
        [coder encodeBool:searchFieldIsFirstResponder forKey:SearchBarIsFirstResponderKey];
    }
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    if (selectedIndexPath != nil)
    {
        [coder encodeObject:selectedIndexPath forKey:TableViewSelectedRowKey];
    }
}


- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    
    BOOL searchDisplayControllerIsActive = [coder decodeBoolForKey:SearchDisplayControllerIsActiveKey];
    
    if (searchDisplayControllerIsActive)
    {
        [self.searchDisplayController setActive:YES];
        
        /*
         Order is important here. Setting the search bar text causes searchDisplayController:shouldReloadTableForSearchString: to be invoked.
         */
        NSInteger searchBarScopeIndex = [coder decodeIntegerForKey:SearchBarScopeIndexKey];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:searchBarScopeIndex];
        
        NSString *searchBarText = [coder decodeObjectForKey:SearchBarTextKey];
        if (searchBarText != nil)
        {
            [self.searchDisplayController.searchBar setText:searchBarText];
        }
        
        NSIndexPath *selectedIndexPath = [coder decodeObjectForKey:SearchDisplayControllerSelectedRowKey];
        if (selectedIndexPath != nil)
        {
            [self.searchDisplayController.searchResultsTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
        
        BOOL searchFieldIsFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
        if (searchFieldIsFirstResponder)
        {
            [self.searchDisplayController.searchBar becomeFirstResponder];
        }
        
    }
    NSIndexPath *selectedIndexPath = [coder decodeObjectForKey:TableViewSelectedRowKey];
    if (selectedIndexPath != nil)
    {
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
}

@end
