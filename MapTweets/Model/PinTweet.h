//
//  Entity.h
//  MapTweets
//
//  Created by cash on 08/03/14.
//  Copyright (c) 2014 codewai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PinTweet : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * lifeTime;
@property (nonatomic,retain) NSNumber *latitude;
@property (nonatomic,retain) NSNumber *longitude;

@end
