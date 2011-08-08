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
                                                                                            bundle:nil category:_curCategory 
                                                                                            filter:_curFilter 
                                                                                        buttonText:previousButtonTitle];
    [delegate switchView:self.view toView:nextView.view withAnimation:UIViewAnimationTransitionFlipFromLeft newController:nextView]; 
    [delegate reloadCurrentGrid];
}


- (void)embedYouTube:(NSURL*)url frame:(CGRect)frame {
    NSString* embedHTML = @"<html><head> <style type=\"text/css\"> body { background-color: transparent; color: white; } </style> </head><body style=\"margin:0\"> <embed src=\"%@\" type=\"application/x-shockwave-flash\" width=\"%0.0f\" height=\"%0.0f\"></embed> </body></html>";
    
    NSString* html = [NSString stringWithFormat:embedHTML, url, frame.size.width, frame.size.height];
    if(videoView == nil) {
        videoView = [[UIWebView alloc] initWithFrame:frame];
        [self.view addSubview:videoView];
    }
    [videoView loadHTMLString:html baseURL:nil];
}


- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
                video:(Video *)video
          curCategory:curCategory 
               filter:_searchText
          buttonTitle:(NSString*)curTitle
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        previousButtonTitle = [[NSString alloc] initWithString:curTitle];
        
        _curCategory = curCategory;
        _curFilter = _searchText;
        
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
    
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    if ( curVideo ) {
        
        name.text = curVideo.parsedKeys.name;
        age.text = curVideo.parsedKeys.age;
        survivorshipLength.text = curVideo.parsedKeys.survivorshipLength;
        treatment.text = curVideo.parsedKeys.treatment;
        maritalStatus.text = curVideo.parsedKeys.maritalStatus;
        employmentStatus.text = curVideo.parsedKeys.employmentStatus;
        childrenStatus.text = curVideo.parsedKeys.childrenStatus;
        
        //NSLog(@"%@",curVideo.url);
        
        [self embedYouTube:curVideo.url frame:CGRectMake(79, 130, 451, 443)];
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



@end
