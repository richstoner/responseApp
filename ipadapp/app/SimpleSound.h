//
//  SimpleSound.h
//  app
//
//  Created by Rich Stoner on 9/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface SimpleSound : NSObject {
    
}

+ (void)playSoundWithName:(NSString *)fileName type:(NSString *)fileExtension;
+ (void)vibrateDevice;

@end
