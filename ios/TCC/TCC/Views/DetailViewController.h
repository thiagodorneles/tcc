//
//  DetailViewController.h
//  TCC
//
//  Created by Thiago Dorneles on 11/24/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Publish.h"
//#import <UIKit/UIActivityViewController.h>

@interface DetailViewController : UITableViewController <UITableViewDataSource>

@property Publish *publish;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelUser;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelTags;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UIImageView *imagePicture;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *buttonShare;
//@property (weak, nonatomic) IBOutlet MKMapView *mapView;

//- (IBAction)buttonSharedTouched:(id)sender;

@end
