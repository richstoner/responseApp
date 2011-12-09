/*
 * Created by Rich Stoner, September 10th, 2011
 * 
 * Copyright (c) 2011 Rich Stoner, wholeslide.com
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * 
 * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 * 
 * Neither the name of the project's author nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */



#import "ExperimentViewController.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"
#import <QuartzCore/QuartzCore.h>
#import "SimpleSound.h"
#include "mach/mach_time.h"


@implementation ExperimentViewController

#pragma mark -
#pragma mark Initialization and teardown

@synthesize experimentArray, subjectID, movementSteps, movementDuration, fixationDuration, preparationDuration;

#pragma mark -
#pragma mark Base methods
#pragma mark -


- (id)initWithScreen:(UIScreen *)newScreenForDisplay;
{
    if ((self = [super initWithNibName:nil bundle:nil])) 
	{
        trialArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)dealloc
{
    [trialArray release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)loadView
{
	CGRect mainScreenFrame = [[UIScreen mainScreen] applicationFrame];	
	UIView *primaryView = [[UIView alloc] initWithFrame:mainScreenFrame];
    [primaryView setBackgroundColor:[UIColor whiteColor]];
    self.view = primaryView;

    CGFloat radius = [self.view frame].size.width * 0.05;
    fixationCircleView = [[UIView alloc] initWithFrame:CGRectMake(0,0, radius*2, radius*2)];
    
    fixationCircleView.layer.masksToBounds = NO;
    fixationCircleView.layer.cornerRadius = radius; // if you like rounded corners
    fixationCircleView.layer.shadowOffset = CGSizeMake(3, 4);
    fixationCircleView.layer.shadowRadius = 5;
    fixationCircleView.layer.shadowOpacity = 0.9;
    [fixationCircleView setBackgroundColor:[UIColor redColor]];
    [fixationCircleView setCenter:[self.view center]];
    fixationCircleView.hidden = NO;
    [primaryView addSubview:fixationCircleView];
    
    touchCircleView = [[UIView alloc] initWithFrame:CGRectMake(0,0, radius*2, radius*2)];    
    touchCircleView.layer.masksToBounds = NO;
    touchCircleView.layer.cornerRadius = radius; // if you like rounded corners
    touchCircleView.layer.shadowOffset = CGSizeMake(3, 4);
    touchCircleView.layer.shadowRadius = 5;
    touchCircleView.layer.shadowOpacity = 0.9;
    [touchCircleView setBackgroundColor:[UIColor blueColor]];
    [touchCircleView setCenter:[self getCirclePosition:@"MiddleTop"]];
    //    touchCircleView.hidden = YES;
    
    UITapGestureRecognizer *touchTargetRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(targetPress:)];
    touchTargetRecognizer.delegate = self;
    [touchTargetRecognizer setNumberOfTapsRequired:1];
    [touchCircleView addGestureRecognizer:touchTargetRecognizer];
    [touchTargetRecognizer release];
    
    UITapGestureRecognizer *incorrectTargetRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(incorrectPress:)];
    incorrectTargetRecognizer.delegate = self;
    [incorrectTargetRecognizer setNumberOfTapsRequired:1];
    [primaryView addGestureRecognizer:incorrectTargetRecognizer];
    [incorrectTargetRecognizer release];

    UITapGestureRecognizer *fixationTargetRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fixationPress:)];
    fixationTargetRecognizer.delegate = self;
    [fixationTargetRecognizer setNumberOfTapsRequired:1];
    [fixationCircleView addGestureRecognizer:fixationTargetRecognizer];
    [fixationTargetRecognizer release];

    
    [primaryView addSubview:touchCircleView];     
    [primaryView release];
    
    [self parseJSONexperiment];
 
    maxTrials = 2;
    currentTrial = 0;
    
}

#pragma mark -
#pragma mark Experiment Setup
#pragma mark -


-(void) configureExperimentTrials:(int)numTrials andTouchSize:(float)touchSize
{
    currentSceneIndex = 0;
    currentTrial = 0;
    maxTrials  = numTrials;
    _touchSize = touchSize;
    
    [trialArray removeAllObjects];
    
//    startdate = [NSDate date];
    startdate = [[NSDate alloc] initWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970]];
    NSTimeInterval timePassed_ms = [startdate timeIntervalSinceNow] * -1000.0;
    NSArray* logArray = [NSArray arrayWithObjects:@"Experiment configured", [NSString stringWithFormat:@"%f", timePassed_ms], nil];
    [trialArray addObject:logArray];
    
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(touchSize, touchSize);
    touchCircleView.transform = scaleTransform;
    fixationCircleView.transform = scaleTransform;
        
}

-(void) printSummary
{
    NSTimeInterval timePassed_ms = [startdate timeIntervalSinceNow] * -1000.0;
    NSArray* logArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"Total steps: %d", [movementSteps intValue] + 2], [NSString stringWithFormat:@"%f", timePassed_ms], nil];
    [trialArray addObject:logArray];

    NSTimeInterval timePassed_ms1 = [startdate timeIntervalSinceNow] * -1000.0;
    NSArray* logArray1 = [NSArray arrayWithObjects:[NSString stringWithFormat:@"Fixation duration: %f", [fixationDuration floatValue]], [NSString stringWithFormat:@"%f", timePassed_ms1], nil];
    [trialArray addObject:logArray1];
    
    NSTimeInterval timePassed_ms2 = [startdate timeIntervalSinceNow] * -1000.0;
    NSArray* logArray2 = [NSArray arrayWithObjects:[NSString stringWithFormat:@"Preparation duration: %f", [preparationDuration floatValue]], [NSString stringWithFormat:@"%f", timePassed_ms2], nil];
    [trialArray addObject:logArray2];
    
    NSTimeInterval timePassed_ms3 = [startdate timeIntervalSinceNow] * -1000.0;
    NSArray* logArray3 = [NSArray arrayWithObjects:[NSString stringWithFormat:@"Movement duration: %f", [movementDuration floatValue]], [NSString stringWithFormat:@"%f", timePassed_ms3], nil];
    [trialArray addObject:logArray3];
    
    NSTimeInterval timePassed_ms4 = [startdate timeIntervalSinceNow] * -1000.0;
    NSArray* logArray4 = [NSArray arrayWithObjects:[NSString stringWithFormat:@"Object size: %f", _touchSize], [NSString stringWithFormat:@"%f", timePassed_ms4], nil];
    [trialArray addObject:logArray4];
    
    NSLog(@"Total steps: %d\n", [movementSteps intValue] + 2);
    NSLog(@"Fixation duration: %f\n", [fixationDuration floatValue]);
    NSLog(@"Preparation duration: %f\n", [preparationDuration floatValue]);
    NSLog(@"Movement duration: %f\n", [movementDuration floatValue]);
    NSLog(@"Object size: %f\n", _touchSize);
    NSLog(@"Number of trials: %d", maxTrials);
    
}

-(void) startExperiment
{
//    NSTimeInterval timePassed_ms = [startdate timeIntervalSinceNow] * -1000.0;
//    NSArray* logArray = [NSArray arrayWithObjects:@"Experiment started", [NSString stringWithFormat:@"%f", timePassed_ms], nil];
//    [trialArray addObject:logArray];
//    
    NSTimeInterval timePassed_ms = [startdate timeIntervalSinceNow] * -1000.0;
    NSArray* logArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"Sound Start: %d", currentTrial], [NSString stringWithFormat:@"%f", timePassed_ms], nil];
    [trialArray addObject:logArray];

    [SimpleSound playSoundWithName:@"1kHz_44100Hz_16bit_new" type:@"wav"];

    NSTimeInterval timePassed_ms2 = [startdate timeIntervalSinceNow] * -1000.0;
    NSArray* logArray2 = [NSArray arrayWithObjects:[NSString stringWithFormat:@"Trial Start: %d", currentTrial], [NSString stringWithFormat:@"%f", timePassed_ms2], nil];
    [trialArray addObject:logArray2];

    
    [self loadScene:currentSceneIndex];
}


-(void) loadScene:(int)sceneIndex
{   
    NSDictionary* sceneDict;
    if (sceneIndex < 2) {
        sceneDict = [experimentArray objectAtIndex:sceneIndex];
    }
    else
    {
        sceneDict = [experimentArray objectAtIndex:2];
    }
    
    NSString* scene_name = [NSString stringWithFormat:@"%d - %@", sceneIndex, [sceneDict objectForKey:@"name"]];
//    NSNumber* base_time = [sceneDict objectForKey:@"base_time"];
//    NSNumber* flex_time = [sceneDict objectForKey:@"flex_time"];        
//    NSString* trigger = [sceneDict objectForKey:@"trigger"];
     
    NSTimeInterval timePassed_ms = [startdate timeIntervalSinceNow] * -1000.0;
    NSArray* logArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"Scene: %@", scene_name], [NSString stringWithFormat:@"%f", timePassed_ms], nil];
    [trialArray addObject:logArray];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSceneLabel" object:scene_name];    
    
    NSArray* scene_items = [sceneDict objectForKey:@"items"];
    for (NSDictionary* item in scene_items) {
        
        if([[item objectForKey:@"id"] isEqualToString:@"touch target"])
        {
            BOOL hidden = [[item objectForKey:@"hidden"] boolValue];
            touchCircleView.hidden = hidden;
            NSString* locationString = [item objectForKey:@"location"];
            
            
            if([locationString isEqualToString:@"randomHorizontalMidline"])
            {
                
                BOOL topbottom = [self nextBool:0.5f];
                
                if (topbottom) {
                    [touchCircleView setCenter:[self getCirclePosition:@"MiddleTop"]];
                    currentTouchPosition = touchPositionMiddleTop;
                }
                else
                {
                    [touchCircleView setCenter:[self getCirclePosition:@"MiddleBottom"]];
                    currentTouchPosition = touchPositionMiddleBottom;
                }
            }
            else if([locationString isEqualToString:@"alternateHorizontalMidline"])
            {
                if (currentSceneIndex > 2) {
                    if(currentTouchPosition == touchPositionMiddleTop)
                    {
                        [touchCircleView setCenter:[self getCirclePosition:@"MiddleBottom"]];
                        currentTouchPosition = touchPositionMiddleBottom;
                    }
                    else if(currentTouchPosition == touchPositionMiddleBottom)
                    {
                        [touchCircleView setCenter:[self getCirclePosition:@"MiddleTop"]];
                        currentTouchPosition = touchPositionMiddleTop;
                    }                    
                }
            }
            else if([locationString isEqualToString:@"sameHorizontalMidline"])
            {
                // do nothing
            }
        }
        
        if([[item objectForKey:@"id"] isEqualToString:@"fixation target"])
        {
            BOOL hidden = [[item objectForKey:@"hidden"] boolValue];
            fixationCircleView.hidden = hidden;
            
            NSString* colorString = [item objectForKey:@"color"];
            if([colorString isEqualToString:@"green"])
            {
                [fixationCircleView setBackgroundColor:[UIColor greenColor]];                    
            }
            else if([colorString isEqualToString:@"red"])
            {
                [fixationCircleView setBackgroundColor:[UIColor redColor]];
            }
        }
    }

    CGFloat final_duration = 0.0;
    
    switch (currentSceneIndex) {
        case 0:
            //fixation
            final_duration = [fixationDuration floatValue];
            experimentTimer = [NSTimer scheduledTimerWithTimeInterval: final_duration
                                                               target: self
                                                             selector:@selector(onTick:)
                                                             userInfo: nil repeats:NO];
            [fixationCircleView setUserInteractionEnabled:YES];
            [touchCircleView setUserInteractionEnabled:NO];
            break;
            
        case 1:
            //preparation
            final_duration = [preparationDuration floatValue];
            experimentTimer = [NSTimer scheduledTimerWithTimeInterval: final_duration
                                                               target: self
                                                             selector:@selector(onTick:)
                                                             userInfo: nil repeats:NO];
            [fixationCircleView setUserInteractionEnabled:YES];
            [touchCircleView setUserInteractionEnabled:NO];
            break;
            
        default:
            // movement
            final_duration = [movementDuration floatValue];
            experimentTimer = [NSTimer scheduledTimerWithTimeInterval: final_duration
                                                               target: self
                                                             selector:@selector(onTick:)
                                                             userInfo: nil repeats:NO];
            [fixationCircleView setUserInteractionEnabled:YES];
            [touchCircleView setUserInteractionEnabled:YES];
            break;
    }
    


    
    
//    
//    if([trigger isEqualToString:@"timer"])
//    {
//        // timer
//        CGFloat timer_duration  = [base_time floatValue];
//        CGFloat timer_flex  = [flex_time floatValue];
//        arc4random();
//        int x = arc4random() % 100;
//        float y = (float)x/100;
//        
//        CGFloat final_duration = timer_duration + timer_flex*y;
//        
//    }
//    else
//    {
//        // touch
//        [fixationCircleView setUserInteractionEnabled:NO];
//        [touchCircleView setUserInteractionEnabled:YES];   
//    }
}


-(void) onTick:(id)sender
{
    NSTimeInterval timePassed_ms = [startdate timeIntervalSinceNow] * -1000.0;
    NSArray* logArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"Timer: %d", currentSceneIndex], [NSString stringWithFormat:@"%f", timePassed_ms], nil];
    [trialArray addObject:logArray];
    
//    [trialArray addObject:[NSString stringWithFormat:@"Timer from scene: %d", currentSceneIndex]];
    [self nextScene];
}


-(BOOL) nextBool:(double)probability
{
    double random_num = rand();
    double rand_cutoff = probability* RAND_MAX;

//    if(random_num < rand_cutoff)
//    {
//        printf("Random Bool: True\n");
//    }
//    else
//    {
//        printf("Random Bool: False\n");
//    }
    
    return random_num < rand_cutoff;
}

#pragma mark -
#pragma mark Touch handlers
#pragma mark -

- (void)targetPress:(UITapGestureRecognizer *)recognizer {
    
    switch ([recognizer state]) {
        case UIGestureRecognizerStateBegan:
            //            NSLog(@"Began -");
            break;            
        case UIGestureRecognizerStateChanged:
            //            NSLog(@"changed -");            
            break;
            
        case UIGestureRecognizerStateEnded:
            //            NSLog(@"ended -");
            [self nextSceneTouch];
            break;
            
        default:
            break;
    }
}

-(void) nextSceneTouch
{
    [experimentTimer invalidate];
    
    NSTimeInterval timePassed_ms = [startdate timeIntervalSinceNow] * -1000.0;
    NSArray* logArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"Correct touch: %d", currentSceneIndex], [NSString stringWithFormat:@"%f", timePassed_ms], nil];
    [trialArray addObject:logArray];
    
    [self nextScene];
}

-(void) nextScene
{
        
    if(touchCircleView.userInteractionEnabled)
    {
        
    }
    else
    {
        [experimentTimer invalidate];            
    }
    
    
    if(currentSceneIndex < [movementSteps intValue] + 2 )
    {
        currentSceneIndex++;
    }
    else
    {
        NSTimeInterval timePassed_ms = [startdate timeIntervalSinceNow] * -1000.0;
        NSArray* logArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"Trial End: %d", currentTrial], [NSString stringWithFormat:@"%f", timePassed_ms], nil];
        [trialArray addObject:logArray];
        
        NSTimeInterval timePassed_ms2 = [startdate timeIntervalSinceNow] * -1000.0;
        NSArray* logArray2 = [NSArray arrayWithObjects:[NSString stringWithFormat:@"Sound Play: %d", currentTrial], [NSString stringWithFormat:@"%f", timePassed_ms2], nil];
        [trialArray addObject:logArray2];
        
        [SimpleSound playSoundWithName:@"1kHz_44100Hz_16bit_new" type:@"wav"];

        
        currentSceneIndex = 0;
        currentTrial++;
    }
    
    
    if (currentTrial <= maxTrials-1) {
        

        
        [self loadScene:currentSceneIndex];
    }
    else
    {
        
        
        [self writeJSONresult];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowMainMenu" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSceneLabel" object:@"Ready"];            
        
        NSTimeInterval timePassed_ms = [startdate timeIntervalSinceNow] * -1000.0;
        NSArray* logArray = [NSArray arrayWithObjects:@"Experiment End", [NSString stringWithFormat:@"%f", timePassed_ms], nil];
        [trialArray addObject:logArray];
    }
}


-(void) fixationTouch
{
    NSTimeInterval timePassed_ms = [startdate timeIntervalSinceNow] * -1000.0;
    NSArray* logArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"Fixation touch: %d", currentSceneIndex], [NSString stringWithFormat:@"%f", timePassed_ms], nil];
    [trialArray addObject:logArray];
}

- (void)fixationPress:(UITapGestureRecognizer *)recognizer {
    
    switch ([recognizer state]) {
        case UIGestureRecognizerStateBegan:
            //            NSLog(@"Began -");
            break;            
        case UIGestureRecognizerStateChanged:
            //            NSLog(@"changed -");            
            break;
            
        case UIGestureRecognizerStateEnded:
            //            NSLog(@"ended -");
            
            [self fixationTouch];
            
            break;
            
        default:
            break;
    }
}

-(void) incorrectTouch
{
    NSTimeInterval timePassed_ms = [startdate timeIntervalSinceNow] * -1000.0;
    NSArray* logArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"Incorrect touch: %d", currentSceneIndex], [NSString stringWithFormat:@"%f", timePassed_ms], nil];
    [trialArray addObject:logArray];
}

- (void)incorrectPress:(UITapGestureRecognizer *)recognizer {
    
    switch ([recognizer state]) {
        case UIGestureRecognizerStateBegan:
            //            NSLog(@"Began -");
            break;            
        case UIGestureRecognizerStateChanged:
            //            NSLog(@"changed -");            
            break;
            
        case UIGestureRecognizerStateEnded:
            //            NSLog(@"ended -");
            
            [self incorrectTouch];
            
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark File input output methods
#pragma mark -

-(void) writeJSONresult
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *datestring = [self formattedStringUsingFormat:@"yyyy-MM-dd-HH-mm-ss"];

    NSString* filePath = [NSString stringWithFormat:@"%@/%@-exp-%@.json", documentsDirectory, subjectID, datestring];
    NSLog(@"File written to %@\n", filePath);
    NSError *error = NULL;
    NSData *jsonData = [[CJSONSerializer serializer] serializeObject:trialArray error:&error];
    
    NSMutableString * csv = [NSMutableString string];
    [csv appendString:@"<!DOCTYPE HTML><head><style type='text/css'>"];
    [csv appendString:@"<!DOCTYPE HTML><head><style type='text/css'>"];
    [csv appendString:@"body { font-family:'Helvetica',Georgia,Serif; color: #000; background-color: transparent; line-height: 12pt; font-size: 10pt; text-align: left;}"];
    [csv appendString:@"h1 {font-family:'Helvetica',Georgia,Serif; color: #999; text-align: left; font-weight: bold; line-height: 12pt; font-size: 11pt;padding-bottom: 3px;}"];
	[csv appendString:@"p { padding: 5px;}"];
    [csv appendString:@"</style></head><body>"];
    [csv appendFormat:@"<h1>Last trial: %@</h1>", filePath];
    
    for(NSArray* record in trialArray)
    {
        NSString* message = [record objectAtIndex:0];
        NSNumber* timepoint = [record objectAtIndex:1];
        
        [csv appendFormat:@"<p><b>%@</b> - %f ms</p>\n", message, [timepoint floatValue]];
    }
    
    [csv appendString:@"</body></html>"];
    
    NSString* lastTrialPath = [NSString stringWithFormat:@"%@/lastTrial.html", documentsDirectory];
    [csv writeToFile:lastTrialPath atomically:YES encoding:NSStringEncodingConversionAllowLossy error:&error];
    
    
    [jsonData writeToFile:filePath atomically:YES];
}

-(void) parseJSONexperiment
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"example_trial" ofType:@"json"];  
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];  
    if (jsonData) {  
        NSError *error = nil;
        NSArray* temparray = [[CJSONDeserializer deserializer] deserializeAsArray:jsonData error:&error];
        experimentArray = [[NSArray alloc] initWithArray:temparray];
    } 
}


- (NSString *)formattedStringUsingFormat:(NSString *)dateFormat
{
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    [formatter setCalendar:cal];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString *ret = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    [cal release];
    return ret;
}

#pragma mark -
#pragma mark Target utilities
#pragma mark -



- (CGPoint) getCirclePosition:(NSString*)position
{
    CGFloat width = [self.view frame].size.width;
    CGFloat height = [self.view frame].size.height;    
    
    float topPosition = height*0.25;
//    float centerPosition = height*0.5;
    float bottomPosition = height*0.75;
    
//    float leftPosition = width*0.25;
    float middlePosition = width*0.5;
//    float rightPosition = width*0.75;
    
    if ([position isEqualToString:@"MiddleTop"]) {
        return CGPointMake(middlePosition, topPosition);
    }
    
    if ([position isEqualToString:@"MiddleBottom"]) {
        return CGPointMake(middlePosition, bottomPosition);
    }    
    
    return CGPointMake(0, 0);
}

#pragma mark -
#pragma mark Viewcontroller methods
#pragma mark -


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end







