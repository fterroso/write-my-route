//
//  MapViewController.m
//  RouteWriter
//
//  Created by Fernando  Terroso Saenz on 21/05/12.
//  Copyright 2012 Fernando Terroso-Saenz (fterroso@um.es)
 // This file is part of Write My Route.
 // 
 // Write My Route is free software: you can redistribute it and/or modify
 // it under the terms of the GNU Lesser General Public License as published by
 // the Free Software Foundation, either version 3 of the License, or
 // (at your option) any later version.
 // 
 // Write My Route is distributed in the hope that it will be useful,
 // but WITHOUT ANY WARRANTY; without even the implied warranty of
 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 // GNU Lesser General Public License for more details.
 // 
 // You should have received a copy of the GNU Lesser General Public License
 // along with Write My Route.  If not, see http://www.gnu.org/licenses/.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Location.h"

@interface MapViewController(){ 
    MKMapRect routeRect;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKPolyline *line;
@property (strong, nonatomic) MKPolylineView *routeLineView;
@property (strong, nonatomic) NSMutableArray *annotations;
@end

@implementation MapViewController

@synthesize mapView;
@synthesize myTrack = _myTrack;
@synthesize line = _line;
@synthesize routeLineView = _routeLineView;
@synthesize annotations = _annotations;


-(void)loadRoute
{
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    
    MKMapPoint *pointArr = malloc(sizeof(CLLocationCoordinate2D) * self.myTrack.locations.count);

    MKMapPoint northEastPoint; 
	MKMapPoint southWestPoint; 
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"numSeq" ascending:YES];
    
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];    
    NSArray *orderedLocations = [self.myTrack.locations sortedArrayUsingDescriptors:descriptors];
    
    self.annotations = [[NSMutableArray alloc] initWithCapacity:10];
    
    int i = 0;
    for(Location *loc in orderedLocations){        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([loc.latitude doubleValue], [loc.longitude doubleValue]);
        
        if (loc.comment != nil) {
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
            annotation.title = @"Comment";
            annotation.subtitle = loc.comment;
            annotation.coordinate = coordinate;
            
            [self.annotations addObject:annotation];
        }
                
        MKMapPoint point = MKMapPointForCoordinate(coordinate);
        
        pointArr[i++] = point;

        if (i == 1) {
			northEastPoint = point;
			southWestPoint = point;
		}
		else 
		{
			if (point.x > northEastPoint.x) 
				northEastPoint.x = point.x;
			if(point.y > northEastPoint.y)
				northEastPoint.y = point.y;
			if (point.x < southWestPoint.x) 
				southWestPoint.x = point.x;
			if (point.y < southWestPoint.y) 
				southWestPoint.y = point.y;
		}
    }
           
    self.line = [MKPolyline polylineWithPoints:pointArr count:self.myTrack.locations.count];
    
    routeRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, northEastPoint.x - southWestPoint.x, northEastPoint.y - southWestPoint.y);
    
    free(pointArr);
}

-(void) zoomInOnRoute
{
	[self.mapView setVisibleMapRect:routeRect];
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [map dequeueReusableAnnotationViewWithIdentifier:@"MapRW"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapRW"];
        aView.canShowCallout = YES;
       // aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        // could put a rightCalloutAccessoryView here
    }
    
    aView.annotation = annotation;
    
    return aView;
}


-(void)setMyTrack:(Track *)myTrack
{
    if(!_myTrack){
        _myTrack = myTrack;
        self.title = myTrack.name;
        [self loadRoute];
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mapView.delegate = self;
	// add the overlay to the map
	if (nil != self.line) {
		[self.mapView addOverlay:self.line];
        [self.mapView addAnnotations:self.annotations];
        [self zoomInOnRoute];
	}}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id )overlay
{
    MKOverlayView* overlayView = nil;
    
    if(overlay == self.line)
    {
        //if we have not yet created an overlay view for this overlay, create it now.
        if(nil == self.routeLineView)
        {
            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.line];
            self.routeLineView.fillColor = [UIColor redColor];
            self.routeLineView.strokeColor = [UIColor redColor];
            self.routeLineView.lineWidth = 3;
        }
        
        overlayView = self.routeLineView;
        
    }
    
    return overlayView;
    
}

@end
