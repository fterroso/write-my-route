//
//  Location.h
//  RouteWriter
//
//  Created by Fernando  Terroso Saenz on 30/09/12.
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
#import <CoreData/CoreData.h>

@class Track;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * numSeq;
@property (nonatomic, retain) NSString * uniqueId;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) Track *myTrack;

@end
