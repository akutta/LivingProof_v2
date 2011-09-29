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
//#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

#import "FlurryAnalytics.h"

@interface VideoPlayerViewController (Private)
- (LivingProofAppDelegate*)delegate;
- (UIButton *)findButtonInView:(UIView *)view;
- (void)rotateYouTube:(CGRect)frame;
- (void)embedYouTube:(NSURL*)url frame:(CGRect)frame;
@end

@implementation VideoPlayerViewController

@synthesize gridView = _gridView;
@synthesize notificationView;

- (id)initWithNibName:(NSString *)nibNameOrNil 
               bundle:(NSBundle *)nibBundleOrNil 
                video:(Video *)video
          curCategory:(NSString*)curCategory 
               filter:(NSString*)_searchText 
        relatedVideos:(NSArray*)relatedVideos
          buttonTitle:(NSString*)curTitle
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
      previousButtonTitle = [[NSString alloc] initWithString:curTitle];

      _curCategory = curCategory;
      _curFilter = _searchText;
      _relatedVideos =  [[relatedVideos copy] retain];
    
      // hide popup on startup
      self.notificationView.alpha = 0.0;

      // Custom initialization
      curVideo = video;
      [curVideo retain];

      [self updateLabels];

      // log current video
      NSDictionary* video_dict = [NSDictionary dictionaryWithObjectsAndKeys:video.title, @"title", video.url, @"url", nil];
      [FlurryAnalytics logEvent:@"Video" withParameters:video_dict];

      // log current view
      [FlurryAnalytics logPageView];
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

//
// Event Handler
//
-(IBAction)swapViews:(id)sender
{
    // Used to stop video playing when back button is pushed.
    [self embedYouTube:nil frame:CGRectMake(0,0,0,0)];
    
    LivingProofAppDelegate *delegate = (LivingProofAppDelegate*)[[UIApplication sharedApplication] delegate];
    VideoSelectionViewController *nextView = [[VideoSelectionViewController alloc] initWithNibName:@"VideoSelectionViewController" 
                                                                                            bundle:nil category:_curCategory 
                                                                                            filter:_curFilter 
                                                                                        buttonText:previousButtonTitle];
    [delegate switchView:self.view toView:nextView.view withAnimation:[[self delegate] getAnimation:YES] newController:nextView]; 
    [delegate reloadCurrentGrid];
}

#pragma mark -
#pragma mark - Definition Popup

- (void)showDefinition:(UITapGestureRecognizer*)recognizer
{
  CGFloat verticalLocation = CGRectGetMinY(treatment.frame) - notificationView.frame.size.height - 2.0;
  notificationView.frame = CGRectMake(CGRectGetMinX(treatment.frame), verticalLocation, 
                                      notificationView.frame.size.width, notificationView.frame.size.height);

  if (!notificationView.superview)
    [self.view addSubview:notificationView];

  notificationView.alpha = 0.0;

  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.5];
  notificationView.alpha = 1.0;
  [UIView commitAnimations];
}

- (void)hideNotificationView:(id)sender
{
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.5];
  notificationView.alpha = 0.0;
  [UIView commitAnimations];
}

#pragma mark - View lifecycle

- (void)updateLabels
{
    name.text = curVideo.parsedKeys.name;
    age.text = curVideo.parsedKeys.age;
    survivorshipLength.text = curVideo.parsedKeys.survivorshipLength;
    treatment.text = curVideo.parsedKeys.treatment;
    maritalStatus.text = curVideo.parsedKeys.maritalStatus;
    employmentStatus.text = curVideo.parsedKeys.employmentStatus;
    childrenStatus.text = curVideo.parsedKeys.childrenStatus;
    
    videoTitle.text = curVideo.title;
}

-(void) setTextPositions:(CGFloat)x y:(CGFloat)y{
    CGRect frame = name.frame;
    
    // name
    frame.origin = CGPointMake(x,y);
    name.frame = frame;
    nameLabel.frame = CGRectMake(frame.origin.x - 95, frame.origin.y, nameLabel.frame.size.width, nameLabel.frame.size.height); // -95
    
    // age
    frame.origin = CGPointMake(frame.origin.x, frame.origin.y + 30);
    age.frame = frame;
    ageLabel.frame = CGRectMake(frame.origin.x - 82, frame.origin.y, ageLabel.frame.size.width, ageLabel.frame.size.height);    // -82
    
    // treatment
    frame.origin = CGPointMake(frame.origin.x, frame.origin.y + 30);
    treatment.frame = frame;
    treatmentLabel.frame = CGRectMake(frame.origin.x - 127, frame.origin.y, treatmentLabel.frame.size.width, treatmentLabel.frame.size.height); // -127
    
    // etc...
    frame.origin = CGPointMake(frame.origin.x, frame.origin.y + 30);
    maritalStatus.frame = frame;
    maritalStatusLabel.frame = CGRectMake(frame.origin.x - 154, frame.origin.y, maritalStatusLabel.frame.size.width, maritalStatusLabel.frame.size.height); // -154
    
    frame.origin = CGPointMake(frame.origin.x, frame.origin.y + 30);
    childrenStatus.frame = frame;
    childrenLabel.frame = CGRectMake(frame.origin.x - 112, frame.origin.y, childrenLabel.frame.size.width, childrenLabel.frame.size.height); // -112
    
    frame.origin = CGPointMake(frame.origin.x, frame.origin.y + 30);
    employmentStatus.frame = frame;
    employentLabel.frame = CGRectMake(frame.origin.x - 197, frame.origin.y, employentLabel.frame.size.width, employentLabel.frame.size.height); // -197
    
    frame.origin = CGPointMake(frame.origin.x, frame.origin.y + 30);
    survivorshipLength.frame = frame;
    survivorshipLabel.frame = CGRectMake(frame.origin.x - 222, frame.origin.y, survivorshipLabel.frame.size.width, survivorshipLabel.frame.size.height); // -222
    
}

-(void) updateYoutubeVideo:(UIInterfaceOrientation)orientation {
    if ( UIInterfaceOrientationIsPortrait(orientation) ) {
        [self embedYouTube:curVideo.url frame:CGRectMake(106, 199, 556, 364)];
    } else {
        [self embedYouTube:curVideo.url frame:CGRectMake(63, 198, 451, 351)];            
    }
}



-(void) updateYoutubePosition:(UIInterfaceOrientation)orientation {
    if ( videoView == nil ) {
        [self updateYoutubeVideo:orientation];
        return;
    }
    
    if ( UIInterfaceOrientationIsPortrait(orientation) )
        [self rotateYouTube:CGRectMake(106,199,556,364)];
        //[self embedYouTube:curVideo.url frame:CGRectMake(106, 199, 556, 364)];
    else  {
        [self rotateYouTube:CGRectMake(63, 198, 451, 351)];
        //[self embedYouTube:curVideo.url frame:CGRectMake(63, 198, 451, 351)]; 
    }
}

-(void) updateLayout:(UIInterfaceOrientation)orientation {
    if ( UIInterfaceOrientationIsPortrait(orientation) ) {
        
        CGRect frame = videoTitle.frame;
        frame.origin = CGPointMake(243, frame.origin.y);
        videoTitle.frame = frame;
        
        [self setTextPositions:408 y:613];
        
        // setup new frame
        _gridView.frame = CGRectMake(76,835,617,149);
    } else {
        CGRect frame = videoTitle.frame;
        frame.origin = CGPointMake(371, frame.origin.y);
        videoTitle.frame = frame;
        
        [self setTextPositions:759 y:236];
        
        // setup gridview
        _gridView.frame = CGRectMake(204, 590, 617, 149);
    }
    //[self updateYoutubeVideo:orientation];
    // just changes the position of the video.  allows to continue playing the video \
    // with updateYoutubeVideo it replaces the video when you change views starting the video over.
    [self updateYoutubePosition:orientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration  {
    [self updateLayout:toInterfaceOrientation];
}

- (void)viewDidLoad
{
    
    // Force the application into Landscape view    
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // add popup "button" to the treatment label
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(showDefinition:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [treatment addGestureRecognizer:tapGestureRecognizer];
    treatment.userInteractionEnabled = YES;
    [tapGestureRecognizer release];

    // Enable GridView
    self.gridView.autoresizingMask = UIViewAutoresizingNone;
    self.gridView.autoresizesSubviews = YES;
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    
    // Remove the ability to scroll up and down in related videos
    // Use horizontal scrolling
    self.gridView.usesPagedHorizontalScrolling = YES;
    [self.gridView setShowsVerticalScrollIndicator:NO];
    self.gridView.scrollsToTop = NO;
    self.gridView.bounces = NO;
    self.gridView.layoutDirection = AQGridViewLayoutDirectionHorizontal;
    
    self.gridView.contentInset = UIEdgeInsetsMake(-25 ,5 /* shifts left*/,0,0);
    
    // Enable the gridView and update it's content
    [_gridView reloadData];
    
    if ( curVideo ) {
        [self updateLabels];
        UIApplication *application = [UIApplication sharedApplication];
        [self updateLayout:application.statusBarOrientation];
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
    [self delegate].curOrientation = interfaceOrientation;
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
    
    /*
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImage *cachedImage = [manager imageWithURL:ytv.thumbnailURL];
    if ( cachedImage ) {
        [cell.imageView setImage:cachedImage];
    } else*/
    
    //[cell.imageView setImageWithURL:ytv.thumbnailURL placeholderImage:nil];
    [cell.imageView setImageWithURL:ytv.thumbnailURL placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

    cell.title = ytv.title;
    
    return cell;
}

- (CGSize) portraitGridCellSizeForGridView:(AQGridView *)aGridView
{
    return CGSizeMake(120.0, 160.0);
}

#pragma mark -
#pragma mark Grid View Delegate

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{  
    Video *ytv = [_relatedVideos objectAtIndex:index];
  
    // log new video
    NSDictionary* video_dict = [NSDictionary dictionaryWithObjectsAndKeys:ytv.title, @"title", ytv.url, @"url", nil];
    [FlurryAnalytics logEvent:@"Video" withParameters:video_dict];

    curVideo = ytv;
    [self updateLabels];
    
    UIApplication *application = [UIApplication sharedApplication];
    
    // Call this since we are replacing what video is being displayed
    [self updateYoutubeVideo:application.statusBarOrientation];
}


-(LivingProofAppDelegate*)delegate {
    static LivingProofAppDelegate* del;
    if ( del == nil ) {
        del = (LivingProofAppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    
    return del;
}

-(void)reloadCurrentGrid
{
    [_gridView reloadData];
}

- (UIButton *)findButtonInView:(UIView *)view {
	UIButton *button = nil;
	
	if ([view isMemberOfClass:[UIButton class]]) {
		return (UIButton *)view;
	}
	
	if (view.subviews && [view.subviews count] > 0) {
		for (UIView *subview in view.subviews) {
			button = [self findButtonInView:subview];
			if (button) return button;
		}
	}
	
	return button;
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView {
	UIButton *b = [self findButtonInView:_webView];
	[b sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)rotateYouTube:(CGRect)frame {
    videoView.frame = frame;
}

- (void)embedYouTube:(NSURL*)url frame:(CGRect)frame {
    NSString* embedHTML = @""
    "<html><head>"
    "<style type=\"text/css\">"
    "body {" 
    "background-color: transparent;"
    "color: white;"
    "}" 
    "</style>"
    "</head><body style=\"margin:0\">" 
    "</param><embed src=\"%@&autoplay=1\" type=\"application/x-shockwave-flash\" width=\"%0.0f\" height=\"%0.0f\"></embed></object>"
    "</body></html>"; 
    NSString* html = [NSString stringWithFormat:embedHTML, url, frame.size.width, frame.size.height];
    
    if(videoView == nil) {
        videoView = [[UIWebView alloc] initWithFrame:frame];
        videoView.mediaPlaybackRequiresUserAction = NO;
        [self.view addSubview:videoView];
    }
    
    videoView.frame = frame;
    [videoView loadHTMLString:html baseURL:nil];
}



@end
