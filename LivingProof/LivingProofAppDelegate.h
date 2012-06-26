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


@class MainScreenViewController;
@class CategoriesViewController;
@class GDataFeedYouTubeVideo;
@class GDataServiceTicket;

@interface LivingProofAppDelegate : NSObject <UIApplicationDelegate> {
//    CategoriesViewController *categories;
    MainScreenViewController *main;
    id curView;
    
    YouTubeInterface *iYouTube;
    NSArray* categoryArray;
}
// Essentially global Variables
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) CategoriesViewController *categories;
@property (nonatomic, retain) id curView;
@property (nonatomic) UIInterfaceOrientation curOrientation;

-(void)goHome:(UIView*)lastView;
-(Settings*) settings;
-(void)reloadCurrentGrid;
-(void)switchView:(UIView *)view1 toView:(UIView*)view2 withAnimation:(UIViewAnimationTransition)transition newController:(id)controller;
-(YouTubeInterface*) iYouTube;
-(UIViewAnimationTransition)getAnimation:(BOOL)goingForward;
-(void)setCurrentController:(id)controller;
@end
