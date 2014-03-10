//
//  NewAnnotationView.h
//  GetOnTheBus
//
//  Created by Siddharth Sukumar on 1/22/14.
//  Copyright (c) 2014 Siddharth Sukumar. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "NewPointAnnotation.h"

@interface NewAnnotationView : MKAnnotationView

@property NewPointAnnotation *annotation;

@end
