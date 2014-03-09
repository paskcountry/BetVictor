//
//  InfoTweet.h
//  MapTweets
//
//  Created by cash on 07/03/14.
//  Copyright (c) 2014 codewai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface InfoTweet : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    NSString *userName;
    NSDate *annotationCreated;
    int number;
    BOOL timeToDie;
    
    
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,assign) int number;
@property (nonatomic,assign) BOOL timeToDie;
@property (nonatomic,retain) NSString *userName;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,retain) NSDate *annotationCreated;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c
                  title:(NSString *) t
               subtitle:(NSString *) st number:(int)index;




@end
