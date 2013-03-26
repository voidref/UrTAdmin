//
//  ServerData.m
//  UrTAdmin
//
//  Created by Alan Westbrook on 9/21/11.
//  Copyright (c) 2011 Rockwood Software. All rights reserved.
//


// TODO: use CoreData instead of UserDefaults

#import "ServerData.h"

@implementation ServerData

+ (uint32_t) serverCount
{
	NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
	return [defs integerForKey: @"ServerCount"];
}


+ (void) addServer: (NSArray*) serverData_
{
	NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"defaults: %@", [defs dictionaryRepresentation]);
	int count = [defs integerForKey: @"ServerCount"];
	int version = [defs integerForKey: @"Storage Version"];
	
	if (0 == version)
	{
		// Set the storage version
		version = 1;
		
		[defs setInteger:version 
				  forKey:@"Storage Version"];		
	}
	
	[defs setObject:serverData_
		     forKey:[NSString stringWithFormat:@"Server %d", count]];
    
	NSLog(@"Set Server %d: %@", count, serverData_);
	
	[defs setInteger:count + 1
			  forKey:@"ServerCount"];
	
	
	[NSUserDefaults resetStandardUserDefaults];
}


+ (void) deleteServerAtIndex: (NSUInteger)index_
{
	NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    
    NSString* key = [NSString stringWithFormat:@"Server %d", index_];
    
    [defs removeObjectForKey:key];
    
    // Shift the rest of the server indexes up one
    // This isn't the most efficient way to go about doing things, but we are abusing UserDefaults here, after all.
    NSArray* server = nil;
    NSString* oldkey = [NSString stringWithFormat:@"Server %d", index_ + 1];
    for(uint32_t i = index_ + 1; nil != (server = [defs objectForKey:oldkey]) ; ++i)
    {
        [defs setObject:server
                 forKey:key];
        
        key = oldkey;
        oldkey = [NSString stringWithFormat:@"Server %d", i];
    }
    
    [defs setInteger:[defs integerForKey: @"ServerCount"] - 1
              forKey:@"ServerCount"];
    
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
    
	[defs setObject:serverData_
		     forKey:[NSString stringWithFormat:@"Server %d", index_]];
    
	[NSUserDefaults resetStandardUserDefaults];
}

+ (NSArray*) getServerDataAtIndex: (NSUInteger)index_
{
	NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    
	NSString* key = [NSString stringWithFormat:@"Server %d", index_];
	return [defs stringArrayForKey: key];
}

@end
