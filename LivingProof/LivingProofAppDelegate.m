//
//  LivingProofAppDelegate.m
//  LivingProof
//
//  Created by Andrew Kutta on 6/16/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "LivingProofAppDelegate.h"
#import "MainScreenViewController.h"
#import "CategoriesViewController.h"
#import "YouTubeInterface.h"
#import "Settings.h"

#import "FlurryAnalytics.h"
#import "UIDevice+Identifier.h"

#import "CoreLocation/CLLocationManager.h"

#define kFlurryKey @"4JNASXVGUMNS3WPLG8BZ"

// Uncomment to test gps locationing
//#define USE_DEEPER_LOCATION

@interface LivingProofAppDelegate (Private)

@end

@implementation LivingProofAppDelegate


@synthesize window=_window, categories, curView, curOrientation;//, mEntriesFeed, mEntriesFetchTicket;

-(UIViewAnimationTransition)getAnimation:(BOOL)goingForward {
    UIViewAnimationTransition animation = UIViewAnimationTransitionNone;
    return animation;
}

// Singleton
-(Settings*) settings {
    static Settings* ret;
    if ( ret == nil )
        ret = [[Settings alloc] init ];
    
    return ret;
}

// Singleton
-(YouTubeInterface*) iYouTube {
    if ( !iYouTube ) {
        iYouTube = [[YouTubeInterface alloc] init];
    }
    return iYouTube;
}

-(void)setCurrentController:(id)controller
{
    [self setCurView:controller];
}

-(void)reloadCurrentGrid
{
    if ( curView != nil ) {
        if ( [curView respondsToSelector:@selector(reloadCurrentGrid)] ) {
            [curView reloadCurrentGrid];
        } else {
            //NSLog(@"%@ Doesn't respond to reloadCurrentGrid",curView);
        }
    } else {
    }
}

-(void)goHome:(UIView*)lastView
{
    MainScreenViewController *nextView = [[MainScreenViewController alloc] initWithNibName:@"MainScreenViewController"
                                                                                    bundle:nil];
    [self switchView:lastView
                  toView:nextView.view
           withAnimation:[self getAnimation:NO] 
           newController:nextView];
}

-(void)switchView:(UIView *)view1 toView:(UIView*)view2 withAnimation:(UIViewAnimationTransition)transition newController:(id)controller
{
    //NSLog(@"newController:  %@",controller);
    
    [self setCurView:controller];
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:transition forView:self.window cache:YES];
    [view1 removeFromSuperview];
    [_window addSubview:view2];
    [UIView commitAnimations];
}

// Crash exception handler logged to Flurry
void uncaughtExceptionHandler(NSException *exception)
{
  [FlurryAnalytics logError:@"Uncaught" message:@"Crash!" exception:exception];
}
  
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];

    // load Flurry
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [FlurryAnalytics startSession:kFlurryKey];

    // Set unique device
    [FlurryAnalytics setUserID:[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier]]; 

    // Add Deeper Location Using GPS
    

#ifdef USE_DEEPER_LOCATION
    // This is used to determine the effects of adding new videos for the study that is being 
    // performed on the benefits of these videos
    //
    // Without this enabled, just able to obtain general continent versus city.
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    [locationManager startUpdatingLocation];
    
    CLLocation *location = locationManager.location;
    
    [FlurryAnalytics setLatitude:location.coordinate.latitude            
                       longitude:location.coordinate.longitude            
              horizontalAccuracy:location.horizontalAccuracy            
                verticalAccuracy:location.verticalAccuracy];
    
#endif
 
    MainScreenViewController *firstView = [[MainScreenViewController alloc] initWithNibName:@"MainScreenViewController" bundle:nil];
    [self setCurView:firstView];
    main = firstView;
    [_window addSubview:main.view];
    //[firstView release];

    //
    // Start downloading videos from youtube
    //

    [[self iYouTube] loadVideoFeed];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    //NSLog(@"WillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    //NSLog(@"DidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    /*[_window release];
    [categories release];
    [iYouTube release];

    [super dealloc];(*/
}

@end
