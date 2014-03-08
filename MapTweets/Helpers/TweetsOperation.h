//
//  TweetsOperation.h
//  MapTweets
//
//  Created by cash on 08/03/14.
//  Copyright (c) 2014 codewai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InfoTweet.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@protocol TweetsOperationDelegate;

@interface TweetsOperation : NSOperation
{
    
}




@property NSMutableData *datos;
@property (nonatomic,strong)NSMutableArray *allTweets;
@property (nonatomic) ACAccountStore *accountStore;
@property id<TweetsOperationDelegate> delegate;



@end

@protocol TweetsOperationDelegate <NSObject>

//-(void)imageOperation:(ImageOperation *)operation withAppInfo:(RSSObject *)rss;
@required
-(void) plotMapView:(TweetsOperation *)operation withDataArray:(NSArray*) array;

@end
