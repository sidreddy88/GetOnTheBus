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
    IBOutlet UITextField *titleLabel;
    
   
    IBOutlet UILabel *labelShowingAddress;
    
    
    IBOutlet UILabel *labelShowingBusRoutes;
    
    id myAddress;
   
}

@end

@implementation RouteDetailsViewController
@synthesize title, address, busRoutes, location;


- (void)viewDidLoad
{
    [super viewDidLoad];
	titleLabel.text = title;
    
    CLLocation *ll = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    
    CLGeocoder* geoCoder = [CLGeocoder new];
    

    [geoCoder reverseGeocodeLocation:ll completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error){
            NSLog(@"%@", error);
        } else {
            for (CLPlacemark* placemark in placemarks) {
                id b = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
                myAddress = [NSString stringWithFormat:@"%@", b];
                NSLog(@"address = %@", myAddress);
            }
            
        }
        
    }];

    
    labelShowingBusRoutes.text = busRoutes;
    labelShowingAddress.text = myAddress;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
