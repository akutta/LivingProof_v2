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

#define kFlurryKey @"4JNASXVGUMNS3WPLG8BZ"


@interface LivingProofAppDelegate (Private)

@end

@implementation LivingProofAppDelegate


@synthesize window=_window, categories, curView;//, mEntriesFeed, mEntriesFetchTicket;

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

-(void)reloadCurrentGrid
{
    if ( curView != nil ) {
        if ( [curView respondsToSelector:@selector(reloadCurrentGrid)] ) {
            [curView reloadCurrentGrid];
        } else {
        }
    }
}

-(void)switchView:(UIView *)view1 toView:(UIView*)view2 withAnimation:(UIViewAnimationTransition)transition newController:(id)controller
{
    [self setCurView:controller];
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:transition forView:self.window cache:YES];
    [view1 removeFromSuperview];
    [_window addSubview:view2];
    [UIView commitAnimations];
}

void uncaughtExceptionHandler(NSException *exception)
{
  [FlurryAnalytics logError:@"Uncaught" message:@"Crash!" exception:exception];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
  [FlurryAnalytics startSession:kFlurryKey]; //your code
}
  
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];

    // load Flurry
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [FlurryAnalytics startSession:kFlurryKey];
    
    // Switched to a new welcome screen
    
//    CategoriesViewController *firstView = [[CategoriesViewController alloc] initWithNibName:@"CategoriesViewController" bundle:nil];
//    [self setCurView:firstView];
//    self.categories = firstView;
//    [_window addSubview:categories.view];
//    [firstView release];
     
    MainScreenViewController *firstView = [[MainScreenViewController alloc] initWithNibName:@"MainScreenViewController" bundle:nil];
    [self setCurView:firstView];
    main = firstView;
    [_window addSubview:main.view];
    [firstView release];
    
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
    [_window release];
    [categories release];
    [iYouTube release];
    [super dealloc];
}

@end
