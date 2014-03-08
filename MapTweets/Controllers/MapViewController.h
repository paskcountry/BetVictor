//
//  ViewController.h
//  MapTweets
//
//  Created by cash on 07/03/14.
//  Copyright (c) 2014 codewai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "InfoTweet.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "TweetsOperation.h"


@interface MapViewController : UIViewController<NSURLConnectionDelegate, MKMapViewDelegate, UIPickerViewDataSource,UIPickerViewDelegate,TweetsOperationDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnChangeLifeSpan;

@property (strong,nonatomic)NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (nonatomic) ACAccountStore *accountStore;
@property (nonatomic) NSMutableData *receivedData;
- (IBAction)changeLifeSpan:(id)sender;

@property (nonatomic,strong)NSMutableArray *allTweets;

@end
