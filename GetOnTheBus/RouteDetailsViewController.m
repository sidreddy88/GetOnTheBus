//
//  RouteDetailsViewController.m
//  GetOnTheBus
//
//  Created by Siddharth Sukumar on 1/21/14.
//  Copyright (c) 2014 Siddharth Sukumar. All rights reserved.
//

#import "RouteDetailsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>


@interface RouteDetailsViewController ()
{
  
    
    IBOutlet UILabel *labelShowingTitle;
   
    IBOutlet UILabel *labelShowingAddress;
    
    
    IBOutlet UILabel *labelShowingBusRoutes;
    
    
    IBOutlet UILabel *labelShowingIntermodalTransfers;
   
    IBOutlet UILabel *labelTitleIntermodalTransfers;
}

@end

@implementation RouteDetailsViewController
@synthesize title, address, busRoutes, location, intermodalTransferRoutes;


- (void)viewDidLoad
{
    [super viewDidLoad];
	labelShowingTitle.text = title;
    labelShowingBusRoutes.text = busRoutes;

    
    
    CLLocation *ll = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    
    CLGeocoder* geoCoder = [CLGeocoder new];
    
    if ([intermodalTransferRoutes isEqualToString:@""]){
        labelShowingIntermodalTransfers.text = @"No transfers";

    } else {
        labelTitleIntermodalTransfers.alpha = 1;
        labelShowingIntermodalTransfers.alpha = 1;
        labelShowingIntermodalTransfers.text = intermodalTransferRoutes;
    }
    

    [geoCoder reverseGeocodeLocation:ll completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error){
            NSLog(@"%@", error);
        } else {
            for (CLPlacemark* placemark in placemarks) {
                id b = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
                id myAddress = [NSString stringWithFormat:@"%@", b];
                labelShowingAddress.text = myAddress;
                NSLog(@"address = %@", myAddress);
            }
            
        }
        
    }];

    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
