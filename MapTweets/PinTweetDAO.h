//
//  PinTweetDAO.h
//  MapTweets
//
//  Created by cash on 08/03/14.
//  Copyright (c) 2014 codewai. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CoreDataManager.h"
#import <CoreData/CoreData.h>
#import "PinTweet.h"
#import "InfoTweet.h"
#import <Foundation/Foundation.h>

@interface PinTweetDAO : NSObject

-(BOOL)insertPinsCollection:(NSMutableArray *)infoList lifeTime:(NSNumber *)duration;
-(BOOL)insertNewPin:(InfoTweet *)info lifeTime:(NSNumber *)duration;
-(BOOL)deletePinTweets:(NSDate*)annotationDate;
-(NSMutableArray *)lastPinsCollection;


@end
