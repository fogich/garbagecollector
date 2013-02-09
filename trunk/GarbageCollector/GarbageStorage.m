//
//  GarbageStorage.m
//  GarbageCollector
//
//  Created by Student06 on 2/2/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "GarbageStorage.h"
#import "User.h"
#import <CoreData/CoreData.h>

@interface GarbageStorage ()

@property (strong, nonatomic) User* user;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)initUser;

@end

@implementation GarbageStorage
@synthesize user;
@synthesize managedObjectContext=_managedObjectContext;
@synthesize managedObjectModel=_managedObjectModel;
@synthesize persistentStoreCoordinator=_persistentStoreCoordinator;

-(id)init
{
    self = [super init];
    if (self) {
        [self initUser];
    }
    return self;
}

+(id)instance
{
    static GarbageStorage* sharedInstance = nil;
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:nil] init];
    }
    return sharedInstance;
}

+(id)allocWithZone:(NSZone *)zone
{
    return [self instance];
}

-(void)initUser
{
    
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    request.entity = entity;
    NSArray* result = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    self.user = [result objectAtIndex: 0];
    
    //create user and some garbage spots
    
//    self.user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
//    user.fbid = @"12303012301230";
//    user.fbName = @"Kurtev";
//    user.fbPictureFilename = @"shitpic";
//    
//    GarbageSpot* newGarbageSpot = [self createGarbageSpot];
//    newGarbageSpot.address = @"some address";
//    newGarbageSpot.latitude = [NSNumber numberWithDouble:42.691126];
//    newGarbageSpot.longitude = [NSNumber numberWithDouble:23.319875];
//    newGarbageSpot.fbid = @"fbid";
//    newGarbageSpot.pictureDescription=@"dumbshit description";
//    
//    [self addGarbageSpot:newGarbageSpot];
//    
//    GarbageSpot* newGarbageSpot2 = [self createGarbageSpot];
//    newGarbageSpot2.address = @"some address 2";
//    newGarbageSpot2.latitude = [NSNumber numberWithDouble:42.694442];
//    newGarbageSpot2.longitude = [NSNumber numberWithDouble:23.322512];
//    newGarbageSpot2.fbid = @"fbid2";
//    newGarbageSpot2.pictureDescription=@"even stupider description";
//    [self addGarbageSpot:newGarbageSpot2];
//    
//    GarbageSpot* newGarbageSpot3 = [self createGarbageSpot];
//    newGarbageSpot3.address = @"some address 3";
//    newGarbageSpot3.latitude = [NSNumber numberWithDouble:42.694442];
//    newGarbageSpot3.longitude = [NSNumber numberWithDouble:23.322512];
//    newGarbageSpot3.fbid = @"fbid3";
//    newGarbageSpot3.pictureDescription=@"hobo alley";
//    [self addGarbageSpot:newGarbageSpot3];
//    
//        GarbageSpot* newGarbageSpot4 = [self createGarbageSpot];
//        newGarbageSpot4.address = @"some address 4";
//        newGarbageSpot4.latitude = [NSNumber numberWithDouble:42.737683];
//        newGarbageSpot4.longitude = [NSNumber numberWithDouble:23.298225];
//        newGarbageSpot4.fbid = @"fbid4";
//       newGarbageSpot4.pictureDescription=@"abcdefeg";
//       [self addGarbageSpot:newGarbageSpot4];
}

-(GarbageSpot*)createGarbageSpot
{
    GarbageSpot* garbageSpot = [NSEntityDescription insertNewObjectForEntityForName:@"GarbageSpot" inManagedObjectContext:self.managedObjectContext];
    return garbageSpot;
}

-(void)addGarbageSpot:(GarbageSpot *)garbageSpot
{
    garbageSpot.reporter = self.user;
    [self.user addReportsObject:garbageSpot];
    [self saveContext];
}

//gets all garbage spots for the current user
-(NSArray*)allGarbageSpots
{
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"GarbageSpot" inManagedObjectContext:self.managedObjectContext];
    request.entity = entity;
    
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"fbid" ascending:YES]];
    
    NSArray* result = [self.managedObjectContext executeFetchRequest:request error:nil];
    //check for error
    return result;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end