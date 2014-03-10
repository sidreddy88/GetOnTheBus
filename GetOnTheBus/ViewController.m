//
//  ViewController.m
//  GetOnTheBus
//
//  Created by Siddharth Sukumar on 1/21/14.
//  Copyright (c) 2014 Siddharth Sukumar. All rights reserved.
//

#import "ViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <MapKit/MapKit.h>
#import "RouteDetailsViewController.h"
#import "NewPointAnnotation.h"
#import "NewAnnotationView.h"

@interface ViewController () <MKMapViewDelegate>
{
    NSDictionary *busRoutes;
    
    IBOutlet MKMapView *myMapView;
    CLLocationCoordinate2D MMHQCOORDINATE;
   
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    MMHQCOORDINATE = CLLocationCoordinate2DMake(41.89373984, -87.63532979);
    
   MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(MMHQCOORDINATE, span);
    [myMapView setRegion: region animated:YES];
 //   mapView.showsUserLocation = YES;
    
    NSURL *url = [NSURL URLWithString:@"http://dev.mobilemakers.co/lib/bus.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        busRoutes = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];
        NSLog(@"routes = %@", busRoutes);
        NSArray *routeDetails = [busRoutes valueForKey:@"row"];

        
        for (NSDictionary *dictionary in routeDetails){
            
            NSString *name = dictionary [@"cta_stop_name"];
            NSString *valueLongitude = dictionary[@"longitude"];
            double longitude = [valueLongitude doubleValue];
            NSString *valueLatitude = dictionary[@"latitude"];
            double latitude = [valueLatitude doubleValue];
            
            NewPointAnnotation *newAnnotation = [NewPointAnnotation new];

 //           MKPointAnnotation* annotation = [MKPointAnnotation new];
            newAnnotation.title = name;
            newAnnotation.subtitle = dictionary[@"routes"];
//            annotationView.canShowCallout = YES;
            newAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
            [myMapView addAnnotation:newAnnotation];
            NSString *mine = dictionary[@"inter_modal"];
                              NSLog (@"name = %@", mine);
            if ([dictionary[@"inter_modal"] isEqualToString:@"Metra"] || [dictionary[@"inter_modal"] isEqualToString:@"Pace"]){
                newAnnotation.intermodalTransfers = @"";
                newAnnotation.intermodalTransfers = dictionary[@"inter_modal"];
                
            } else {
                newAnnotation.intermodalTransfers = @"";
                
            }
                            
        }

        
    }];
   
}

- (void)mapView:(MKMapView *)mapView annotationView:(NewAnnotationView*)view calloutAccessoryControlTapped:(UIControl *)control {
    
    RouteDetailsViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FooBar"];
    vc. title = view.annotation.title;
    vc.busRoutes = view.annotation.subtitle;
    vc.location = view.annotation.coordinate;
    
    vc.intermodalTransferRoutes = view.annotation.intermodalTransfers;
    
    
    
   
    [self.navigationController pushViewController:vc  animated:YES];

    
}


- (NewAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id<MKAnnotation>)annotation {
    NewAnnotationView *annotationView = [mV dequeueReusableAnnotationViewWithIdentifier:@"Don Bora"];
    
    if (annotationView == nil){
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"Don Bora"];
        
    } else {
        annotationView.annotation = annotation;
        
    }
    if ([annotationView.annotation.intermodalTransfers isEqualToString:@"Metra"] || [annotationView.annotation.intermodalTransfers isEqualToString:@"Pace"]){
        annotationView.image = [UIImage imageNamed:@"metralogo"];
            }
    
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;

}


@end
