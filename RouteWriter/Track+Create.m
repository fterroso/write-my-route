//
//  Track+Create.m
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

#import "Track+Create.h"
#import "Location+Create.h"
#import <CoreLocation/CoreLocation.h>

@implementation Track (Create)

+(Track *)createTrackWithName:(NSString *)name
                withStartDate:(NSDate *)startDate
                  withEndDate:(NSDate *)endDate
                withLocations:(NSArray *)locations 
                 withComments:(NSDictionary *)comments
       inManagedObjectContext:(NSManagedObjectContext *)context{
    
    Track *track = nil;
    
    NSString *uniqueID = [NSString stringWithFormat:@"%@",[NSDate date]];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Track"];
    request.predicate = [NSPredicate predicateWithFormat:@"uniqueId = %@", uniqueID];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"uniqueId" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    NSError *error = nil;
    NSArray *tracks = [context executeFetchRequest:request error:&error];
    
    
    if (!tracks || ([tracks count] > 1)) {
        NSLog(@"Error while saving Track");
    } else if (![tracks count]) {
        track = [NSEntityDescription insertNewObjectForEntityForName:@"Track"
                                                 inManagedObjectContext:context];
        track.uniqueId = uniqueID;
        track.name = name;
        track.start = startDate;
        track.end = endDate;
    
        
    } else {
        track = [tracks lastObject];
    }
    

    int index = 1;
    for(CLLocation *loc in locations){
            [Location createLocationWithLocation:loc 
                                      withNumSeq:[NSNumber numberWithInt:index++] 
                                     withComment:[comments objectForKey:[loc description]]
                                         inTrack:track inManagedObjectContext:context];
        
    }
    
    
    return track;
}

-(NSString *)contentForEmail
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSMutableString *emailContent = [[NSMutableString alloc] init];
    
    [emailContent appendString:@"<?xml version=\"1.0\"?>\n<gpx version=\"1.0\" creator=\"Route Writer app\" xmlns=\"http://www.topografix.com/GPX/1/0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.topografix.com/GPX/1/0 http://www.topografix.com/GPX/1/0/gpx.xsd\">\n\t<trk>\n"]; 
    
    [emailContent appendFormat:@"\t\t<name>%@</name>\n", self.name];
    [emailContent appendFormat:@"\t\t<cmt>Start:%@ End: %@</cmt>\n",[dateFormatter stringFromDate:self.start], [dateFormatter stringFromDate:self.end]];
    
    [emailContent appendString:@"\t\t<trkseg>\n"];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"numSeq" ascending:YES];
    
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];    
    NSArray *orderedLocations = [self.locations sortedArrayUsingDescriptors:descriptors];
    
    for(Location *loc in orderedLocations){
        [emailContent appendString:loc.gpxContent];
    }

    
    [emailContent appendString:@"\t\t</trkseg>\n\t</trk>\n</gpx>\n"];
    
    return [NSString stringWithString:emailContent];
}

@end
