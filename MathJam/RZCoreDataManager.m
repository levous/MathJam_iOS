//
//  RZCoreDataManager.m
//
//

#import "RZCoreDataManager.h"
#import "RZMissingNumberEquation.h"


@interface RZCoreDataManager (Internal)
- (void)initializeCoreDataStack:(NSURL *)databaseURL;
@end

static RZCoreDataManager *_sharedInstance = nil;

@implementation RZCoreDataManager
@synthesize persistentStoreCoordinator;
@synthesize managedObjectModel;

NSString *_databaseRelPath = @"Library/MathJam.sqlite";

+ (RZCoreDataManager *)sharedInstance {
	if(_sharedInstance == nil) {
		NSString *databasePath = [NSHomeDirectory() stringByAppendingPathComponent:_databaseRelPath];
		_sharedInstance = [[RZCoreDataManager alloc] initWithURL:[NSURL fileURLWithPath:databasePath]];
	}
	
	return _sharedInstance;
}

- (id)initWithURL:(NSURL *)databaseURL {
	if((self = [super init])) {
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(managedObjectContextDidSave:) 
													 name:NSManagedObjectContextDidSaveNotification
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(threadWillExit:) 
													 name:NSThreadWillExitNotification
												   object:nil];
		[self initializeCoreDataStack:databaseURL];
	}
	
	return self;
}

- (void)initializeCoreDataStack:(NSURL *)databaseURL {
	NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"MathJam" ofType:@"momd"];
	managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:modelPath]];
	
	if(managedObjectModel == nil) {
		NSLog(@"Error: Managed object model was nil after initialization");
	}			
	
	NSDictionary *options =  [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithBool:YES],
							  NSMigratePersistentStoresAutomaticallyOption, 
							  [NSNumber numberWithBool:YES],
							  NSInferMappingModelAutomaticallyOption, 
							  nil];
	
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
	
	if(persistentStoreCoordinator == nil) {
		NSLog(@"Error: Persistent store coordinator was nil after initialization");
	}
	
	NSError *error = nil;
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
												  configuration:nil 
															URL:databaseURL 
														options:options 
														  error:&error])
	{
		NSLog(@"Error: Could not add persistent store to persistent store coordinator: %@", error);
	}
	
	
	managedObjectContextsForThreads = [[NSMutableDictionary alloc] init];
	
	NSAssert([NSThread isMainThread], @"Core Data Manager expects to be initialized on the main thread");
	
	// Ensure we have a managed object context on our main thread
	NSManagedObjectContext *mainThreadMoc = [self managedObjectContextForCurrentThread];
	// Change the merge policy from our default to merge-by-property, object-trumps
	[mainThreadMoc setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
}

- (NSManagedObjectContext *)managedObjectContextForThread:(NSThread *)thread {
	NSAssert(self.persistentStoreCoordinator, @"Persistent store coordinator was nil when initializing managed object context");
	
	NSValue *threadPointer = [NSValue valueWithNonretainedObject:thread];
	NSManagedObjectContext *moc = [managedObjectContextsForThreads objectForKey:threadPointer];
	
	if(moc == nil) {
		moc = [[NSManagedObjectContext alloc] init];
		[moc setPersistentStoreCoordinator:self.persistentStoreCoordinator];
		[moc setMergePolicy:NSOverwriteMergePolicy]; // TODO: Check the performance of this versus merging.
		
		[managedObjectContextsForThreads setObject:moc forKey:threadPointer];
	}
	
	if(moc == nil) {
		NSLog(@"Warning: Unable to create/retrieve a managed object context for thread %@", thread);
	}
	
	return moc;
}

- (NSManagedObjectContext *)managedObjectContextForCurrentThread {
	return [self managedObjectContextForThread:[NSThread currentThread]];
}

- (void)clearAllData{
    NSLog(@"Warning: Blowing away existing database!");
    for(NSPersistentStore *store in self.persistentStoreCoordinator.persistentStores){
        [self.persistentStoreCoordinator removePersistentStore:store error:nil];
    }
    NSString *databasePath = [NSHomeDirectory() stringByAppendingPathComponent:_databaseRelPath];
    [[NSFileManager defaultManager] removeItemAtPath:databasePath error:NULL];
    [self initializeCoreDataStack:[NSURL fileURLWithPath:databasePath]];
}

- (NSManagedObject *)entityWithID:(NSManagedObjectID *)objectID {
	if([objectID isTemporaryID]) {
		NSLog(@"Warning: Asked to fetch object with temporary ID. Object must be saved before fetching. Continuing...");
	}
	
	NSManagedObject *obj = [[self managedObjectContextForCurrentThread] objectWithID:objectID];
	return obj; // May be a fault
}

- (NSArray *)allEntitiesForName:(NSString *)entityName {
	return [self entitiesForName:entityName matchingPredicate:nil sortedByDescriptors:nil];
}

- (NSArray *)entitiesForName:(NSString *)entityName matchingPredicate:(NSPredicate *)predicate {
	return [self entitiesForName:entityName matchingPredicate:predicate sortedByDescriptors:nil];
}

// Retrieve a list of entities of a certain type matching the specified predicates and sorted according to the provided sort descriptors
- (NSArray *)entitiesForName:(NSString *)entityName matchingPredicate:(NSPredicate *)predicate sortedByDescriptors:(NSArray *)descriptors {
	
	NSManagedObjectContext *moc = [self managedObjectContextForCurrentThread];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:moc]];
	[fetchRequest setFetchBatchSize:20];
	[fetchRequest setReturnsObjectsAsFaults:NO]; // TODO: test performance implications
	[fetchRequest setResultType:NSManagedObjectResultType];
	[fetchRequest setIncludesPendingChanges:YES];
	[fetchRequest setIncludesPropertyValues:YES];
	[fetchRequest setIncludesSubentities:NO];
	
	if(predicate) {
		[fetchRequest setPredicate:predicate];
	}
	
	if([descriptors count] > 0) {
		[fetchRequest setSortDescriptors:descriptors];
	}
	
	NSError *error = nil;
	NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
	
	if(error) {
		NSLog(@"Error: Failed to execute fetch request %@. Error was %@", fetchRequest, error);
	}
	
	return results;
}

- (id)insertObjectWithEntityNamed:(NSString *)entityName properties:(NSDictionary *)properties {
	NSManagedObjectContext *moc = [self managedObjectContextForCurrentThread];
	NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:moc];
	
	[object setValuesForKeysWithDictionary:properties];
	
	return object;
}

- (void)deleteObject:(NSManagedObject *)object {
	NSManagedObjectContext *moc = [self managedObjectContextForCurrentThread];
	[moc deleteObject:object];
}

- (BOOL)save:(NSError **)error {
	NSManagedObjectContext *moc = [self managedObjectContextForCurrentThread];
	BOOL success = [moc save:error];
	
	if(error && *error) {
		NSLog(@"Error occurred when saving managed object context: %@", *error);
	}
	
	return success;
}

- (PracticeSession *)insertNewPracticeSession{
    PracticeSession *session = [self insertObjectWithEntityNamed:@"PracticeSession" properties:nil];
    session.startTime = [NSDate date];
    session.factorOneUpperBound = [NSNumber numberWithInt:12];
    session.factorOneLowerBound = [NSNumber numberWithInt:1];
    session.factorTwoUpperBound = [NSNumber numberWithInt:12];
    session.factorTwoLowerBound = [NSNumber numberWithInt:1];
    
    return session;
}


- (PracticeSession *)insertCopyOfPracticeSession:(PracticeSession *)practiceSession{
    PracticeSession *newSession = [self insertNewPracticeSession];
    newSession.factorOneLowerBound = practiceSession.factorOneLowerBound;
    newSession.factorTwoLowerBound = practiceSession.factorTwoLowerBound;
    newSession.factorOneUpperBound = practiceSession.factorOneUpperBound;
    newSession.factorTwoUpperBound = practiceSession.factorTwoUpperBound;
    newSession.practiceAddition = practiceSession.practiceAddition;
    newSession.practiceSubtraction = practiceSession.practiceSubtraction;
    newSession.practiceMultiplication = practiceSession.practiceMultiplication;
    newSession.practiceDivision = practiceSession.practiceDivision;
    return newSession;
}

- (NSArray *)getAllPracticeSessions{
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:YES]];
    NSArray *result = [self entitiesForName:@"PracticeSession"
                          matchingPredicate:nil
                        sortedByDescriptors:sortDescriptors];
    return result;
}

- (MathEquation *)insertNewMathEquationInSession:(PracticeSession *)session withFactorOne:(NSNumber *)factorOne factorTwo:(NSNumber *)factorTwo operation:(RZMathOperation)operation{
    MathEquation *equation = [self insertObjectWithEntityNamed:@"MathEquation" properties:nil];
    equation.createdAt = [NSDate date];
    equation.session = session;
    equation.factorOne = factorOne;
    equation.factorTwo = factorTwo;
    equation.operation = [NSNumber numberWithInt:operation];
    return equation;
}



// NSManagedObjectContextObjectsDidChangeNotification
-(void)managedObjectContextDidSave:(NSNotification *)notification {
	for(NSManagedObjectContext *moc in [managedObjectContextsForThreads allValues])
	{
		if([notification object] != moc)
		{
			// Look up thread for the MOC we'll be causing to merge - should be unique
			NSThread *thread = [[[managedObjectContextsForThreads allKeysForObject:moc] lastObject] nonretainedObjectValue];
			
			NSAssert(thread, @"Warning: Unable to find thread associated with managed object context");

			[moc performSelector:@selector(mergeChangesFromContextDidSaveNotification:) 
						onThread:thread 
					  withObject:notification
				   waitUntilDone:NO];
		}
	}
}

// NSThreadWillExitNotification
-(void)threadWillExit:(NSNotification *)notification {
	NSValue *threadPointer = [NSValue valueWithNonretainedObject:[NSThread currentThread]];
	NSManagedObjectContext *moc = [managedObjectContextsForThreads objectForKey:threadPointer];
	if(moc)
	{
		[[NSNotificationCenter defaultCenter] removeObserver:moc 
														name:NSManagedObjectContextObjectsDidChangeNotification 
													  object:nil];
		
		NSLog(@"Notice: Will destroy managed object context for thread %@", threadPointer);
		[managedObjectContextsForThreads removeObjectForKey:threadPointer];
	}
}

@end
