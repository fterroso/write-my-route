//
//  FirstViewController.m
//  RouteWriter
//
//  Created by Fernando  Terroso Saenz on 22/04/12.
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

#import "FirstViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TrackDatabaseProvider.h"
#import "Location.h"
#import "Track+Create.m"
#import "TrackProcessViewController.h"

@interface FirstViewController()

@property (nonatomic,weak) NSString *currentTrackName;
@property (nonatomic,weak) NSNumber *sampling;
@end

@implementation FirstViewController
@synthesize startPauseButton = _startPauseButton;
@synthesize currentTrackName = _currentTrackName;
@synthesize sampling = _sampling;

- (IBAction)startTrace:(UIButton *)sender {
            
        [self performSegueWithIdentifier:@"ShowTrackSetup" sender:self];
}



-(void)startTrackWithName:(NSString *)name samplingRate:(NSNumber *)sampling
{        
        self.currentTrackName = name;
        self.sampling = sampling;
        
        [self performSegueWithIdentifier:@"ShowTracking" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowTrackSetup"]) { 
        
        SetupTrackViewController *setupViewController = (SetupTrackViewController *)segue.destinationViewController;
        setupViewController.delegate = self;
        
    }else if([segue.identifier isEqualToString:@"ShowTracking"]) { 
        TrackProcessViewController *trackViewController = (TrackProcessViewController *)segue.destinationViewController;
        trackViewController.currentTrackName = self.currentTrackName;
        trackViewController.sampling = self.sampling;
    }
}


- (void)viewDidUnload {
    [self setStartPauseButton:nil];
    [super viewDidUnload];
}
@end
