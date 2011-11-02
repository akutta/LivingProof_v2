//
//  NSString+DateAdditions.m
//  LivingProof
//
//  Created by Mark Sands on 11/2/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import "NSString+DateAdditions.h"

@implementation NSString (DateAdditions)

+ (NSString *)currentTime
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"MM-dd-yyyy HH:mm:ss"];

  NSString *dateString = [formatter stringFromDate:[NSDate date]];
  [formatter release];

  return dateString;
}

@end
