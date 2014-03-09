//
//  PinTweetDAO.m
//  MapTweets
//
//  Created by cash on 08/03/14.
//  Copyright (c) 2014 codewai. All rights reserved.
//

#import "PinTweetDAO.h"

@implementation PinTweetDAO


-(BOOL)insertPinsCollection:(NSMutableArray *)infoList lifeTime:(NSNumber *)duration
{
    bool result=YES;
    NSManagedObjectContext * moc = [[CoreDataManager sharedInstance ]managedObjectContext];
    
    
    for (InfoTweet * info in infoList)
    {
        PinTweet *p= [NSEntityDescription insertNewObjectForEntityForName:@"PinTweet" inManagedObjectContext:moc];
    
    
    
        p.text = info.title;
        p.id =[NSNumber numberWithInt:info.number];
        p.date =info.annotationCreated;
        p.lifeTime=duration;
        p.latitude=[NSNumber numberWithDouble:info.coordinate.latitude];
        p.longitude=[NSNumber numberWithDouble:info.coordinate.longitude];
    
        NSError *error ;
        if ( [moc save:&error])
        {
        result=result & YES;
        }
    
        else{
            result=NO;
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error" message:error.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            
        }
    }
    return result;
}


-(BOOL)insertNewPin:(InfoTweet *)info lifeTime:(NSNumber *)duration
{
    bool result;
    NSManagedObjectContext * moc = [[CoreDataManager sharedInstance ]managedObjectContext];
    
    PinTweet *p= [NSEntityDescription insertNewObjectForEntityForName:@"PinTweet" inManagedObjectContext:moc];
    
    p.text = info.title;
    p.id =[NSNumber numberWithInt:info.number];
    p.date =info.annotationCreated;
    p.lifeTime=duration;
    p.latitude=[NSNumber numberWithDouble:info.coordinate.latitude];
    p.longitude=[NSNumber numberWithDouble:info.coordinate.longitude];
   
    NSError *error ;
    if ( [moc save:&error])
    {
        result=YES;
    }

    else
        result=NO;
    
    return result;
}

-(NSMutableArray *)lastPinsCollection
{
    NSMutableArray * pinsCollection= [[NSMutableArray alloc]init];
    NSManagedObjectContext * moc = [[CoreDataManager sharedInstance ]managedObjectContext];
    NSEntityDescription * entidad = [NSEntityDescription entityForName:@"PinTweet" inManagedObjectContext:moc];
    
    NSFetchRequest * request = [[NSFetchRequest alloc]init];
    
    [request setEntity:entidad];
    
    NSArray *resultado = [moc executeFetchRequest:request error:nil];
    
   
    for (PinTweet *p in resultado)
    {
        double lat = [p.latitude doubleValue];
        double longitude = [p.longitude doubleValue];

        InfoTweet *info = [[InfoTweet alloc]initWithCoordinate:(CLLocationCoordinate2D){ lat,longitude } title:p.text subtitle:@"" number:(int)p.id];
      
        info.annotationCreated =p.date;
        
       [pinsCollection addObject:info];
        //tweets received from core data wont have a subtitle to differ from url requested data.
        
    }
    
    return pinsCollection;
}


-(BOOL)deletePinTweets:(NSDate *)annotationDate
{
    bool result;
    NSManagedObjectContext * moc = [[CoreDataManager sharedInstance ]managedObjectContext];

    NSFetchRequest *fetchedObjects = [NSFetchRequest fetchRequestWithEntityName:@"PinTweet"];
    
    [fetchedObjects setPredicate:[NSPredicate predicateWithFormat:@"(date== %@)",annotationDate]];
    NSError * error = nil;
    
    NSArray * results = [moc executeFetchRequest:fetchedObjects error:&error];
    
    for ( PinTweet * pin in results)
    {
        [moc deleteObject:pin];
    }
    
    NSError *saveError ;
    if ( [moc save:&saveError])
    {
        result=YES;
    }
    else
        result=NO;

    return result;
}

@end
