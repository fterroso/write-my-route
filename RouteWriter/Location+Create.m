//
//  Location+Create.m
//  RouteWriter
//
//  Created by Fernando  Terroso Saenz on 12/05/12.
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

#import "Location+Create.h"

@implementation Location (Create)


+(Location *) createLocationWithLocation:(CLLocation *)loc
                              withNumSeq:(NSNumber *)numSeq
                             withComment:(NSString *)comment
                                 inTrack:(Track *)track
                  inManagedObjectContext:(NSManagedObjectContext *)context
{
    Location *location = nil;
    
    NSString *uniqueID = [NSString stringWithFormat:@"%@",[NSDate date]];
    uniqueID = [uniqueID stringByAppendingString:[NSString stringWithFormat:@"_%i",[numSeq intValue]]];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    request.predicate = [NSPredicate predicateWithFormat:@"uniqueId = %@", uniqueID];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"uniqueId" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *locations = [context executeFetchRequest:request error:&error];
    
    if (!locations || ([locations count] > 1)) {
        // handle error
    } else if (![locations count]) {
        location = [NSEntityDescription insertNewObjectForEntityForName:@"Location"
                                                     inManagedObjectContext:context];
        location.uniqueId = uniqueID;
        location.myTrack = track;
        location.numSeq = numSeq;
        location.latitude = [NSNumber numberWithDouble:loc.coordinate.latitude];
        location.longitude = [NSNumber numberWithDouble:loc.coordinate.longitude];
        location.comment = comment;
        location.timestamp = loc.timestamp;
        
    } else {
        location = [locations lastObject];
    }
    
    return location;
}

-(NSString *)gpxContent{
    
    NSMutableString *content = [[NSMutableString alloc] init];
    
    [content appendFormat:@"<trkpt lat=\"%f\" lon=\"%f\">\n", [self.latitude doubleValue], [self.longitude doubleValue]];
    
    if(self.comment){
        [content appendFormat:@"\t<cmt>%@</cmt>\n", self.comment];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [content appendFormat:@"<time>%@</time>\n",[dateFormatter stringFromDate:self.timestamp]];
    [content appendString:@"</trkpt>\n"];
    
    
    return content;
    
}

/*
-(MKMapPoint ) convertToMKMapPoint
{
    
    MKMapPoint point;
    
    point.x = [self.latitude doubleValue];
    point.y = [self.longitude doubleValue];
    
    return point;
}
*/
@end
