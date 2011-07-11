//
//  Survivor.h
//  LivingProof
//
//  Created by Andrew Kutta on 6/30/11.
//  Copyright 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Survivor : NSObject {
    NSURL*    url;
    NSString* name;
}
@property (retain, nonatomic) NSString* name;
@property (retain, nonatomic) NSURL* url;

@end
