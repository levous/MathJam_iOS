//
//  RZCoreDataManager.h
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "PracticeSession.h"
#import "MathEquation.h"
#import "RZEnums.h"

// A wrapper for Core Data access that assumes a single persistent store and single object model
// that may be accessed by managed object contexts on multple threads.

@interface RZCoreDataManager : NSObject {
	NSMutableDictionary *managedObjectContextsForThreads;
}

@property(nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, strong) NSManagedObjectModel *managedObjectModel;

// Get singleton instance of core data manager
+ (RZCoreDataManager *)sharedInstance;

// Initialize with path on disk to the desired SQLite database
- (id)initWithURL:(NSURL *)databaseURL;

// Get the managed object context for a thread. Context will be created if it doesn't exist
- (NSManagedObjectContext *)managedObjectContextForThread:(NSThread *)thread;

// Get the managed object context for the currently running thread.
- (NSManagedObjectContext *)managedObjectContextForCurrentThread;

// Retrieve a single managed object by its unique ID
- (NSManagedObject *)entityWithID:(NSManagedObjectID *)objectID;

// Retrieve a list of all entities of a certain type. Will never return nil.
- (NSArray *)allEntitiesForName:(NSString *)entityName;

// Retrieve a list of entities of a certain type matching the specified predicate.
// Predicate may be a compound predicate.
- (NSArray *)entitiesForName:(NSString *)entityName matchingPredicate:(NSPredicate *)predicate;

// Retrieve a list of entities of a certain type matching the specified predicates and 
// sorted according to the provided sort descriptors
- (NSArray *)entitiesForName:(NSString *)entityName matchingPredicate:(NSPredicate *)predicate sortedByDescriptors:(NSArray *)descriptors;

// Insert a new object in the managed object context for this thread. 
// Entity will have a temporary ID until the next call to save:. 
// Property keys must exactly match either a property name of the target entity or a valid key path.
- (id)insertObjectWithEntityNamed:(NSString *)entityName properties:(NSDictionary *)properties;

// Delete the specified object in its corresponding managed object context.
// This method MUST be called on the thread of the managed object context associated with the object.
- (void)deleteObject:(NSManagedObject *)object;

// Save all changes to the managed object context associated with this thread and propagate changes to
// contexts on other threads.
- (BOOL)save:(NSError **)error;

// insert and return a new practice session
- (PracticeSession *)insertNewPracticeSession;

// insert and return a new math equation for a session
- (MathEquation *)insertNewMathEquationInSession:(PracticeSession *)session withFactorOne:(NSNumber *)factorOne factorTwo:(NSNumber *)factorTwo operation:(RZMathOperation)operation;

@end
