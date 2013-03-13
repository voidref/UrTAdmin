//
//  ServerData.h
//  UrTAdmin
//
//  Created by Alan Westbrook on 9/21/11.
//  Copyright (c) 2011 Rockwood Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerData : NSObject

+ (uint32_t) serverCount;
+ (void)     addServer: (NSArray*) serverData;
+ (void)     deleteServerAtIndex: (uint32_t)index;
+ (void)     setServerData: (NSArray*)serverData 
                   atIndex: (uint32_t)index;
+ (NSArray*) getServerDataAtIndex: (uint32_t)index;

@end
