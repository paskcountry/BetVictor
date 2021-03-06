//
//  ViewController.m
//  MapTweets
//
//  Created by cash on 07/03/14.
//  Copyright (c) 2014 codewai. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
{
    
    UIPickerView *pickerView;
    UIToolbar *pickerToolbar;

    UIPopoverController *popOverController;
}

@end

@implementation MapViewController

@synthesize accountStore;
@synthesize receivedData;
@synthesize allTweets;


@synthesize mapView;
@synthesize btnChangeLifeSpan;

@synthesize timer;

@synthesize dao;

int numberTweet;
int tweetLife;
bool resetTweetLife;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //By default I have set timer to 20 seconds.
    tweetLife = 20;
  
 
    
    numberTweet=0;
    
    allTweets = [[NSMutableArray alloc]init];
    
    self.mapView.delegate = self;

    
    TweetsReachability *tR = [[TweetsReachability alloc]init];
    
    bool isConnection = [tR isInternetReachable];
    
    //if connection avaiable launch the request
    
    if (isConnection)
       [self launchTweetRequest];
    
    // else get data from last connection
    else
     [self getTweetsFromDataBase];
    
    
    timer =[NSTimer scheduledTimerWithTimeInterval:tweetLife target:self selector:@selector(trigger:) userInfo:nil repeats:YES];
    
    

}

-(void)launchTweetRequest
{
    
    NSOperationQueue *que = [NSOperationQueue mainQueue];
    
    TweetsOperation * operation = [[TweetsOperation alloc]init];
    operation.delegate=self;
    
    [que addOperation:operation ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma MARK MAPVIEW


-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    
}


-(void)getTweetsFromDB:(TweetsOperation *)operation
{
    
    [self getTweetsFromDataBase];
}
-(void)getTweetsFromDataBase
{
    
        if (dao ==nil)
            dao = [[PinTweetDAO alloc]init];
    
          allTweets = [[NSMutableArray alloc]initWithArray:[dao lastPinsCollection]];
         // allTweets = [dao lastPinsCollection];
    
          for (InfoTweet * info in allTweets)
          {
              [mapView addAnnotation:info];
          }
    
}

-(void)persistTweetsData:(TweetsOperation *)operation
{
    if ([allTweets count]>0)
    {
        if (dao ==nil)
            dao = [[PinTweetDAO alloc]init];
   
        bool result = [dao insertPinsCollection:allTweets lifeTime:[NSNumber numberWithInt:tweetLife]];
    
  
        if (result)
        {
       
            NSLog(@"Data persisted correctly");
        }
    
        else
        {
            NSLog(@"Error persisting data");
        
        }
    }

}
-(void)plotMapView:(TweetsOperation *)operation withDataArray:(NSArray *)array
{
    for (NSString *currentJson in array) {
        
        
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[currentJson dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        
        if ([jsonDic objectForKey:@"geo"]!=  nil && [[jsonDic objectForKey:@"geo"]valueForKey:@"coordinates"]!= [ NSNull null]    )
        {
            
            numberTweet++;
            NSString *title = [jsonDic valueForKey:@"text"];
            NSString *subtitle= [jsonDic valueForKey:@"created_at"];
            
            
            NSMutableArray *tweetCoordinates = [[NSMutableArray alloc]initWithObjects:[[jsonDic objectForKey:@"geo"]valueForKey:@"coordinates"],nil];
            
            
            if (tweetCoordinates != nil  && [tweetCoordinates count]>0)
            {
                NSArray *coordinateArray = [tweetCoordinates objectAtIndex:0] ;
                
                NSString *strLat = [coordinateArray objectAtIndex:0];
                NSString *strLon = [coordinateArray objectAtIndex:1];
                double lat = [strLat doubleValue];
                double lon = [strLon doubleValue];
                
                CLLocationCoordinate2D coords = (CLLocationCoordinate2D){ lat, lon };
                
                
                InfoTweet *infoTweet = [[InfoTweet alloc] initWithCoordinate:coords title:title subtitle:subtitle number:numberTweet];
                
                infoTweet.annotationCreated = [NSDate date];
                [allTweets addObject:infoTweet];
                
                [mapView addAnnotation:infoTweet];
                
            }
            
        }
        
    }
    
    
}


#pragma MARK TIMER LIFE SPAN


- (void) stopTimer
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
}

- (void) startTimer
{
    [self stopTimer];
    timer = [NSTimer scheduledTimerWithTimeInterval: tweetLife
                                             target: self
                                           selector:@selector(trigger:)
                                           userInfo: nil repeats:YES];
    
}

- (void)trigger:(NSTimer *)sender{

    static int count = 1;
    
    @try {
        
        NSLog(@"triggred %d time",count);
        [self checkTimeToDie];
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception ocurred %@",[exception name]);
    }
    @finally {
        
        count ++;
    }
}


-(void)checkTimeToDie
{
    if (dao == nil)
        dao = [[PinTweetDAO alloc]init];
    
    //Formatt for compare the dates
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    
    NSMutableArray *wipeItems = [[NSMutableArray alloc]init];
   
        int annotationsNumber = (int)[[mapView annotations]count];

        NSLog(@"annotations number right now is : %d",annotationsNumber);

  
    
    
    for (InfoTweet *tweet in allTweets)
    {
        NSDate *now = [NSDate date];
        
        NSLog(@"before add interval creation date is %@",[formatter stringFromDate:tweet.annotationCreated]);
        
        NSDate *newDate = [tweet.annotationCreated dateByAddingTimeInterval:tweetLife]; // annotation creation date + lifespan
        
        NSLog(@"after add interval creation date is %@",[formatter stringFromDate:tweet.annotationCreated]);
           NSLog(@"new  date is %@",[formatter stringFromDate:newDate]);
        
        NSComparisonResult result;
        
        
        //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
        
        result = [newDate compare:now]; // comparing two dates
        
        if(result==NSOrderedAscending)
        {
            NSLog(@"expiration time has come ..Remove annotation");
            NSLog(@"creation date is %@",[formatter stringFromDate:tweet.annotationCreated]);
            
            
            tweet.timeToDie=YES;
            //We just can delete here aswell from memory..but we will do at the end iterating the array wipeItems
            [wipeItems addObject:tweet];
            
            //Delete Pins from Core Data
            [dao deletePinTweets:tweet.annotationCreated];
            
            [mapView removeAnnotation:tweet];
            
        }
        else if(result==NSOrderedDescending)
        {
            NSLog(@"keep alive");
            
        }
        else
        {
            NSLog(@"your time has just come");
            NSLog(@"creation date is %@",[formatter stringFromDate:tweet.annotationCreated]);
            tweet.timeToDie=YES;
            
            //We just can delete here aswell from memory..but we will do at the end iterating the array wipeItems
            [wipeItems addObject:tweet];
            [mapView removeAnnotation:tweet];

            //Delete from CoreData
            [dao deletePinTweets:tweet.annotationCreated];
           
            
        }
    }
    
    //remove from memory
    [allTweets removeObjectsInArray:wipeItems];
    
   // [mapView removeAnnotations:wipeItems];
 
    annotationsNumber = (int)[[mapView annotations]count];
    
    NSLog(@"annotations number right now is : %d",annotationsNumber);
    NSLog(@"tweetlife is number right now is : %d",tweetLife);

}


#pragma Mark change Life of Pins PICKER VIEW

- (IBAction)changeLifeSpan:(id)sender {
    
    
    pickerView = [[UIPickerView alloc]init];
    pickerToolbar =[[UIToolbar alloc]init];
    
    UIViewController *popOverContent= [[UIViewController alloc]init];
    UIView *popOverView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, [pickerView frame].size.width, [pickerView frame].size.height +44)];

    pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake([popOverView frame].origin.x,[popOverView frame].origin.y +44, 240,44)];
    pickerToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake([popOverView frame].origin.x,[popOverView frame].origin.y, 240,44)];
    
    [pickerView setDataSource:self];
    [pickerView setDelegate:self];
    [pickerView setShowsSelectionIndicator:YES];
    
    [pickerToolbar setBarStyle:UIBarStyleBlack];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"OK" style:UIBarButtonItemStyleBordered target:self action:@selector(donePressed:)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPressed:)];
    
    [pickerToolbar setItems:[NSArray arrayWithObjects:flexSpace,doneButton,cancelButton,nil]];
    
    [popOverView addSubview:pickerView];
    [popOverView addSubview:pickerToolbar];
    [popOverContent setView:popOverView];
    
    popOverController   = [[UIPopoverController alloc]initWithContentViewController:popOverContent];
    popOverController.popoverContentSize = CGSizeMake([pickerView frame].size.width, [popOverView frame].size.height);
    
    [popOverController presentPopoverFromBarButtonItem:btnChangeLifeSpan permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

    return 20;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    tweetLife = (int)(row+1)*10;
}




-(void)donePressed:(id)sender
{
   
    [self startTimer];
    [popOverController dismissPopoverAnimated:YES];
}

-(void)cancelPressed:(id)sender
{
    tweetLife = 20;
    resetTweetLife=YES;
    [popOverController dismissPopoverAnimated:YES];
}



-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        [tView setFont:[UIFont fontWithName:@"Baskerville-Bold" size:16]];
        [tView setTextColor:[UIColor blueColor]];
        [tView setTextAlignment:NSTextAlignmentCenter];
    }
    
    
    
    
    NSString *pvText =@"";
    int numberSeconds = (int)(row+1)*10;
    pvText = [NSString stringWithFormat:@"%d seconds", numberSeconds];
    
    
    [tView setText:pvText];
    return tView;
}


@end
