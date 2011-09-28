//
//  CategoryListViewController.h
//  LivingProof
//
//  Created by Mark Sands on 9/19/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryListViewController : UITableViewController
{
  NSDictionary *_vidoeDictionary;
  NSMutableArray *_reusableCells;
}

@property (nonatomic, retain) NSDictionary *videoDictionary;
@property (nonatomic, retain) NSMutableArray *reusableCells;

@end
