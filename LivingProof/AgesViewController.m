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
#import "CategoryImage.h"
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
    UIApplication *application = [UIApplication sharedApplication];
    application.statusBarOrientation = UIInterfaceOrientationPortrait;
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // NSLog(@"viewDidLoad - getting categories");
  
    
    // Convert to using ages
//    _ages = [[[self delegate] settings] getCategoryImages];
//    if ( [_ages count] == 0 ) {
//        NSLog(@"No Local Categories Found");
//        [_ages release];
//    }
    
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
    
    // CONVERT HERE
    //_ageNames = [[[[self delegate] iYouTube] getCategories] copy];
    return [_ageNames count];
}

- (AQGridViewCell *)gridView:(AQGridView *)aGridView cellForItemAtIndex:(NSUInteger)index
{   
    static NSString *CategoryGridCellIdentifier = @"CategoryGridCellIdentifier";
    
    VideoGridCell *cell = (VideoGridCell *)[aGridView dequeueReusableCellWithIdentifier:CategoryGridCellIdentifier];
    
//    if ( cell == nil )
//    {
//        cell = [[[VideoGridCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 220.0, 235.0) reuseIdentifier:CategoryGridCellIdentifier] autorelease];
//        cell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
//    }
//    
//    if ( index >= [_ages count] )
//        [cell.imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
//    else {
//        CategoryImage *tmp = [_ages objectAtIndex:index];
//        if ( tmp.imageData == nil ) {
//            if ( tmp.imageView == nil )
//                [cell.imageView setImage:[UIImage imageNamed:@"placeholder.png"]]; 
//            else
//                cell.imageView = tmp.imageView;
//        } else {
//            [cell.imageView setImage:tmp.imageData];
//        }
//        cell.title = tmp.categoryName;
//    }
//    
//    if ( [_ageNames count] > 0 )
//        cell.title = [_ageNames objectAtIndex:index];
    
    cell.imageView = nil;
    cell.title = @"Unfinished";
    
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
                                                                                        buttonText:@"Ages"];    // Change to Title of the selected
    [[self delegate] switchView:self.view toView:nextView.view withAnimation:UIViewAnimationTransitionFlipFromRight newController:nextView];
    [[self delegate] reloadCurrentGrid];
}

@end
