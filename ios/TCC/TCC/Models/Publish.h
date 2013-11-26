//
//  Publish.h
//  TCC
//
//  Created by Thiago Dorneles on 11/23/13.
//  Copyright (c) 2013 Thiago Dorneles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Publish : NSObject <UIActivityItemSource>

@property NSString *title;
@property NSString *description;
@property NSString *created_at;
@property NSDate *date;
@property NSString *location;
@property NSString *city;
@property NSInteger quant_views;
@property NSInteger quant_blocks;
@property NSString *user;
@property NSMutableArray *tags;

// Location
@property float latitude;
@property float longitude;
@property CLLocationCoordinate2D coordinate;


@end
