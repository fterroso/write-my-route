//
//  TrackProcessViewController.m
//  RouteWriter
//
//  Created by Fernando  Terroso Saenz on 26/08/12.
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

#import "TrackProcessViewController.h"
#import "Track.h"
#import "Track+Create.m"
#import "TrackDatabaseProvider.h"
#import "UIView+Origami.h"

@interface TrackProcessViewController()
@property (nonatomic,strong)NSDate *startDate;
@property (nonatomic,strong)NSDate *endDate;
@property (nonatomic,strong)NSMutableDictionary *comments;
@property (nonatomic, strong) GPSTracker *tracker;
@end

@implementation TrackProcessViewController
@synthesize pauseStopTrackButtonImage = _pauseStopTrackButtonImage;
@synthesize pauseStopTrackButtonLabel = _pauseStopTrackButtonLabel;
@synthesize pauseStopTrackButtonSecondaryLabel1 = _pauseStopTrackButtonSecondaryLabel1;
@synthesize pauseStopTrackButton = _pauseStopTrackButton;
@synthesize currentTrackName = _currentTrackName;
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize addComment = _addComment;
@synthesize tracker = _tracker;
@synthesize trackDatabase = _trackDatabase;
@synthesize statusLabel = _statusLabel;
@synthesize gatheringIndicator = _gatheringIndicator;
@synthesize addCommentView = _addCommentView;
@synthesize mainView = _mainView;
@synthesize commentTextField = _commentTextField;
@synthesize finishTrackButton = _finishTrackButton;
@synthesize sampling = _sampling;
@synthesize comments = _comments;

#define PAUSE_LABEL @"Pause track"
#define RESTART_LABEL @"Restart track"

#define PLAY_STATE_MESSAGE @"Gathering locations"
#define PAUSE_STATE_MESSAGE @"Paused"

#define INTRODUCTORY_TEXT_FOR_COMMENT @"Insert text here..."

-(GPSTracker *)tracker
{
    if(!_tracker) _tracker = [GPSTracker new];
    return _tracker;    
}

-(NSMutableDictionary *)comments
{
    if(!_comments) _comments = [NSMutableDictionary dictionaryWithCapacity:5];
    return _comments;
}

-(void)setTrackDatabase:(UIManagedDocument *)trackDatabase
{
    if(_trackDatabase != trackDatabase){
        _trackDatabase = trackDatabase;        
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


-(void)viewWillAppear:(BOOL)animated
{

    self.statusLabel.text = PLAY_STATE_MESSAGE;
    [self.gatheringIndicator startAnimating];
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
   if(!self.trackDatabase){
        [[TrackDatabaseProvider sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document) {
            
            self.trackDatabase = document;
            
        }];
    }
    self.startDate = [NSDate date];
    [self.tracker startNewTrack:self.currentTrackName withMonitorTime:[NSNumber numberWithInt:[self.sampling intValue]]];
    
    self.gatheringIndicator.hidesWhenStopped = YES;
    self.commentTextField.delegate = self;
    
}

- (IBAction)pauseTrack:(id)sender {
    
    if([self.pauseStopTrackButtonLabel.text isEqualToString:PAUSE_LABEL]){
        [self.tracker pauseCurrentTrack];
        [self.gatheringIndicator stopAnimating];
        self.pauseStopTrackButtonLabel.text = RESTART_LABEL;
        self.statusLabel.text = PAUSE_STATE_MESSAGE;
        self.pauseStopTrackButtonSecondaryLabel1.text = @"Restart to";
        self.pauseStopTrackButtonImage.image = [UIImage imageNamed:@"rewind_to_start_01@2x.png"];
    }else if([self.pauseStopTrackButtonLabel.text isEqualToString:RESTART_LABEL]){
        [self.tracker restartCurrentTrack];
        [self.gatheringIndicator startAnimating];
        self.pauseStopTrackButtonLabel.text = PAUSE_LABEL;
        self.statusLabel.text = PLAY_STATE_MESSAGE;
        self.pauseStopTrackButtonSecondaryLabel1.text = @"Stop temporarily to";
        self.pauseStopTrackButtonImage.image = [UIImage imageNamed:@"video_pause_48.png"];

    }

}

- (IBAction)finishTrack {
    self.endDate = [NSDate date];
    NSArray *locations = [self.tracker finishCurrentTrack];
    if([locations count]>= 1){
        [Track createTrackWithName:self.currentTrackName withStartDate:self.startDate withEndDate:self.endDate withLocations:locations withComments:self.comments inManagedObjectContext:self.trackDatabase.managedObjectContext];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Track finished" message:@"The track has just been finished and saved." delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        //Mensaje de alerta
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Track finished" message:@"The track doesn't comprise any location. It won't be saved." delegate:nil cancelButtonTitle:@"Accept" otherButtonTitles:nil, nil];
        [alert show];
    }
    [self dismissModalViewControllerAnimated:YES];

}

- (IBAction)addComment:(id)sender {
    
    [self.tracker pauseCurrentTrack];
    [self.gatheringIndicator stopAnimating];
    self.statusLabel.text = PAUSE_STATE_MESSAGE;
    
    [self.mainView showOrigamiTransitionWith:self.addCommentView
                                 NumberOfFolds:4
                                      Duration:1
                                     Direction:XYOrigamiDirectionFromRight
                                    completion:nil];
}

- (IBAction)addCommentText:(id)sender {
    
    NSString *commentText = self.commentTextField.text;
    
    if(commentText.length > 1){
        CLLocation *location = [self.tracker getSingleLocation];
        [self.comments setObject:commentText forKey:[location description]];
    }

    
    [self.mainView hideOrigamiTransitionWith:self.addCommentView NumberOfFolds:4 Duration:1 Direction:XYOrigamiDirectionFromRight completion:^(BOOL completed){
        if(completed){
            if([self.pauseStopTrackButtonLabel.text isEqualToString:PAUSE_LABEL]){
                [self.tracker restartCurrentTrack];
                self.statusLabel.text = PLAY_STATE_MESSAGE;
                [self.gatheringIndicator startAnimating];
                self.finishTrackButton.enabled = YES;
            }
            self.commentTextField.text = INTRODUCTORY_TEXT_FOR_COMMENT;
            self.commentTextField.textColor = [UIColor grayColor];
        }
    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if([textView.text isEqualToString:INTRODUCTORY_TEXT_FOR_COMMENT]){
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

- (void)viewDidUnload
{
    [self setPauseStopTrackButtonImage:nil];
    [self setPauseStopTrackButtonLabel:nil];
    [self setPauseStopTrackButtonSecondaryLabel1:nil];
    [self setStatusLabel:nil];
    [self setGatheringIndicator:nil];
    [self setAddCommentView:nil];
    [self setMainView:nil];
    [self setCommentTextField:nil];
    [self setFinishTrackButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
