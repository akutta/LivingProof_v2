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
    
    
    NSString* _curCategory;
    NSString* _curFilter;
    NSArray* _relatedVideos;
    
    AQGridView *_gridView;
}

@property (nonatomic, retain) IBOutlet AQGridView *gridView;

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
