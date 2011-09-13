//
//  SimpleSound.m
//  app
//
//  Created by Rich Stoner on 9/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimpleSound.h"


@implementation SimpleSound

+ (void)playSoundWithName:(NSString *)fileName type:(NSString *)fileExtension
{
	CFStringRef cfFileName = (CFStringRef) fileName;
	CFStringRef cfFileExtension = (CFStringRef) fileExtension;
	CFBundleRef mainBundle;
	mainBundle = CFBundleGetMainBundle ();
	CFURLRef soundURLRef  = CFBundleCopyResourceURL (mainBundle, cfFileName, cfFileExtension, NULL);
	SystemSoundID soundID;
	AudioServicesCreateSystemSoundID (soundURLRef, &soundID);
	AudioServicesPlaySystemSound (soundID);
	CFRelease(soundURLRef);    
}

+ (void)vibrateDevice
{
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
