//
//  TrackDatabaseProvider.m
//  RouteWriter
//
//  Created by Fernando  Terroso Saenz on 09/05/12.
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

#import "TrackDatabaseProvider.h"
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@implementation TrackDatabaseProvider

@synthesize document = _document;

static TrackDatabaseProvider *_sharedInstance;

+ (TrackDatabaseProvider *)sharedDocumentHandler
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"Defaulttrackbase"];
        
        self.document = [[UIManagedDocument alloc] initWithFileURL:url];
        // Set our document up for automatic migrations
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        self.document.persistentStoreOptions = options;
    }
    return self;
}

- (void)performWithDocument:(OnDocumentReady)onDocumentReady
{    

    void (^OnDocumentDidLoad)(BOOL) = ^(BOOL success) {
        onDocumentReady(self.document);
    };
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.document.fileURL path]]) {

        [self.document saveToURL:self.document.fileURL
                forSaveOperation:UIDocumentSaveForCreating
               completionHandler:OnDocumentDidLoad];

        
    } else if (self.document.documentState == UIDocumentStateClosed) {

        [self.document openWithCompletionHandler:OnDocumentDidLoad];

    } else if (self.document.documentState == UIDocumentStateNormal) {

        OnDocumentDidLoad(YES);

    }

}

@end
