//
//  ServerData.h
//  UrTAdmin
//
//  Created by Alan Westbrook on 9/21/11.
//  Copyright (c) 2011 Rockwood Software. All rights reserved.
//

// TODO: Change from hokey singleton

@interface ServerData : NSObject

+ (uint32_t) serverCount;
+ (void)     addServer:             (NSArray*)      serverData;
+ (void)     deleteServerAtIndex:   (NSUInteger)    index;

+ (void)     setServerData:         (NSArray*)      serverData
                   atIndex:         (NSUInteger)    index;

+ (NSArray*) getServerDataAtIndex:  (NSUInteger)    index;

@end
