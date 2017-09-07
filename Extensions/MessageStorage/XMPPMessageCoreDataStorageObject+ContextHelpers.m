#import "XMPPMessageCoreDataStorageObject+ContextHelpers.h"
#import "XMPPMessageContextCoreDataStorageObject+Protected.h"
#import "NSManagedObject+XMPPCoreDataStorage.h"

@implementation XMPPMessageCoreDataStorageObject (ContextHelpers)

- (XMPPMessageContextCoreDataStorageObject *)appendContextElement
{
    NSAssert(self.managedObjectContext, @"Attempted to append a context element to a message not associated with any managed object context");
    
    XMPPMessageContextCoreDataStorageObject *insertedElement = [XMPPMessageContextCoreDataStorageObject xmpp_insertNewObjectInManagedObjectContext:self.managedObjectContext];
    insertedElement.message = self;
    return insertedElement;
}

@end

@implementation XMPPMessageContextCoreDataStorageObject (ContextHelpers)

- (XMPPMessageContextJIDItemCoreDataStorageObject *)appendJIDItemWithTag:(XMPPMessageContextJIDItemTag)tag value:(XMPPJID *)value
{
    NSAssert(self.managedObjectContext, @"Attempted to append an item to a context element not associated with any managed object context");
    
    XMPPMessageContextJIDItemCoreDataStorageObject *insertedItem = [XMPPMessageContextJIDItemCoreDataStorageObject xmpp_insertNewObjectInManagedObjectContext:self.managedObjectContext];
    insertedItem.tag = tag;
    insertedItem.value = value;
    insertedItem.contextElement = self;
    return insertedItem;
}

- (XMPPMessageContextMarkerItemCoreDataStorageObject *)appendMarkerItemWithTag:(XMPPMessageContextMarkerItemTag)tag
{
    NSAssert(self.managedObjectContext, @"Attempted to append an item to a context element not associated with any managed object context");
    
    XMPPMessageContextMarkerItemCoreDataStorageObject *insertedItem = [XMPPMessageContextMarkerItemCoreDataStorageObject xmpp_insertNewObjectInManagedObjectContext:self.managedObjectContext];
    insertedItem.tag = tag;
    insertedItem.contextElement = self;
    return insertedItem;
}

- (XMPPMessageContextStringItemCoreDataStorageObject *)appendStringItemWithTag:(XMPPMessageContextStringItemTag)tag value:(NSString *)value
{
    NSAssert(self.managedObjectContext, @"Attempted to append an item to a context element not associated with any managed object context");
    
    XMPPMessageContextStringItemCoreDataStorageObject *insertedItem = [XMPPMessageContextStringItemCoreDataStorageObject xmpp_insertNewObjectInManagedObjectContext:self.managedObjectContext];
    insertedItem.tag = tag;
    insertedItem.value = value;
    insertedItem.contextElement = self;
    return insertedItem;
}

- (XMPPMessageContextTimestampItemCoreDataStorageObject *)appendTimestampItemWithTag:(XMPPMessageContextTimestampItemTag)tag value:(NSDate *)value
{
    NSAssert(self.managedObjectContext, @"Attempted to append an item to a context element not associated with any managed object context");
    
    XMPPMessageContextTimestampItemCoreDataStorageObject *insertedItem = [XMPPMessageContextTimestampItemCoreDataStorageObject xmpp_insertNewObjectInManagedObjectContext:self.managedObjectContext];
    insertedItem.tag = tag;
    insertedItem.value = value;
    insertedItem.contextElement = self;
    return insertedItem;
}

- (void)removeJIDItemsWithTag:(XMPPMessageContextJIDItemTag)tag
{
    NSAssert(self.managedObjectContext, @"Attempted to remove an item from a context element not associated with any managed object context");
    
    for (XMPPMessageContextJIDItemCoreDataStorageObject *jidItem in [self jidItemsForTag:tag expectingSingleElement:NO]) {
        [self removeJidItemsObject:jidItem];
        [self.managedObjectContext deleteObject:jidItem];
    }
}

- (void)removeMarkerItemsWithTag:(XMPPMessageContextMarkerItemTag)tag
{
    NSAssert(self.managedObjectContext, @"Attempted to remove an item from a context element not associated with any managed object context");
    
    for (XMPPMessageContextMarkerItemCoreDataStorageObject *markerItem in [self markerItemsForTag:tag expectingSingleElement:NO]) {
        [self removeMarkerItemsObject:markerItem];
        [self.managedObjectContext deleteObject:markerItem];
    }
}

- (void)removeStringItemsWithTag:(XMPPMessageContextStringItemTag)tag
{
    NSAssert(self.managedObjectContext, @"Attempted to remove an item from a context element not associated with any managed object context");
    
    for (XMPPMessageContextStringItemCoreDataStorageObject *stringItem in [self stringItemsForTag:tag expectingSingleElement:NO]) {
        [self removeStringItemsObject:stringItem];
        [self.managedObjectContext deleteObject:stringItem];
    }
}

- (void)removeTimestampItemsWithTag:(XMPPMessageContextTimestampItemTag)tag
{
    NSAssert(self.managedObjectContext, @"Attempted to remove an item from a context element not associated with any managed object context");
    
    for (XMPPMessageContextTimestampItemCoreDataStorageObject *timestampItem in [self timestampItemsForTag:tag expectingSingleElement:NO]) {
        [self removeTimestampItemsObject:timestampItem];
        [self.managedObjectContext deleteObject:timestampItem];
    }
}

- (NSSet<XMPPMessageContextJIDItemCoreDataStorageObject *> *)jidItemsForTag:(XMPPMessageContextJIDItemTag)tag expectingSingleElement:(BOOL)isSingleElementExpected
{
    NSSet *filteredSet = [self.jidItems objectsPassingTest:^BOOL(XMPPMessageContextJIDItemCoreDataStorageObject * _Nonnull obj, BOOL * _Nonnull stop) {
        BOOL matchesTag = [obj.tag isEqualToString:tag];
#ifdef NS_BLOCK_ASSERTIONS
        if (matchesTag && isSingleElementExpected) {
            *stop = YES;
        }
#endif
        return matchesTag;
    }];
    NSAssert(!(isSingleElementExpected && filteredSet.count > 1) , @"Only one item expected");
    return filteredSet;
}

- (NSSet<XMPPMessageContextMarkerItemCoreDataStorageObject *> *)markerItemsForTag:(XMPPMessageContextMarkerItemTag)tag expectingSingleElement:(BOOL)isSingleElementExpected
{
    NSSet *filteredSet = [self.markerItems objectsPassingTest:^BOOL(XMPPMessageContextMarkerItemCoreDataStorageObject * _Nonnull obj, BOOL * _Nonnull stop) {
        BOOL matchesTag = [obj.tag isEqualToString:tag];
#ifdef NS_BLOCK_ASSERTIONS
        if (matchesTag && isSingleElementExpected) {
            *stop = YES;
        }
#endif
        return matchesTag;
    }];
    NSAssert(!(isSingleElementExpected && filteredSet.count > 1) , @"Only one item expected");
    return filteredSet;
}

- (NSSet<XMPPMessageContextStringItemCoreDataStorageObject *> *)stringItemsForTag:(XMPPMessageContextStringItemTag)tag expectingSingleElement:(BOOL)isSingleElementExpected
{
    NSSet *filteredSet = [self.stringItems objectsPassingTest:^BOOL(XMPPMessageContextStringItemCoreDataStorageObject * _Nonnull obj, BOOL * _Nonnull stop) {
        BOOL matchesTag = [obj.tag isEqualToString:tag];
#ifdef NS_BLOCK_ASSERTIONS
        if (matchesTag && isSingleElementExpected) {
            *stop = YES;
        }
#endif
        return matchesTag;
    }];
    NSAssert(!(isSingleElementExpected && filteredSet.count > 1) , @"Only one item expected");
    return filteredSet;
}

- (NSSet<XMPPMessageContextTimestampItemCoreDataStorageObject *> *)timestampItemsForTag:(XMPPMessageContextTimestampItemTag)tag expectingSingleElement:(BOOL)isSingleElementExpected
{
    NSSet *filteredSet = [self.timestampItems objectsPassingTest:^BOOL(XMPPMessageContextTimestampItemCoreDataStorageObject * _Nonnull obj, BOOL * _Nonnull stop) {
        BOOL matchesTag = [obj.tag isEqualToString:tag];
#ifdef NS_BLOCK_ASSERTIONS
        if (matchesTag && isSingleElementExpected) {
            *stop = YES;
        }
#endif
        return matchesTag;
    }];
    NSAssert(!(isSingleElementExpected && filteredSet.count > 1) , @"Only one item expected");
    return filteredSet;
}

@end
