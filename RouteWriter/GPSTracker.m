//
//  GPSTracker.m
//  RouteWriter
//
//  Created by Fernando  Terroso Saenz on 26/04/12.
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

#import "GPSTracker.h"

@interface GPSTracker()
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) NSTimer *locationTimer;
@property (nonatomic,strong) NSMutableArray *locations;

-(void)startTimer;
-(void)getCurrentLocation;
@end

@implementation GPSTracker

@synthesize trackName = _trackName;
@synthesize trackInterval = _trackInterval;
@synthesize locationManager = _locationManager;
@synthesize locationTimer = _locationTimer;
@synthesize locations = _locations;

#define AD_MESSAGE @"This application needs to read the GPS location of the device so as to track you route. Do you agree?"

-(CLLocationManager *)locationManager
{
    if(!_locationManager){
        _locationManager = [CLLocationManager new];
    }
    
    return _locationManager;
    
}

-(void)startNewTrack:(NSString *)name withMonitorTime:(NSNumber *)monitorTime{
    self.trackName = name;
    self.trackInterval = monitorTime;
    
    self.locationManager.purpose = AD_MESSAGE;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    self.locations = [NSMutableArray arrayWithCapacity:20];
        
    [self startTimer];
    
}

-(void)pauseCurrentTrack{
    [self.locationTimer invalidate];
    [self.locationManager stopUpdatingLocation];
}

-(void)restartCurrentTrack{
    [self startTimer];
}

-(NSArray *)finishCurrentTrack{
    [self pauseCurrentTrack];
    
    return [NSArray arrayWithArray:self.locations];    
    
}

-(void)startTimer
{
    self.locationTimer = [NSTimer scheduledTimerWithTimeInterval:[self.trackInterval intValue]                                                                      
                                                          target:self
                                                        selector:@selector(getCurrentLocation)
                                                        userInfo:nil
                                                         repeats:YES];

}


-(CLLocation *)getSingleLocation{
    CLLocation *currentLoc = [self.locationManager.location copy];
    [self.locations addObject:currentLoc];   
    return currentLoc;
    
}

-(void)getCurrentLocation{

    if(self.locationManager.location != nil){
        CLLocation *currentLoc = [self.locationManager.location copy];
        // NSLog(@"%f %f", currentLoc.coordinate.latitude, currentLoc.coordinate.longitude);
        [self.locations addObject:currentLoc];  
    }
}
@end
