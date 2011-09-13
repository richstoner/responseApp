//
//  SiteCell.m
//  Cascade
//
//  Created by Rich Stoner on 5/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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
