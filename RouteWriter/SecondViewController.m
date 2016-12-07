//
//  SecondViewController.m
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

#import "SecondViewController.h"
#import "TrackDatabaseProvider.h"
#import "Track.h"
#import "Track+Create.h"
#import "TrackCell.h"


@implementation SecondViewController

@synthesize trackDatabase = _trackDatabase;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!self.trackDatabase){
        [[TrackDatabaseProvider sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
            self.trackDatabase = document;

            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Track"];
            request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];

            self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request                                                                           managedObjectContext:document.managedObjectContext                                                                                  sectionNameKeyPath:nil                                                                                           cacheName:nil];

        }];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Track Cell";
    
    TrackCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [TrackCell new];//[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // ask NSFetchedResultsController for the NSMO at the row in question
    Track *track = [self.fetchedResultsController objectAtIndexPath:indexPath];
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    cell.trackName.text = track.name;
    cell.startDate.text = [dateFormatter stringFromDate:track.start];
    cell.endDate.text =  [dateFormatter stringFromDate:track.end];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        Track *track = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.trackDatabase.managedObjectContext deleteObject:track];

    }
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Track *track = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([segue.destinationViewController respondsToSelector:@selector(setMyTrack:)]) {
        [segue.destinationViewController performSelector:@selector(setMyTrack:) withObject:track];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)exportTrack:(id)sender {
    
    UIButton *button = (UIButton *) sender;
    
    TrackCell *cell = (TrackCell *) [[button superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Track *track = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        
        mail.mailComposeDelegate = self;
        NSMutableString *subject = [[NSMutableString alloc] init];
        [subject appendFormat:@"[Route Writer app]Track %@", track.name];
        
        [mail setSubject:subject];
                
        NSString *body = [track contentForEmail];
        [mail setMessageBody:body isHTML:NO];
        
        [self presentModalViewController:mail animated:YES];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissModalViewControllerAnimated:YES];
}


@end
