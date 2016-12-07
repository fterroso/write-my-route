//
//  SetupTrackViewController.m
//  RouteWriter
//
//  Created by Fernando  Terroso Saenz on 30/04/12.
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

#import "SetupTrackViewController.h"


@implementation SetupTrackViewController
@synthesize trackName;
@synthesize delegate = _delegate;
@synthesize samplingRate = _samplingRate;
@synthesize samplingValueLabel = _samplingValueLabel;


- (IBAction)sliderNewValue:(UISlider *)sender {
    self.samplingRate = [NSNumber numberWithInt:sender.value];
    self.samplingValueLabel.text = [self.samplingRate stringValue];
}

- (IBAction)setupDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    
        [self.delegate startTrackWithName:self.trackName.text 
                             samplingRate:self.samplingRate];
    }];
}
- (IBAction)setupCancel:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)sender
{
    if([sender.text length]){
        [sender resignFirstResponder];
        return YES;
    }else{
        NSLog(@"You should write something");
        return NO;
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{    
    [textField selectAll:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated]; 
    
    self.trackName.delegate = self;
    self.trackName.autocorrectionType = FALSE;
    self.trackName.returnKeyType = UIReturnKeyGo;
        
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YY_HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    self.trackName.text = dateString;
    
    self.samplingRate = [NSNumber numberWithInt:30];
    self.samplingValueLabel.text = [self.samplingRate stringValue];
        
}


- (void)viewDidUnload {
    [self setTrackName:nil];
    [self setSamplingValueLabel:nil];
    [super viewDidUnload];
}
@end
