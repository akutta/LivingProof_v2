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
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    self.gridView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"breast-cancer-ribbon.png"]];
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
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
        cell = [[[VideoGridCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 220.0, 235.0) reuseIdentifier:CategoryGridCellIdentifier] autorelease];
        cell.selectionStyle = AQGridViewCellSelectionStyleBlueGray;
    }
    
    if ( index >= [_categories count] ) {
        // New Category was added or we havn't stored this category yet
        [cell.imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    } else {
        Image *tmp = [_categories objectAtIndex:index];
        if ( tmp.imageData == nil ) {
            if ( tmp.imageView == nil )
                [cell.imageView setImage:[UIImage imageNamed:@"placeholder.png"]]; 
            else {
                cell.imageView = tmp.imageView;
            }
        } else {
            [cell.imageView setImage:tmp.imageData];
        }
        cell.title = tmp.name;
    }
    
    if ( [_categoryNames count] > 0 )
        cell.title = [_categoryNames objectAtIndex:index];
    
    return cell;
}

- (CGSize) portraitGridCellSizeForGridView:(AQGridView *)aGridView
{
    return CGSizeMake(220.0, 260.0);
}

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{
    VideoGridCell *cell = (VideoGridCell*)[gridView cellForItemAtIndex:index];
    VideoSelectionViewController *nextView = [[VideoSelectionViewController alloc] initWithNibName:@"VideoSelectionViewController" 
                                                                                            bundle:nil 
                                                                                          category:cell.title 
                                                                                            filter:nil
                                                                                        buttonText:@"Categories"];    // Change to Title of the selected
    
    //[[self delegate] switchView:self.view toView:nextView.view 
    // withAnimation:[[self delegate] getAnimation:NO] 
    // newController:nextView];
    [[self delegate] switchView:self.view 
                         toView:nextView.view 
                  withAnimation:UIViewAnimationTransitionFlipFromRight
                  newController:nextView];

    [[self delegate] reloadCurrentGrid];
}

//
// Event Handler
//
-(IBAction)back {
    
    MainScreenViewController *nextView = [[MainScreenViewController alloc] initWithNibName:@"MainScreenViewController" bundle:nil];
  //[[self delegate] switchView:self.view toView:nextView.view withAnimation:[[self delegate] getAnimation:YES] newController:nextView];
  [[self delegate] switchView:self.view 
                       toView:nextView.view 
                withAnimation:UIViewAnimationTransitionFlipFromLeft 
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
    NSLog(@"reloadCurrentGrid");
    if ( ([_gridView numberOfItems] != [_categories count] || [_categories count] == 0)
        && [[[self delegate] iYouTube] getFinished] == YES )
    {
        NSLog(@"Updating _categories");

        if ( _utilities == nil ) 
            _utilities = [Utilities alloc];
        
        [_categories release];
        _categories = [_utilities getArrayOfSurvivorsFromYoutube];
    }
    
    [_gridView reloadData];
}



@end
