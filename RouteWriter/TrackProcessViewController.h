//
//  TrackProcessViewController.h
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

#import <UIKit/UIKit.h>
#import "GPSTracker.h"


@interface TrackProcessViewController : UIViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *pauseStopTrackButton;

@property (weak, nonatomic) IBOutlet UIImageView *pauseStopTrackButtonImage;

@property (weak, nonatomic) IBOutlet UILabel *pauseStopTrackButtonLabel;
@property (weak, nonatomic) IBOutlet UILabel *pauseStopTrackButtonSecondaryLabel1;

@property (weak, nonatomic) IBOutlet UIButton *addComment;

@property (strong, nonatomic) UIManagedDocument *trackDatabase;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *gatheringIndicator;

@property (weak, nonatomic) IBOutlet UIView *addCommentView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UITextView *commentTextField;

@property (strong, nonatomic) IBOutlet UIButton *finishTrackButton;

@property (nonatomic,weak) NSString *currentTrackName;
@property (nonatomic,weak) NSNumber *sampling;
@end
