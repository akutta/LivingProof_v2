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
#import "Image.h"
#import "Settings.h"
#import "Video.h"
#import "Utilities.h"
#import "Survivor.h"
#import "UIImageView+WebCache.h"

//#import "SurvivorNamesViewController.h"

@interface AgesViewController (Private)
- (LivingProofAppDelegate*)delegate;
@end

@implementation AgesViewController

@synthesize gridView = _gridView;

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
    self.view.frame = [[UIScreen mainScreen] applicationFrame];    
    
    self.gridView.backgroundColor = [UIColor clearColor];
    
    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"breast-cancer-ribbon.png"]];
    self.view.backgroundColor = [[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]] autorelease];
    
    [super viewDidLoad];
    
    // Enable GridView
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.gridView.autoresizesSubviews = YES;
	self.gridView.delegate = self;
	self.gridView.dataSource = self;
    
    _ages = [[[self delegate] settings] getAgeImages];    
    if ( [_ages count] == 0 ) 
        [self reloadCurrentGrid];
    else
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
    [self delegate].curOrientation = interfaceOrientation;
	return YES;
}

#pragma mark -
#pragma mark Grid Implementation

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
        [cell.imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    } else {
        Image *tmp = [_ages objectAtIndex:index];
        if ( tmp.imageData == nil ) {
            if ( tmp.imageView == nil ) {
                [cell.imageView setImage:[UIImage imageNamed:@"placeholder.png"]]; 
            } else
                cell.imageView = tmp.imageView;
        } else {
            [cell.imageView setImage:tmp.imageData];
        }
        cell.title = tmp.name;
    }
    
    if ( [_ageNames count] > 0 )
        cell.title = [_ageNames objectAtIndex:index];
    
    
    return cell;
}

- (CGSize) portraitGridCellSizeForGridView:(AQGridView *)aGridView
{
    return CGSizeMake(220.0, 260.0);
}

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{
    VideoGridCell *cell = [(VideoGridCell*)[gridView cellForItemAtIndex:index] autorelease];
    
    VideoSelectionViewController *nextView = [[VideoSelectionViewController alloc] initWithNibName:@"VideoSelectionViewController" 
                                                                                            bundle:nil 
                                                                                          category:cell.title 
                                                                                            filter:nil
                                                                                        buttonText:@"Ages"];    // Change to Title of the selected
    [[self delegate] switchView:self.view 
                         toView:nextView.view 
                  withAnimation:[[self delegate] getAnimation:NO] 
//                  withAnimation:UIViewAnimationTransitionFlipFromRight
                  newController:nextView];

    [[self delegate] reloadCurrentGrid];
}

#pragma mark -
#pragma mark Event Handlers

-(IBAction)back {
    
    MainScreenViewController *nextView = [[MainScreenViewController alloc] initWithNibName:@"MainScreenViewController" 
                                                                                     bundle:nil];
  [[self delegate] switchView:self.view 
                       toView:nextView.view 
   //                withAnimation:UIViewAnimationTransitionFlipFromLeft 
                withAnimation:[[self delegate] getAnimation:NO] 
                newController:nextView];
}

#pragma mark -
#pragma mark Public Functions

-(void)reloadCurrentGrid
{
    if ( ([_gridView numberOfItems] != [_ages count] || [_ages count] == 0)
        && [[[self delegate] iYouTube] getFinished] == YES ) {
        
        if ( _utilities == nil ) 
            _utilities = [Utilities alloc];
        
        [_ages release];
        _ages = [_utilities getArrayOfSurvivorsFromYoutube:YES];
        [[[self delegate] settings] saveCategoryImages:_ages];
    }
    
    [_gridView reloadData];
}

#pragma mark -
#pragma mark Private Function Definitions

-(LivingProofAppDelegate*)delegate {
    static LivingProofAppDelegate* del;
    if ( del == nil ) {
        del = (LivingProofAppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    
    return del;
}


@end
