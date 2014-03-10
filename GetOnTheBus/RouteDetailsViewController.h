//
//  RouteDetailsViewController.h
//  GetOnTheBus
//
//  Created by Siddharth Sukumar on 1/21/14.
//  Copyright (c) 2014 Siddharth Sukumar. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface RouteDetailsViewController : ViewController

@property NSString *title;
@property NSString *address;
@property NSString *busRoutes;
@property NSString *intermodalTransferRoutes;
@property CLLocationCoordinate2D location;

@end
