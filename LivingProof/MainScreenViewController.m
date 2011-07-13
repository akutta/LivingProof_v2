//
//  MainScreenViewController.m
//  LivingProof
//
//  Created by Andrew Kutta on 7/11/11.
//  Copyright 2011 Student. All rights reserved.
//

#import "MainScreenViewController.h"
#import "CategoriesViewController.h"
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
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[self viewBackground];
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"WelcomeScreen.png"]];
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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
   // NSLog(@"%@",self.view.window.bounds);
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
