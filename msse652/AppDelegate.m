//
//  AppDelegate.m
//  msse652
//
//  Created by echolush on 6/29/14.
//  Copyright (c) 2014 Matt Ozer. All rights reserved.
//

#import "AppDelegate.h"
#import <RestKit/RestKit.h>
#import "Program.h"
#import "Course.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // initialize core data
    [self initializeService];
    return YES;
}

- (void)initializeService
{
    // set all logs to trace
    //RKLogConfigureByName("*", RKLogLevelTrace);
    
    // initialize the object manager
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://regisscis.net"]];
    
    //Creates and returns a new class route object with the Program class, path pattern and GET method.
    [manager.router.routeSet addRoute:[RKRoute routeWithClass:[Program class] pathPattern:@"/Regis2/webresources/regis2.course" method:RKRequestMethodGET]];
    //How parameters are encoded into a request body for request
    [manager.HTTPClient setParameterEncoding:AFJSONParameterEncoding];
    
    //Create an NSManagedObjectModel object, which describes the collection of entities
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    //Create a RKManagedObjectStore to encapsulate a Core Data stack including a managed object model
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    manager.managedObjectStore = managedObjectStore;

    //Map Program class
    RKEntityMapping *programMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Program class]) inManagedObjectStore:manager.managedObjectStore];
    programMapping.identificationAttributes = @[@"id"];
    [programMapping addAttributeMappingsFromDictionary:@{@"id": @"id" ,@"name": @"name"}];
    //Map Course class
    RKEntityMapping *courseMapping = [RKEntityMapping mappingForEntityForName:NSStringFromClass([Course class]) inManagedObjectStore:manager.managedObjectStore];
    courseMapping.identificationAttributes = @[@"id"];
    [courseMapping addAttributeMappingsFromDictionary:@{@"id": @"id" ,@"name": @"name", @"pid.id": @"pId", @"pid.name": @"pName"}];
    
    //Create the persistance store
    [managedObjectStore createPersistentStoreCoordinator];
    //Get the path to the Application Data directory
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"SCIS.sqlite"];
    //For error information
    NSError *error;
    //Add a new SQLite persistent store
    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:@{NSMigratePersistentStoresAutomaticallyOption:@(YES), NSInferMappingModelAutomaticallyOption:@(YES)} error:&error];
    //Generate an assertion for the given condition
    NSAssert(persistentStore, @"Failed persistent store %@", error);
    //Create the persistent store
    [managedObjectStore createManagedObjectContexts];
    
    //Configure a managed object cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
    
    //Describe the object mapping configuration that is applicable to an SCIS Program JSON HTTP response
    RKResponseDescriptor *responseDescriptorProgram =[RKResponseDescriptor responseDescriptorWithMapping:programMapping method:RKRequestMethodGET pathPattern:nil keyPath:@"pid" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    //Describe the object mapping configuration that is applicable to an SCIS Course JSON HTTP response
     RKResponseDescriptor *responseDescriptorCourse =[RKResponseDescriptor responseDescriptorWithMapping:courseMapping method:RKRequestMethodGET pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    //Create a URL request with course provided URL
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kCourseLocationURL]];
    //Set the specified HTTP header for JSON
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //Map Program and Course entities managed by Core Data
    RKManagedObjectRequestOperation *managedObjectRequestOperation =[[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptorCourse, responseDescriptorProgram]];
    //Set the context with the managed object request operation
    managedObjectRequestOperation.managedObjectContext = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    //Set the cache associated with the managed object request operation
    managedObjectRequestOperation.managedObjectCache = [RKManagedObjectStore defaultStore].managedObjectCache;
    //Adds the specified mapping operation to the queue
    [[NSOperationQueue mainQueue] addOperation:managedObjectRequestOperation];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
