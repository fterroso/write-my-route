//
//  GPSTracker.h
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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface GPSTracker : NSObject<CLLocationManagerDelegate>

@property (nonatomic,strong) NSString *trackName;
@property (nonatomic,strong) NSNumber *trackInterval;

-(void)startNewTrack:(NSString *)string withMonitorTime:(NSNumber *)monitorTime;
-(void)pauseCurrentTrack;
-(void)restartCurrentTrack;
-(CLLocation *)getSingleLocation;
-(NSArray *)finishCurrentTrack;
@end

