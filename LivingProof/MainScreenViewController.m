//
//  MainScreenViewController.m
//  LivingProof
//
//  Created by Andrew Kutta on 7/11/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "MainScreenViewController.h"
#import "CategoriesViewController.h"
#import "AgesViewController.h"
#import "LivingProofAppDelegate.h"

@implementation MainScreenViewController


-(LivingProofAppDelegate*)delegate {
    static LivingProofAppDelegate* del;
    if ( del == nil ) {
        del = (LivingProofAppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    
    return del;
}


-(IBAction)sortByCategories
{
    CategoriesViewController *nextView = [[CategoriesViewController alloc] initWithNibName:@"CategoriesViewController" bundle:nil];
    [[self delegate] switchView:self.view toView:nextView.view withAnimation:UIViewAnimationTransitionFlipFromRight newController:nextView]; 
}


-(IBAction)sortByAge
{
    AgesViewController *nextView = [[AgesViewController alloc] initWithNibName:@"AgesViewController" bundle:nil];
    [[self delegate] switchView:self.view toView:nextView.view withAnimation:UIViewAnimationTransitionFlipFromRight newController:nextView]; 
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       // self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"WelcomeScreen.png"]];
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

- (void)displayPortrait {
    CGRect sortAgeFrame = sortAge.frame;
    sortAgeFrame.origin = CGPointMake(199.0f, 807.0f);
    sortAge.frame = sortAgeFrame;
    
    
    CGRect sortCategoryFrame = sortCategory.frame;
    sortCategoryFrame.origin = CGPointMake(388.0f, 807.0f);
    sortCategory.frame = sortCategoryFrame;
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"WelcomeScreen.png"]];
}

- (void)displayLandscape {
    CGRect sortAgeFrame = sortAge.frame;
    sortAgeFrame.origin = CGPointMake(327.0f, 573.0f);
    sortAge.frame = sortAgeFrame;
    
    
    CGRect sortCategoryFrame = sortCategory.frame;
    sortCategoryFrame.origin = CGPointMake(516.0f, 573.0f);
    sortCategory.frame = sortCategoryFrame;
    
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"WelcomeScreenRotated.png"]];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration 
{
    if ( toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ) {
        [self displayPortrait];
    } else if ( toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight ) {
        [self displayLandscape];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self displayPortrait];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"WelcomeScreen.png"]];
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

@end
