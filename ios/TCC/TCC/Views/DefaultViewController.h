//
//  DefaultViewController.h
//  TCC
//
//  Created by Thiago Dorneles on 11/23/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRequest.h"

@interface DefaultViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonSearch;
@property (nonatomic, strong) BaseRequest *request_info;


@end
