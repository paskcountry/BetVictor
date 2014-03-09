//
//  CoreDataManager.h
//
//  MapTweets
//
//  Created by cash on 07/03/14.
//  Copyright (c) 2014 codewai. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject {
    
}

@property (nonatomic, readonly, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (CoreDataManager *)sharedInstance;

@end
