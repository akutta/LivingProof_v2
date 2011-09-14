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
#import "AQGridView.h"

@interface VideoPlayerViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource> {
    Video *curVideo;
    NSString *previousButtonTitle;
    
    UIWebView *videoView;
    
    IBOutlet UILabel *age;
    IBOutlet UILabel *name;
    IBOutlet UILabel *survivorshipLength;
    IBOutlet UILabel *treatment;
    IBOutlet UILabel *maritalStatus;
    IBOutlet UILabel *employmentStatus;
    IBOutlet UILabel *childrenStatus;
    IBOutlet UILabel *videoTitle;
    
    IBOutlet UILabel *ageLabel;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *survivorshipLabel;
    IBOutlet UILabel *treatmentLabel;
    IBOutlet UILabel *maritalStatusLabel;
    IBOutlet UILabel *employentLabel;
    IBOutlet UILabel *childrenLabel;

    IBOutlet UIView* notificationView;
    
    NSString* _curCategory;
    NSString* _curFilter;
    NSArray* _relatedVideos;
    
    AQGridView *_gridView;
}

@property (nonatomic, retain) IBOutlet AQGridView *gridView;

@property (nonatomic, retain) IBOutlet UIView *notificationView;

-(void)updateLabels;
-(void)reloadCurrentGrid;
-(IBAction)swapViews:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
                video:(Video *)video
          curCategory:(NSString*)curCategory 
               filter:(NSString*)_searchText 
        relatedVideos:(NSArray*)relatedVideos
          buttonTitle:(NSString*)curTitle;
@end
