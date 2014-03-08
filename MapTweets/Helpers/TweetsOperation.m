//
//  TweetsOperation.m
//  MapTweets
//
//  Created by cash on 08/03/14.
//  Copyright (c) 2014 codewai. All rights reserved.
//

#import "TweetsOperation.h"

@implementation TweetsOperation

@synthesize datos;
@synthesize delegate;
@synthesize accountStore;
@synthesize allTweets;

int tweetLife;
int numberTweet;


-(void)main
{
    tweetLife = 20;
    
    // [NSTimer scheduledTimerWithTimeInterval:tweetLife target:self selector:@selector(trigger:) userInfo:nil repeats:YES];
    
    numberTweet=0;
    
    allTweets = [[NSMutableArray alloc]init];
    
    accountStore = [[ACAccountStore alloc] init];
    
    
    [self getSecureTweets];

}




#pragma MARK Twitter API


-(void)getSecureTweets{
    
    [self startStreamingWithKeyword:@"I"];
    
}


- (void)startStreamingWithKeyword:(NSString *)aKeyword

{
    
    //First, we need to obtain the account instance for the user's Twitter account
    
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //  Request permission from the user to access the available Twitter accounts
    
    [store requestAccessToAccountsWithType:twitterAccountType options:nil
                                completion:^(BOOL granted, NSError *error) {
                                    
                                    if (!granted) {
                                        
                                        // The user rejected your request ; no message is shown if user has not tweeter account set up.
                                        // Just this log
                                        NSLog(@"User rejected access to the account.");
                                        
                                    }
                                    
                                    else {
                                        
                                        //available accounts; just test it with mine.
                                        NSArray *twitterAccounts = [store accountsWithAccountType:twitterAccountType];
                                        
                                        if ([twitterAccounts count] > 0) {
                                            
                                            ACAccount *account = [twitterAccounts lastObject];
                                            
                                            //working with such big data... we have to get working async every time a package data is received
                                            //of wait to Connection Did Finish..
                                            NSURL *url = [NSURL URLWithString:@"https://stream.twitter.com/1.1/statuses/filter.json"];
                                            NSDictionary *params = @{@"track" : aKeyword}; // gets tweets with text containing a Keyword "I"
                                            
                                           SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                           requestMethod:SLRequestMethodPOST
                                                                           URL:url
                                                                           parameters:params];
                                            
                                            
                                            
                                            [request setAccount:account];
                                            
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                NSURLConnection *aConn = [NSURLConnection connectionWithRequest:[request preparedURLRequest] delegate:self];
                                                
                                                [aConn start];
                                                
                                            });
                                            
                                        } // if ([twitterAccounts count] > 0)
                                        
                                    } // if (granted)
                                    
                                }];
    
}




-(void)connection:(NSURLConnection *)connection didReceiveResponse:
(NSURLResponse *)response
{
    
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:
(NSData *)data
{
     // we don´t want to save and manage so big stream in memory do we?
    //[datos appendData:data];
    NSString* response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray *array = [response componentsSeparatedByString:@"\r\n"];
    
    [[ self delegate] plotMapView:self withDataArray:array];
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSString *s = [[NSString alloc]initWithData:datos encoding:NSUTF8StringEncoding];
    
    UIImage *image = [UIImage imageWithData:datos];
    

    
    
    
    
    
}

@end
