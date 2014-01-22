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

@interface ViewController () <MKMapViewDelegate>
{
    NSArray *busRoutes;
    
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
        NSArray *routeDetails = [busRoutes valueForKey:@"row"];
        NSLog(@"routes = %@", routeDetails);
        NSLog(@"routes = %i", routeDetails.count);
        
        for (NSDictionary *dictionary in routeDetails){
            
            NSString *name = dictionary [@"cta_stop_name"];
            NSString *valueLongitude = dictionary[@"longitude"];
            double longitude = [valueLongitude doubleValue];
            NSString *valueLatitude = dictionary[@"latitude"];
            double latitude = [valueLatitude doubleValue];

            MKPointAnnotation* annotation = [MKPointAnnotation new];
            annotation.title = name;
            annotation.subtitle = dictionary[@"routes"];
//            annotationView.canShowCallout = YES;
            annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
            [myMapView addAnnotation:annotation];
            
            CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
            
            CLGeocoder* geoCoder = [CLGeocoder new];

            
            [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            
                if (error){
                     NSLog(@"%@", error);
                } else {
                    for (CLPlacemark* placemark in placemarks) {
                        id b = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
                        id myAddress = [NSString stringWithFormat:@"%@", b];
                        NSLog(@"address = %@", myAddress);
                    }
                    
                }
                
            }];
            
        }

        NSLog(@"I am new");
        
    }];
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    RouteDetailsViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FooBar"];
    vc. title = view.annotation.title;
//    vc.address = view.annotation.su
    vc.busRoutes = view.annotation.subtitle;
    vc.location = view.annotation.coordinate;
    
    
    [self.navigationController pushViewController:vc  animated:YES];

    
}
/*
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    

    RouteDetailsViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FooBar"];
    vc. title = view.annotation.title;

    
    [self.navigationController pushViewController:vc  animated:YES];
    
    
    
    
    
}
 */
- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annotationView = [mV dequeueReusableAnnotationViewWithIdentifier:@"Don Bora"];
    
    if (annotationView == nil){
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"Don Bora"];
        
    } else {
        annotationView.annotation = annotation;
        
    }
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;

}

@end
