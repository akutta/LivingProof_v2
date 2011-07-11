//
//  LivingProofAppDelegate.h
//  LivingProof
//
//  Created by Andrew Kutta on 6/16/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YouTubeInterface.h"
#import "Settings.h"

@class CategoriesViewController;
@class GDataFeedYouTubeVideo;
@class GDataServiceTicket;

@interface LivingProofAppDelegate : NSObject <UIApplicationDelegate> {
    CategoriesViewController *categories;
    NSInteger killThread;
    id curView;
    YouTubeInterface *iYouTube;
    
    NSArray* categoryArray;
}

// Essentially global Variables
//@property (nonatomic, retain) GDataFeedYouTubeVideo *mEntriesFeed;
//@property (nonatomic, retain) GDataServiceTicket    *mEntriesFetchTicket;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) CategoriesViewController *categories;
@property (nonatomic, retain) id curView;

-(Settings*) settings;
-(void)reloadCurrentGrid;
-(void)switchView:(UIView *)view1 toView:(UIView*)view2 withAnimation:(UIViewAnimationTransition)transition newController:(id)controller;
-(YouTubeInterface*) iYouTube;
@end
