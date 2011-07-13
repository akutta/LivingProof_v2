//
//  VideoPlayerViewController.h
//  LivingProof
//
//  Created by Andrew Kutta on 6/16/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Video.h"

@interface VideoPlayerViewController : UIViewController {
    Video *curVideo;
    NSString *previousButtonTitle;
    
    IBOutlet UILabel *age;
    IBOutlet UILabel *name;
    IBOutlet UILabel *survivorshipLength;
    IBOutlet UILabel *treatment;
    IBOutlet UILabel *maritalStatus;
    IBOutlet UILabel *employmentStatus;
    IBOutlet UILabel *childrenStatus;
}


-(IBAction)swapViews:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil video:(Video *)video buttonTitle:(NSString*)curTitle;


// MediaPlayer Framework Controls
-(IBAction)playMovie:(id)sender;
@end
