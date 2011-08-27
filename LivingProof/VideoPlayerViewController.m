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
#import "VideoGridCell.h"
#import "Video.h"
#import "UIImageView+WebCache.h"

@implementation VideoPlayerViewController


@synthesize gridView = _gridView;


-(void)reloadCurrentGrid
{
    [_gridView reloadData];
}


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
          curCategory:(NSString*)curCategory 
               filter:(NSString*)_searchText 
        relatedVideos:(NSArray*)relatedVideos
          buttonTitle:(NSString*)curTitle
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        previousButtonTitle = [[NSString alloc] initWithString:curTitle];
        
        _curCategory = curCategory;
        _curFilter = _searchText;
        _relatedVideos =  [[relatedVideos copy] retain];
        
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

- (void)updateLabels {
    name.text = curVideo.parsedKeys.name;
    age.text = curVideo.parsedKeys.age;
    survivorshipLength.text = curVideo.parsedKeys.survivorshipLength;
    treatment.text = curVideo.parsedKeys.treatment;
    maritalStatus.text = curVideo.parsedKeys.maritalStatus;
    employmentStatus.text = curVideo.parsedKeys.employmentStatus;
    childrenStatus.text = curVideo.parsedKeys.childrenStatus;
    
    videoTitle.text = curVideo.title;
}

- (void)viewDidLoad
{
    
    // Force the application into Landscape view
    UIApplication *application = [UIApplication sharedApplication];
    
    if ( UIInterfaceOrientationIsPortrait(application.statusBarOrientation) ) {
        application.statusBarOrientation = UIInterfaceOrientationLandscapeRight;
    }
    
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    // Enable GridView
    self.gridView.usesPagedHorizontalScrolling = YES;
    self.gridView.autoresizingMask = UIViewAutoresizingNone;
    self.gridView.autoresizesSubviews = YES;
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    
    // Remove the ability to scroll up and down in related videos
    [self.gridView setShowsVerticalScrollIndicator:NO];
    self.gridView.scrollsToTop = NO;
    self.gridView.bounces = NO;
    self.gridView.layoutDirection = AQGridViewLayoutDirectionHorizontal;
    
    self.gridView.contentInset = UIEdgeInsetsMake(-25 ,5 /* shifts left*/,0,0);
    
    // Enable the gridView and update it's content
    [_gridView reloadData];
    
    if ( curVideo ) {
        [self updateLabels];
        [self embedYouTube:curVideo.url frame:CGRectMake(79, 130, 451, 443)];
    }
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

#pragma mark -
#pragma mark Grid View Data Source

- (NSUInteger)numberOfItemsInGridView:(AQGridView *)aGridView
{
    return [_relatedVideos count]; // Don't include the one that is currently being displayed
//    return 0;
}

- (AQGridViewCell *)gridView:(AQGridView *)aGridView cellForItemAtIndex:(NSUInteger)index
{
    static NSString *VideoGridCellIdentifier = @"VideoGridCellIdentifier";
    
    Video *ytv = [_relatedVideos objectAtIndex:index];
    VideoGridCell *cell = (VideoGridCell *)[aGridView dequeueReusableCellWithIdentifier:VideoGridCellIdentifier];
    
    if ( cell == nil )
    {
        cell = [[[VideoGridCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 120.0, 160.0) reuseIdentifier:VideoGridCellIdentifier] autorelease];
        cell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
    }
    
    [cell.imageView setImageWithURL:ytv.thumbnailURL placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.title = ytv.title;
    
    return cell;
}

- (CGSize) portraitGridCellSizeForGridView:(AQGridView *)aGridView
{
    //   return CGSizeMake(220.0, 260.0);
    return CGSizeMake(120.0, 160.0);
}

#pragma mark -
#pragma mark Grid View Delegate

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{  
    Video *ytv = [_relatedVideos objectAtIndex:index];
    
    curVideo = ytv;
    [self updateLabels];
    
    [self embedYouTube:curVideo.url frame:CGRectMake(79, 130, 451, 443)];
    
}


@end
