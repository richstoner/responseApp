//
//  ExperimentViewController.h
//  app
//
//  Created by Rich Stoner on 8/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuiConstants.h"
#import "SiteCell.h"

typedef enum {
    touchPositionMiddleTop,
    touchPositionMiddleBottom,
} touchPosition;

@interface ExperimentViewController : UIViewController <UIGestureRecognizerDelegate> {
    UIScreen*       mainScreen;
        
    NSArray*        experimentArray;
    NSString*       subjectID;
    
    UIView*         fixationCircleView;
    UIView*         touchCircleView;
    
    NSNumber*       fixationDuration;
    NSNumber*       preparationDuration;
    NSNumber*       movementDuration;
    NSNumber*       movementSteps;
    
    int             currentSceneIndex;
    float           _touchSize;
    touchPosition   currentTouchPosition;
    
    NSDate *        startdate;
    NSTimer*        experimentTimer;
    
    int             maxTrials;
    int             currentTrial;
    
    NSMutableArray *trialArray;
    
    BOOL isFirstLoad;
}

@property(nonatomic, retain) NSArray* experimentArray;

@property(nonatomic, retain) NSNumber* fixationDuration;
@property(nonatomic, retain) NSNumber* preparationDuration;
@property(nonatomic, retain) NSNumber* movementDuration;
@property(nonatomic, retain) NSNumber* movementSteps;

@property(nonatomic, retain) NSString* subjectID;

-(void) parseJSONexperiment;
-(void) loadScene:(int)sceneIndex;
-(void) nextScene;
-(void) writeJSONresult;
-(void) printSummary;
-(void) startExperiment;


-(BOOL) nextBool:(double)probability;
-(void) configureExperimentTrials:(int)numTrials andTouchSize:(float)touchSize;
- (NSString *)formattedStringUsingFormat:(NSString *)dateFormat;

- (CGPoint) getCirclePosition:(NSString*)position;
- (id)initWithScreen:(UIScreen *)newScreenForDisplay;

@end
