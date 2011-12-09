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



@interface MainMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
    UIScreen* mainScreen;
            
//view
    UITableView* mainMenuTable;
    
    UITextField *subjectIDTextField; 
    
    UISlider* trialsSlider;
    UILabel* trialsLabel;

    UISlider* touchSizeSlider;
    UILabel* touchSizeLabel;
    
    UISlider* fixationDurationSlider;
    UILabel* fixationDurationLabel;
    
    UISlider* preparationDurationSlider;
    UILabel* preparationDurationLabel;
    
    UISlider* movementDurationSlider;
    UILabel* movementDurationLabel;
    
    UISlider* movementStepsSlider;
    UILabel* movementStepsLabel;
        
//state
    BOOL isFirstLoad;
}

@property(nonatomic, retain) UITextField* subjectIDTextField;

-(id)   initWithScreen:(UIScreen *)newScreenForDisplay;
-(void) configureMenu;

@end
