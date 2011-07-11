//
//  CategoriesViewController.h
//  LivingProof
//
//  Created by Andrew Kutta on 6/16/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@interface CategoriesViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource>  {
    NSArray *_imageNames;
    NSArray *_categoryNames;
    
    NSArray *_categories;
    //NSMutableArray *_categoryImages; // NSArray* of CategoryImage*
    
    AQGridView *_gridView;
}

@property (nonatomic, retain) IBOutlet AQGridView *gridView;

-(void)reloadCurrentGrid;
@end
