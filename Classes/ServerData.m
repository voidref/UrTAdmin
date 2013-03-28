//
//  ServerData.m
//  UrTAdmin
//
//  Created by Alan Westbrook on 9/21/11.
//  Copyright (c) 2011 Rockwood Software. All rights reserved.
//


// TODO: use CoreData instead of UserDefaults

#import "ServerData.h"

static NSString*    skServerCountKey            = @"ServerCount";
static NSString*    skStorageVersionKey         = @"StorageVersion";
static NSUInteger   skCurrentStorageVersion     = 1;

@implementation ServerData

+ (uint32_t) serverCount
{
	NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
	return [defs integerForKey: skServerCountKey];
}


+ (void) addServer: (NSArray*) serverData_
{
	NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    
	int count = [defs integerForKey: skServerCountKey];
	int version = [defs integerForKey: skStorageVersionKey];
	
	if (0 == version)
	{
		// Set the storage version
		version = skCurrentStorageVersion;
		
		[defs setInteger: version 
				  forKey: skStorageVersionKey];
	}
	
	[defs setObject: serverData_
		     forKey: [ServerData serverKeyForIndex: count]];
    
	
	[defs setInteger:count + 1
			  forKey:skServerCountKey];
	
	
	[NSUserDefaults resetStandardUserDefaults];
}


+ (void) deleteServerAtIndex: (NSUInteger)index_
{
	NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    
    NSString* key = [ServerData serverKeyForIndex: index_];
    
    [defs removeObjectForKey:key];
    
    // Shift the rest of the server indexes up one
    // This isn't the most efficient way to go about doing things, but we are abusing UserDefaults here, after all.
    NSArray* server = nil;
    NSString* oldkey = [ServerData serverKeyForIndex: index_ + 1];
    for(uint32_t i = index_ + 1; nil != (server = [defs objectForKey:oldkey]) ; ++i)
    {
        [defs setObject:server
                 forKey:key];
        
        key = oldkey;
        oldkey = [ServerData serverKeyForIndex: i];
    }
    
    [defs setInteger: [defs integerForKey: skServerCountKey] - 1
              forKey: skServerCountKey];
    
    [NSUserDefaults resetStandardUserDefaults];
}


+ (void) setServerData: (NSArray*)serverData_ 
               atIndex: (NSUInteger)index_
{
    if (serverData_.count < 4)
    {
        NSLog(@" ** Error, incorrect amount of data for server, fix your code, slacker");
        return;
    }
    
	NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    
	[defs setObject: serverData_
		     forKey: [ServerData serverKeyForIndex: index_]];
    
	[NSUserDefaults resetStandardUserDefaults];
}

+ (NSArray*) getServerDataAtIndex: (NSUInteger)index_
{
	NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    
	NSString* key = [ServerData serverKeyForIndex: index_];
	return [defs stringArrayForKey: key];
}

+ (NSString*) serverKeyForIndex: (NSUInteger) index_
{
    return [NSString stringWithFormat:@"Server %d", index_];
}
@end
