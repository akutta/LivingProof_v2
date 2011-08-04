//
//  AgesViewController.m
//  LivingProof
//
//  Created by Andrew Kutta on 7/12/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "AgesViewController.h"
#import "VideoSelectionViewController.h"
#import "MainScreenViewController.h"
#import "LivingProofAppDelegate.h"
#import "VideoGridCell.h"
#import "AgeImage.h"
#import "Settings.h"
#import "Video.h"
#import "Survivor.h"
#import "UIImageView+WebCache.h"


@implementation AgesViewController

@synthesize gridView = _gridView;

-(LivingProofAppDelegate*)delegate {
    static LivingProofAppDelegate* del;
    if ( del == nil ) {
        del = (LivingProofAppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    
    return del;
}

-(IBAction)back {
    
    MainScreenViewController *nextView = [[MainScreenViewController alloc] initWithNibName:@"MainScreenViewController" bundle:nil];
    [[self delegate] switchView:self.view toView:nextView.view withAnimation:UIViewAnimationTransitionFlipFromLeft newController:nextView];
}

-(void)reloadCurrentGrid
{
    if ( [_gridView numberOfItems] != [_ages count] || bUsedPlaceholder )
    {
        // Find new images
        NSInteger errorCount = 0;
        NSArray* videos = [[[self delegate] iYouTube] getYouTubeArray:nil];
        NSMutableArray* survivors = [[NSMutableArray alloc] init];
        for ( Video* curVideo in videos )
        {
            if ( !curVideo.parsedKeys.age ) {
                curVideo.parsedKeys.age = @"";
                errorCount++;
            }
            BOOL bFound = NO;
            for ( Survivor* survivor in survivors )
            {
                if ( ![survivor.name compare:curVideo.parsedKeys.age] ) {
                    bFound = YES;
                }
            }
            
            if ( !bFound ) {
                Survivor *tmp = [[Survivor alloc] init];
                tmp.name = curVideo.parsedKeys.age;
                tmp.url = curVideo.thumbnailURL;
                [survivors addObject:tmp];
                //[tmp release];
            }
            bUsedPlaceholder = NO;
        }
        
        [_ages release];
        NSMutableArray* _ageImages = [[NSMutableArray alloc] init];
        
        _ageNames = [[[[self delegate] iYouTube] getAges] copy];
        NSInteger index = 0;
        for ( NSString* name in _ageNames ) {
            AgeImage *tmp = [[AgeImage alloc] init];
            tmp.imageData = nil;
            tmp.imageView = nil;
            for ( index = 0; index < [survivors count]; index ++ ) {
                Survivor *surv = [survivors objectAtIndex:index];
                
                if ( ![surv.name compare:name] ) {
//                    NSLog(@"Using %@ for %@",surv.url, surv.name);
                    tmp.imageData = [UIImage imageWithData: [NSData dataWithContentsOfURL:surv.url]];
                }   
            }
            tmp.ageName = name;
            [_ageImages addObject:tmp];
            index++;
        }
        _ages = [_ageImages copy];
        
        [[[self delegate] settings] saveAgeImages:_ageImages];
        
        NSLog(@"There are %d uncategorized ages", errorCount);
    }
    
    [_gridView reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_gridView release];
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
    // Ensure we are in portrait mode
    //UIApplication *application = [UIApplication sharedApplication];
    //application.statusBarOrientation = UIInterfaceOrientationPortrait;
    
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    
    [super viewDidLoad];
    _ages = [[[self delegate] settings] getAgeImages];
    if ( [_ages count] == 0 ) {
        NSLog(@"No Local Ages Found");
        bUsedPlaceholder = YES;
        [_ages release];
    }
    
    // Enable GridView
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.gridView.autoresizesSubviews = YES;
	self.gridView.delegate = self;
	self.gridView.dataSource = self;
    
    [_gridView reloadData];
}

- (void)viewDidUnload
{
    self.gridView = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (NSUInteger)numberOfItemsInGridView:(AQGridView *)aGridView
{
    // When a new category is added check that we have an image for it
    if ( [[[self delegate] iYouTube] getFinished] == NO )
        return [_ages count];
    
    _ageNames = [[[[self delegate] iYouTube] getAges] copy];
    return [_ageNames count];
}

- (AQGridViewCell *)gridView:(AQGridView *)aGridView cellForItemAtIndex:(NSUInteger)index
{   
    static NSString *AgeGridCellIdentifier = @"AgeGridCellIdentifier";
    
    VideoGridCell *cell = (VideoGridCell *)[aGridView dequeueReusableCellWithIdentifier:AgeGridCellIdentifier];
    
    if ( cell == nil )
    {
        cell = [[[VideoGridCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 220.0, 235.0) reuseIdentifier:AgeGridCellIdentifier] autorelease];
        cell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
    }
    
    if ( index >= [_ages count]  ) {
        bUsedPlaceholder = YES;
        [cell.imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    } else {
        AgeImage *tmp = [_ages objectAtIndex:index];
        if ( tmp.imageData == nil ) {
            if ( tmp.imageView == nil ) {
                [cell.imageView setImage:[UIImage imageNamed:@"placeholder.png"]]; 
                bUsedPlaceholder = YES;
            } else
                cell.imageView = tmp.imageView;
        } else {
            [cell.imageView setImage:tmp.imageData];
        }
        cell.title = tmp.ageName;
    }
    
    if ( [_ageNames count] > 0 )
        cell.title = [_ageNames objectAtIndex:index];
    
    
    return cell;
}

- (CGSize) portraitGridCellSizeForGridView:(AQGridView *)aGridView
{
    return CGSizeMake(220.0, 260.0);
}

#pragma mark -
#pragma mark Grid View Delegate

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{
    
    VideoGridCell *cell = (VideoGridCell*)[gridView cellForItemAtIndex:index];
    VideoSelectionViewController *nextView = [[VideoSelectionViewController alloc] initWithNibName:@"VideoSelectionViewController" 
                                                                                            bundle:nil 
                                                                                          category:cell.title 
                                                                                            filter:nil
                                                                                        buttonText:@"Ages"];    // Change to Title of the selected
    [[self delegate] switchView:self.view toView:nextView.view withAnimation:UIViewAnimationTransitionFlipFromRight newController:nextView];
    [[self delegate] reloadCurrentGrid];
}

@end
