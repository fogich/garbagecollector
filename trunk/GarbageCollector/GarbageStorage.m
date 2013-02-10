//
//  GarbageStorage.m
//  GarbageCollector
//
//  Created by Student06 on 2/2/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "GarbageStorage.h"
#import <CoreData/CoreData.h>


@interface GarbageStorage ()

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation GarbageStorage
@synthesize managedObjectContext=_managedObjectContext;
@synthesize managedObjectModel=_managedObjectModel;
@synthesize persistentStoreCoordinator=_persistentStoreCoordinator;

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

-(GarbageSpot*)createGarbageSpot
{
    GarbageSpot* garbageSpot = [NSEntityDescription insertNewObjectForEntityForName:@"GarbageSpot" inManagedObjectContext:self.managedObjectContext];
    return garbageSpot;
}

-(Location*)createLocationWithLatitude:(double) latitude Longitude: (double) longitude Address: (NSString*)address Region: (NSString*) regionName
{
    Location* location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
    location.latitude = [NSNumber numberWithDouble: latitude];
    location.longitude = [NSNumber numberWithDouble: longitude];
    location.address = address;
    
    //checkRegion
    Region* region = [self getRegionWithName:regionName];
    [region addSpotLocationsObject: location];
    
    return location;
}

-(Region*) getRegionWithName: (NSString*) regionName
{
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Region" inManagedObjectContext:self.managedObjectContext];
    request.entity = entity;
    request.predicate = [NSPredicate predicateWithFormat:@"name==%@", regionName];
    
    NSArray* result = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    Region* region = nil;
    if(!result || result.count==0)
    {
        region = [NSEntityDescription insertNewObjectForEntityForName:@"Region" inManagedObjectContext:self.managedObjectContext];
        if(regionName)
        {
            region.name = regionName;
        }
        else
        {
            region.name = @"Unknown";
        }
    }
    else
    {
        [result objectAtIndex:0];
    }
    
    return region;
}
-(void)addGarbageSpot:(GarbageSpot *)garbageSpot
{
    [self saveContext];
}

//gets all garbage spots for the current user
-(NSArray*)allGarbageSpots
{
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"GarbageSpot" inManagedObjectContext:self.managedObjectContext];
    request.entity = entity;
    
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:YES]];
    
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
