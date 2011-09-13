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
