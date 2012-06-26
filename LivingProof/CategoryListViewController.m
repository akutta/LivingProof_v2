//
//  CategoryListViewController.m
//  LivingProof
//
//  Created by Mark Sands on 9/19/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import "CategoryListViewController.h"

@implementation CategoryListViewController

@synthesize videoDictionary = _videoDictionary;
@synthesize reusableCells = _reusableCells;

#pragma mark - View Lifecycle

- (id)initWithDictionary:(NSDictionary*)dict
{
  if ((self = [super init]))
  {
    //self.videoDictionary = [dict retain];
      self.videoDictionary = dict;
  }
  
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  //self.articleDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Articles" ofType:@"plist"]];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.videoDictionary = nil;
  self.reusableCells = nil;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [self.videoDictionary.allKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 1;
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
  self.videoDictionary = nil;
  self.reusableCells = nil;
  
  //[super dealloc];
}

@end
