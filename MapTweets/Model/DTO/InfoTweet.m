//
//  InfoTweet.m
//  MapTweets
//
//  Created by cash on 07/03/14.
//  Copyright (c) 2014 codewai. All rights reserved.
//

#import "InfoTweet.h"

@implementation InfoTweet

@synthesize title;
@synthesize subtitle;
@synthesize coordinate;
@synthesize userName;
@synthesize number;
@synthesize annotationCreated;
@synthesize timeToDie;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c
                  title:(NSString *) t
               subtitle:(NSString *) st
                 number:(int)index
{
    coordinate = c;
    title = [t copy];
    subtitle = [st copy];
    number=index;
    
    return self;
}

@end
