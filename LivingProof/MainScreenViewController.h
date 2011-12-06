//
//  MainScreenViewController.h
//  LivingProof
//
//  Created by Andrew Kutta on 7/11/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainScreenViewController : UIViewController {
    IBOutlet UIButton *sortAge;
    IBOutlet UIButton *sortCategory;
  
  IBOutlet UILabel *loadingLabel;
  IBOutlet UIActivityIndicatorView *activityView;
 
    UIColor *landscapeBackgroundImage;
    UIColor *portraitBackgroundImage;
    UIColor *lightPink;
    UIColor *strongPink;
    
}
-(IBAction)sortByCategories;
-(IBAction)sortByAge;

@end
