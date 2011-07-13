//
//  VideoPlayerViewController.m
//  LivingProof
//
//  Created by Andrew Kutta on 6/16/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "LivingProofAppDelegate.h"
#import "VideoPlayerViewController.h"
#import "VideoSelectionViewController.h"

@implementation VideoPlayerViewController

-(IBAction)swapViews:(id)sender
{
    LivingProofAppDelegate *delegate = (LivingProofAppDelegate*)[[UIApplication sharedApplication] delegate];
    VideoSelectionViewController *nextView = [[VideoSelectionViewController alloc] initWithNibName:@"VideoSelectionViewController" 
                                                                                            bundle:nil 
                                                                                        buttonText:previousButtonTitle];
    [delegate switchView:self.view toView:nextView.view withAnimation:UIViewAnimationTransitionFlipFromLeft newController:nextView]; 
    [delegate reloadCurrentGrid];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil video:(Video *)video buttonTitle:(NSString*)curTitle
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        previousButtonTitle = [[NSString alloc] initWithString:curTitle];
        
        // Custom initialization
        curVideo = video;
        [curVideo retain];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    // Force the application into Landscape view
    UIApplication *application = [UIApplication sharedApplication];
    application.statusBarOrientation = UIInterfaceOrientationLandscapeRight;
    
    if ( curVideo ) {
        
        name.text = curVideo.parsedKeys.name;
        age.text = curVideo.parsedKeys.age;
        survivorshipLength.text = curVideo.parsedKeys.survivorshipLength;
        treatment.text = curVideo.parsedKeys.treatment;
        maritalStatus.text = curVideo.parsedKeys.maritalStatus;
        employmentStatus.text = curVideo.parsedKeys.employmentStatus;
        childrenStatus.text = curVideo.parsedKeys.childrenStatus;
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations

	return YES;
}

//
// Clean up memory here
//
- (void)moviePlaybackComplete:(NSNotification *)notification
{
    MPMoviePlayerController *moviePlayerController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerController];
    
    [moviePlayerController.view removeFromSuperview];
    [moviePlayerController release];
}

//
// Play Moview
//
-(IBAction)playMovie:(id)sender
{
    //NSString *filepath   =   [[NSBundle mainBundle] pathForResource:@"big-buck-bunny-clip" ofType:@"m4v"];
    //NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
    NSURL *fileURL = [curVideo url];
    NSLog(@"fileURL:\r%@",fileURL);
    
    MPMoviePlayerController *moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
    //[self.view addSubview:moviePlayerController.view];
    
    
    /*[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackComplete:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayerController];
    */
    moviePlayerController.fullscreen = NO;
    [moviePlayerController play];
 
}

@end
