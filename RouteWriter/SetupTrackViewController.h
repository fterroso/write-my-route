//
//  SetupTrackViewController.h
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

#import <UIKit/UIKit.h>

@protocol SetupTrackViewControllerProtocol <NSObject>

-(void)startTrackWithName:(NSString *)name samplingRate:(NSNumber *)sampling;

@end

@interface SetupTrackViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *trackName;
@property (nonatomic,strong) id<SetupTrackViewControllerProtocol> delegate;
@property (nonatomic,strong) NSNumber *samplingRate;
@property (weak, nonatomic) IBOutlet UILabel *samplingValueLabel;
@end
