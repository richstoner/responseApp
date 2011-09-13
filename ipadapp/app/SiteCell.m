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


#import "SiteCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation SiteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        l_MainText = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 250, 40)];
        [l_MainText setFont:[UIFont fontWithName:@"Helvetica" size:18]];
        l_MainText.textColor = [UIColor blackColor];
        [l_MainText setTextAlignment:UITextAlignmentLeft];
        l_MainText.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:l_MainText];

    }
	
    return self;
}

-(void)setMainText:(NSString*)mainLabel
{
    l_MainText.text = mainLabel;
}

- (void)setFlickrPhoto:(NSString*)flickrPhoto {
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	
	if(!newSuperview) {

	}
}

- (void)dealloc {

    [super dealloc];
}


@end
