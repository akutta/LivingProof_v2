//
//  VideoSelectionViewController.m
//  LivingProof
//
//  Created by Andrew Kutta on 6/16/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "LivingProofAppDelegate.h"
#import "CategoriesViewController.h"
#import "AgesViewController.h"
#import "VideoSelectionViewController.h"
#import "VideoPlayerViewController.h"
#import "VideoGridCell.h"
#import "Video.h"
#import "Utilities.h"

#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

@interface VideoSelectionViewController (Private)
- (LivingProofAppDelegate*)delegate;
- (NSArray*)YouTubeArray:(BOOL)shouldClear;
- (NSArray*)getFilteredArray;
- (void)filteredArray:(NSString*)searchText;
@end

@implementation VideoSelectionViewController

@synthesize navBar = navBar;
@synthesize gridView = _gridView;
@synthesize curCategory = _curCategory;

//
// Customized so we can keep track of the type of category we are filtering for
//
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil category:(NSString *)catText filter:(NSString *)filterText buttonText:(NSString*)title
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         NSLog(@"Selected Category:  %@",catText);
        
        //display.title = title;
        _curButtonText = [[NSString alloc] initWithString:title];
        _curCategory = [catText copy];
        [self YouTubeArray:YES];
        
        if ( filterText != nil || [filterText length] > 0 ) {
            [self filteredArray:filterText];
        }
        
        [self reloadCurrentGrid];
    }
    return self;
}


- (void)dealloc
{
    [_utilities release];
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
    //LivingProofAppDelegate *delegate = (LivingProofAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // Ensure we are in portrait mode
    //UIApplication *application = [UIApplication sharedApplication];
   // application.statusBarOrientation = UIInterfaceOrientationPortrait;
    
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    self.gridView.backgroundColor = [UIColor clearColor];
    self.navBar.tintColor = [UIColor colorWithRed:26.0/255.0 green:32.0/255.0 blue:133.0/255.0 alpha:1.0];
    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"breast-cancer-ribbon.png"]];
    self.view.backgroundColor = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]] autorelease];
    
    [super viewDidLoad];
    
    if ( _curButtonText )
        display.title = _curButtonText;
    
    // Enable GridView
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.gridView.autoresizesSubviews = YES;
	self.gridView.delegate = self;
	self.gridView.dataSource = self;
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

// Implementation of GridView

#pragma mark -
#pragma mark Grid View Data Source

- (NSUInteger)numberOfItemsInGridView:(AQGridView *)aGridView
{
    return [[self YouTubeArray:NO] count];
}

//
// Event Handler to goto Welcome Screen
//
-(IBAction)goHome:(id)sender
{
    LivingProofAppDelegate *delegate = (LivingProofAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate goHome:self.view];
}

- (AQGridViewCell *)gridView:(AQGridView *)aGridView cellForItemAtIndex:(NSUInteger)index
{
    static NSString *VideoGridCellIdentifier = @"VideoSelectionGridCellIdentifier";    
    Video *ytv = [[self getFilteredArray] objectAtIndex:index];
    VideoGridCell *cell = (VideoGridCell *)[aGridView dequeueReusableCellWithIdentifier:VideoGridCellIdentifier];
    
    if ( cell == nil )
    {
        cell = [[[VideoGridCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 240.0, 285.0) reuseIdentifier:VideoGridCellIdentifier] autorelease];
        cell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
    }
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImage *cachedImage = [manager imageWithURL:ytv.thumbnailURL];
    if ( cachedImage ) {
        [cell.imageView setImage:cachedImage];
    } else
        [cell.imageView setImageWithURL:ytv.thumbnailURL placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

    if ( [_curButtonText compare:@"Categories"] ) {
        cell.title = ytv.parsedKeys.name;
    } else {
        cell.title = ytv.title;
    }
    
    return cell;
}

- (CGSize) portraitGridCellSizeForGridView:(AQGridView *)aGridView
{
    return CGSizeMake(250.0, 305.0);
}

#pragma mark -
#pragma mark Grid View Delegate

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{   
    NSArray* videoArray = [self getFilteredArray];
    if ( [videoArray count] < index )
        return;
    
    Video *video = [videoArray objectAtIndex:index];
    
    // Kind of annoying how many special cases there are here
    if ( [_curButtonText compare:@"Categories"] ) {
        // Get rid of memory leak
        [videoArray release];
        // Update with newest version of the array
        NSArray* tmpArray = [[[self delegate] iYouTube] getYouTubeArray:video.parsedKeys.name];
        videoArray = [_utilities getNameVideoArray:tmpArray specificAge:video.parsedKeys.age];
//        videoArray = [[[self delegate] iYouTube] getYouTubeArray:video.parsedKeys.name];
    }
    
    VideoPlayerViewController *nextView = [[VideoPlayerViewController alloc] initWithNibName:@"VideoPlayerViewController" 
                                                                                      bundle:nil 
                                                                                       video:video 
                                                                                 curCategory:_curCategory 
                                                                                      filter:_searchText 
                                                                               relatedVideos:[videoArray copy]
                                                                                 buttonTitle:_curButtonText];
  //[[self delegate] switchView:self.view toView:nextView.view withAnimation:[[self delegate] getAnimation:NO] newController:nextView]; 
  [[self delegate] switchView:self.view 
                       toView:nextView.view 
                withAnimation:UIViewAnimationTransitionNone 
                newController:nextView];
}

#pragma mark -
#pragma mark search bar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filteredArray:searchText];
    [self reloadCurrentGrid];
}

#pragma mark -
#pragma mark as

-(void)reloadCurrentGrid
{
    [_gridView reloadData];
}

-(LivingProofAppDelegate*)delegate {
    static LivingProofAppDelegate* del;
    if ( del == nil ) {
        del = (LivingProofAppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    
    return del;
}

-(NSArray*)YouTubeArray:(BOOL)shouldClear
{   
    static NSArray* retArray;
    if ( retArray == nil || shouldClear == YES) {
        
        NSArray* tmpArray = [[[self delegate] iYouTube] getYouTubeArray:_curCategory];
        
        if ( [_curButtonText compare:@"Categories"] ) {
            if ( _utilities == nil ) {
                _utilities = [[Utilities alloc] init];
            }
            
            return [[[_utilities getNameVideoArray:tmpArray] copy] retain];
        } 
        
        retArray = [tmpArray copy];
        [tmpArray release];         // When you call this in the if block above, it will crash the application.  I don't know why exactly
        
        if ( [retArray count] == 0 )
            retArray = nil;
        else
            [retArray retain];
        
    }
    return retArray;
}

-(NSArray*)getFilteredArray {
    if ( _filteredResults != nil ) {
        return [_filteredResults copy];
    }
    
    return [self YouTubeArray:YES];
}

-(void)filteredArray:(NSString*)searchText {
    if ( _filteredResults != nil )
        [_filteredResults release];
    
    if ( searchText == nil || [searchText length] == 0 ) {
        _filteredResults = [[NSMutableArray alloc] initWithArray:[self YouTubeArray:NO]];
        return;
    }
    
    _filteredResults = [[NSMutableArray alloc] init];
    
    for ( Video* video in [self YouTubeArray:NO] ) {
        if ( ([video.category rangeOfString:searchText]).location == NSNotFound ) {
            for ( NSString* keyword in video.keysArray ) {
                
                NSRange range = [[keyword lowercaseString] rangeOfString:searchText]; 
                if ( range.location != NSNotFound ) {
                    [_filteredResults addObject:video];
                }
            }
        } else {
            [_filteredResults addObject:video];
        }
    }
    
    _searchText = [searchText copy];
}

//
// Event Handler
//
-(IBAction)swapViewToCategories:(id)sender
{
  UIViewAnimationTransition animation = [[self delegate] getAnimation:NO];
    
    if ( ![[sender title] compare:@"Categories"] ) {
        // Switch to Categories since that was the last view
        CategoriesViewController *nextView = [[CategoriesViewController alloc] initWithNibName:@"CategoriesViewController"
                                                                                         bundle:nil];
        
      //[[self delegate] switchView:self.view toView:nextView.view withAnimation:animation newController:nextView]; 
      [[self delegate] switchView:self.view 
                           toView:nextView.view 
                    withAnimation:animation
                    //withAnimation:UIViewAnimationTransitionFlipFromLeft 
                    newController:nextView];

        [[self delegate] reloadCurrentGrid];
    } else {
        AgesViewController *nextView = [[AgesViewController alloc] initWithNibName:@"AgesViewController"
                                                                             bundle:nil];
      //[[self delegate] switchView:self.view toView:nextView.view withAnimation:animation newController:nextView]; 
      [[self delegate] switchView:self.view 
                           toView:nextView.view 
                    withAnimation:animation
                   // withAnimation:UIViewAnimationTransitionFlipFromLeft 
                    newController:nextView];

        [[self delegate] reloadCurrentGrid];
    }
}
@end
