//
//  DefaultViewController.m
//  TCC
//
//  Created by Thiago Dorneles on 11/23/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import "DefaultViewController.h"
#import "Publish.h"
#import "constants.h"
#import <RestKit/RestKit.h>
#import "MBProgressHUD.h"
#import "PublishCell.h"
#import "DetailViewController.h"

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

    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self sendRequest];
    [self sendRequestWithURL:@"/publishs/" isLoadMore:false];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


//- (void)sendRequest
//{
//    [self presentHUD];
//    
//    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8000/api/publishs/"];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    NSArray *lista = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//    
//    publishData = [NSMutableArray new];
//    
//    NSDateFormatter *formatDate = [NSDateFormatter new];
//    [formatDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//    for (NSDictionary *item in lista) {
//        // Adjust Date format from server
//        NSString *strDate = [item objectForKey:@"created_at"];
//        strDate = [strDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
//        strDate = [strDate substringWithRange:NSMakeRange(0, [strDate length] - 4)];
//        
//        Publish *p = [Publish new];
//        p.title = [item objectForKey:@"title"];
//        p.description = [item objectForKey:@"description"];
//        p.city = [item objectForKey:@"city"];
//        p.location = [item objectForKey:@"location"];
//        p.created_at = [formatDate dateFromString:strDate];
//        
//        [publishData addObject:p];
//    }
//    
//    [self.tableView reloadData];
//    [self dismissHUD];
//    
//}

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

    NSLog(@"objects[%d]", [array count]);
    if (!publishData)
        publishData = [NSMutableArray new];
    
    [publishData addObjectsFromArray:array];
    
    // Bloco para corrigir a formatacao da data capturada do servidor.
    // O python envia uma data completa que o parser do RestKit nao consegue
    // converter. Esse bloco entao pega o campo 'created_at' que eh string
    // e joga para o campo date.
    NSDateFormatter *formatDate = [NSDateFormatter new];
    [formatDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    for (NSInteger i = 0; i < [self.publishData count]; i++) {
        Publish *item = [self.publishData objectAtIndex:i];
        NSString *strDate = item.created_at;
        strDate = [strDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        strDate = [strDate substringWithRange:NSMakeRange(0, [strDate length] - 4)];
        item.date = [formatDate dateFromString:strDate];
        [self.publishData replaceObjectAtIndex:i withObject:item];
    }
    
    [tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    cell.labelUser.text = publish.user;
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


@end
