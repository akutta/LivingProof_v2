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
#import "CategoryImage.h"
#import "Settings.h"
#import "Video.h"
#import "Survivor.h"
#import "UIImageView+WebCache.h"

@implementation CategoriesViewController

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
    if ( [_gridView numberOfItems] != [_categories count] )
    {
        // Find new images
        NSArray* videos = [[[self delegate] iYouTube] getYouTubeArray:nil];
        NSMutableArray* survivors = [[NSMutableArray alloc] init];
        for ( Video* curVideo in videos )
        {
            BOOL bFound = NO;
            for ( Survivor* survivor in survivors )
            {
                if ( ![survivor.name compare:curVideo.parsedKeys.name] ) {
                    bFound = YES;
                }
            }
            
            if ( !bFound ) {
                Survivor *tmp = [[Survivor alloc] init];
                tmp.name = curVideo.parsedKeys.name;
                tmp.url = curVideo.thumbnailURL;
                [survivors addObject:tmp];
                //[tmp release];
            }
        }
        
        [_categories release];
        NSMutableArray* _categoryImages = [[NSMutableArray alloc] init];
        
        _categoryNames = [[[[self delegate] iYouTube] getCategories] copy];
        NSInteger index = 0;
        for ( NSString* name in _categoryNames ) {
            CategoryImage *tmp = [[CategoryImage alloc] init];
            if ( index >= [survivors count] ) {
                tmp.imageData = nil;
                tmp.imageView = nil;
            } else {
                Survivor *surv = [survivors objectAtIndex:index];
                tmp.imageData = nil;
                tmp.imageData = [UIImage imageWithData: [NSData dataWithContentsOfURL:surv.url]];
            }
            tmp.categoryName = name;
            [_categoryImages addObject:tmp];
            index++;
        }
        _categories = [_categoryImages copy];
        
        [[[self delegate] settings] saveCategoryImages:_categoryImages];
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
    _categories = [[[self delegate] settings] getCategoryImages];
    if ( [_categories count] == 0 ) {
        NSLog(@"No Local Categories Found");
        [_categories release];
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
    
    if ( index >= [_categories count] )
        [cell.imageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    else {
        CategoryImage *tmp = [_categories objectAtIndex:index];
        if ( tmp.imageData == nil ) {
            if ( tmp.imageView == nil )
                [cell.imageView setImage:[UIImage imageNamed:@"placeholder.png"]]; 
            else
                cell.imageView = tmp.imageView;
        } else {
            [cell.imageView setImage:tmp.imageData];
        }
        cell.title = tmp.categoryName;
    }
    
    if ( [_categoryNames count] > 0 )
        cell.title = [_categoryNames objectAtIndex:index];
    
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
                                                                                        buttonText:@"Categories"];    // Change to Title of the selected
    [[self delegate] switchView:self.view toView:nextView.view withAnimation:UIViewAnimationTransitionFlipFromRight newController:nextView];
    [[self delegate] reloadCurrentGrid];
}



@end
