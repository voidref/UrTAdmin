//
//  InlineEditTableViewCell.m
//  UrTAdmin
//
//  Created by Alan Westbrook on 3/26/13.
//  Copyright (c) 2013 Rockwood Software. All rights reserved.
//
// Why the heck isn't this a standard control?


#import "InlineEditTableViewCell.h"

NSString* kDetailTextProperty = @"DetailText";

@implementation InlineEditTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL) shouldIndentWhileEditing
{
    return NO;
}

- (void) setEditing:(BOOL)editing_ animated:(BOOL)animated_
{
    [super setEditing: editing_
             animated: animated_];
    
    if (YES == editing_)
    {
        if (nil == self.editor)
        {
            self.editor       = [UITextField new];
            self.editor.text  = self.detailTextLabel.text;

            CGRect eframe   = self.detailTextLabel.frame;
            eframe.size     = CGSizeMake(self.contentView.frame.size.width - eframe.origin.x,
                                         [@"Xg" sizeWithFont: self.editor.font].height);
            
            self.editor.frame = eframe;
            [self.contentView addSubview: self.editor];
        }
        
        self.editor.hidden          = NO;
        self.detailTextLabel.hidden = YES;
    }
    else
    {
        if (nil != self.editor)
        {
            // The table delegate is responsible for populating our new value
            [self.delegate inlineEditTableViewCell: self
                                   propertyUpdated: kDetailTextProperty
                                             value: self.editor.text];
        }
        
        self.editor.hidden          = YES;
        self.detailTextLabel.hidden = NO;
    }

}

@end
