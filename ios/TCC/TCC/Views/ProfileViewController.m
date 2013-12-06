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

@interface ProfileViewController ()

@end

@implementation ProfileViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PublishCell";
    PublishCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    
    cell.image.image = [UIImage imageNamed:@"acidente"];
    cell.labelTitle.text = @"Teste";
    cell.labelTags.text = @"Teste";
    cell.labelUser.text = @"Teste";
    
//    Publish *publish = [self.publishData objectAtIndex:indexPath.row];
//    
//    cell.image.frame = CGRectMake(0, 7, 126, 91);
//    cell.image.image = [UIImage imageNamed:@"acidente"];
//    cell.labelTitle.numberOfLines = 0;
//    cell.labelTitle.text = publish.title;
//    cell.labelUser.text = publish.user_name;
//    cell.labelTags.text = [publish.tags componentsJoinedByString:@", "];
//    //    cell.labelDate.text= publish.date;
//    
//    [cell.labelTitle sizeToFit];
//    [cell.labelTags sizeToFit];
//    [cell.labelUser sizeToFit];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0f;
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
