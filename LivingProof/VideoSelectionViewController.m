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

#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

@implementation VideoSelectionViewController

@synthesize gridView = _gridView;
@synthesize curCategory = _curCategory;


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
        retArray = [[[self delegate] iYouTube] getYouTubeArray:_curCategory];
        
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


-(IBAction)swapViewToCategories:(id)sender
{
    if ( ![[sender title] compare:@"Categories"] ) {
        // Switch to Categories since that was the last view
        CategoriesViewController *nextView = [[CategoriesViewController alloc] initWithNibName:@"CategoriesViewController" bundle:nil];
        [[self delegate] switchView:self.view toView:nextView.view withAnimation:UIViewAnimationTransitionFlipFromLeft newController:nextView]; 
        [[self delegate] reloadCurrentGrid];
    } else {
        AgesViewController *nextView = [[AgesViewController alloc] initWithNibName:@"AgesViewController" bundle:nil];
        [[self delegate] switchView:self.view toView:nextView.view withAnimation:UIViewAnimationTransitionFlipFromLeft newController:nextView]; 
        [[self delegate] reloadCurrentGrid];
    }
}

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
        [self reloadCurrentGrid];
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
    //LivingProofAppDelegate *delegate = (LivingProofAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // Ensure we are in portrait mode
    //UIApplication *application = [UIApplication sharedApplication];
   // application.statusBarOrientation = UIInterfaceOrientationPortrait;
    
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    
    [super viewDidLoad];
    
 //   NSLog(@"curButtonText: %@",_curButtonText);
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
	return YES;
}

// Implementation of GridView

#pragma mark -
#pragma mark Grid View Data Source

- (NSUInteger)numberOfItemsInGridView:(AQGridView *)aGridView
{
    return [[self YouTubeArray:NO] count];
}

- (AQGridViewCell *)gridView:(AQGridView *)aGridView cellForItemAtIndex:(NSUInteger)index
{
    static NSString *VideoGridCellIdentifier = @"VideoGridCellIdentifier";    
    Video *ytv = [[self getFilteredArray] objectAtIndex:index];
    VideoGridCell *cell = (VideoGridCell *)[aGridView dequeueReusableCellWithIdentifier:VideoGridCellIdentifier];
    
    if ( cell == nil )
    {
        cell = [[[VideoGridCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 220.0, 235.0) reuseIdentifier:VideoGridCellIdentifier] autorelease];
        cell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
    }
    
//    [cell.imageView setImageWithURL:ytv.thumbnailURL placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImage *cachedImage = [manager imageWithURL:ytv.thumbnailURL];
    if ( cachedImage ) {
        [cell.imageView setImage:cachedImage];
    } else
        [cell.imageView setImageWithURL:ytv.thumbnailURL placeholderImage:nil];
    
    
    cell.title = ytv.title;
    
    return cell;
}

- (CGSize) portraitGridCellSizeForGridView:(AQGridView *)aGridView
{
 //   return CGSizeMake(220.0, 260.0);
    return CGSizeMake(150.0, 200.0);
}

#pragma mark -
#pragma mark Grid View Delegate

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{   
    NSArray* videoArray = [self getFilteredArray];
    if ( [videoArray count] < index )
        return;
    
    Video *video = [videoArray objectAtIndex:index];
    VideoPlayerViewController *nextView = [[VideoPlayerViewController alloc] initWithNibName:@"VideoPlayerViewController" 
                                                                                      bundle:nil 
                                                                                       video:video 
                                                                                 curCategory:_curCategory 
                                                                                      filter:_searchText 
                                                                               relatedVideos:videoArray
                                                                                 buttonTitle:_curButtonText];
    [[self delegate] switchView:self.view toView:nextView.view withAnimation:UIViewAnimationTransitionNone newController:nextView]; 
}

#pragma mark -
#pragma mark search bar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filteredArray:searchText];
    [self reloadCurrentGrid];
}

@end
