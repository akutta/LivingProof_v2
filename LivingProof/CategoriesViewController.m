//
//  CategoriesViewController.m
//  LivingProof
//
//  Created by Andrew Kutta on 6/16/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "CategoriesViewController.h"
#import "VideoSelectionViewController.h"
#import "MainScreenViewController.h"
#import "LivingProofAppDelegate.h"
#import "VideoGridCell.h"
#import "Image.h"
#import "Settings.h"
#import "Video.h"
#import "Survivor.h"
#import "Utilities.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"



@interface CategoriesViewController (Private)
- (LivingProofAppDelegate*)delegate;
- (IBAction)back;
- (void)reloadCurrentGrid;
@end

@implementation CategoriesViewController

@synthesize gridView = _gridView;
@synthesize navBar = navBar;

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
    /*([_gridView release];
    [super dealloc];*/
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


//
// Event Handler to goto Welcome Screen
//
-(IBAction)goHome:(id)sender
{
    LivingProofAppDelegate *delegate = (LivingProofAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate goHome:self.view];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    self.gridView.backgroundColor = [UIColor clearColor];
    self.navBar.tintColor = [UIColor colorWithRed:26.0/255.0 green:32.0/255.0 blue:133.0/255.0 alpha:1.0];
    //self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"breast-cancer-ribbon.png"]];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    
    [super viewDidLoad];
    
    // Enable GridView
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.gridView.autoresizesSubviews = YES;
	self.gridView.delegate = self;
	self.gridView.dataSource = self;
    
    _categories = [[[self delegate] settings] getCategoryImages];
    if ( [_categories count] == 0 ) 
        [self reloadCurrentGrid];
    else
        [_gridView reloadData];
}

- (void)viewDidUnload
{
    self.gridView = nil;
    [super viewDidUnload];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [UIView setAnimationsEnabled:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    [UIView setAnimationsEnabled:NO];
    [self delegate].curOrientation = interfaceOrientation;
	return YES;
}

#pragma mark -
#pragma mark Grid View Delegate

- (NSUInteger)numberOfItemsInGridView:(AQGridView *)aGridView
{
    // When a new category is added check that we have an image for it
    if ( [[[self delegate] iYouTube] getFinished] == NO )
        return [_categories count];
    
    _categoryNames = [[[[self delegate] iYouTube] getCategories] copy];
    return [_categoryNames count];
}

- (AQGridViewCell *)gridView:(AQGridView *)aGridView cellForItemAtIndex:(NSUInteger)index
{   
    static NSString *CategoryGridCellIdentifier = @"CategoryGridCellIdentifier";
    
    VideoGridCell *cell = (VideoGridCell *)[aGridView dequeueReusableCellWithIdentifier:CategoryGridCellIdentifier];
    
    if ( cell == nil )
    {
        //cell = [[[VideoGridCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 240.0, 285.0) reuseIdentifier:CategoryGridCellIdentifier] autorelease];
        cell = [[VideoGridCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 240.0, 285.0) reuseIdentifier:CategoryGridCellIdentifier];
        cell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
    }
    
    if ( index >= [_categories count] ) {
        // New Category was added or we havn't stored this category yet
        NSLog(@"New Category Created");
        [cell.imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    } else {
        Image *tmp = [_categories objectAtIndex:index];
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        UIImage *cachedImage = [manager imageWithURL:tmp.thumbnailURL];
        
        if ( cachedImage ) {
            [cell.imageView setImage:cachedImage];
        } else
            [cell.imageView setImageWithURL:tmp.thumbnailURL placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        cell.title = tmp.name;
    }
    
    if ( [_categoryNames count] > 0 )
        cell.title = [_categoryNames objectAtIndex:index];
    
    return cell;
}

- (CGSize) portraitGridCellSizeForGridView:(AQGridView *)aGridView
{
    return CGSizeMake(250.0, 305.0);
}

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{
    //VideoGridCell *cell = [(VideoGridCell*)[gridView cellForItemAtIndex:index] autorelease];
    VideoGridCell *cell = (VideoGridCell*)[gridView cellForItemAtIndex:index];
    VideoSelectionViewController *nextView = [[VideoSelectionViewController alloc] initWithNibName:@"VideoSelectionViewController" 
                                                                                            bundle:nil 
                                                                                          category:cell.title 
                                                                                            filter:nil
                                                                                        buttonText:@"Categories"];    
    
    // Change to Title of the selected
    
    //[[self delegate] switchView:self.view toView:nextView.view 
    // withAnimation:[[self delegate] getAnimation:NO] 
    // newController:nextView];
    [[self delegate] switchView:self.view 
                         toView:nextView.view 
                        withAnimation:[[self delegate] getAnimation:NO] 
                  //withAnimation:UIViewAnimationTransitionFlipFromRight
                  newController:nextView];

    //[[self delegate] reloadCurrentGrid];
}

//
// Event Handler
//
-(IBAction)back {
    MainScreenViewController *nextView = [[MainScreenViewController alloc] initWithNibName:@"MainScreenViewController" 
                                                                                     bundle:nil];
    [[self delegate] switchView:self.view 
                         toView:nextView.view 
                  withAnimation:[[self delegate] getAnimation:NO] 
                //withAnimation:UIViewAnimationTransitionFlipFromLeft 
                newController:nextView];
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

-(void)reloadCurrentGrid
{
    //NSLog(@"reloadCurrentGrid");
    if ( ([_gridView numberOfItems] != [_categories count] || [_categories count] == 0)
        && [[[self delegate] iYouTube] getFinished] == YES )
    {
        //NSLog(@"Updating _categories");

        if ( _utilities == nil ) 
            _utilities = [Utilities alloc];
        
        //[_categories release];
        _categories = [_utilities getArrayOfSurvivorsFromYoutube:YES];
        [[[self delegate] settings] saveCategoryImages:_categories];
    }
    
    [_gridView reloadData];
}



@end
