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
NSString* kTextProperty       = @"Text";

// So arbitrary...
static const CGFloat skLeftPadding = 6.0f;
static const CGFloat skTopPadding  = 10.0f;

@implementation InlineEditTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // This is annoying to have to do.
        _style = style;
    }
    return self;
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
        self.editor.hidden          = NO;
        
        if (self.detailTextLabel)
        {
            self.detailTextLabel.hidden = YES;
            self.editor.text = self.detailTextLabel.text;
        }
        else
        {
            self.textLabel.hidden = YES;
            self.editor.text = self.textLabel.text;
        }
    }
    else
    {
        if (nil != _editor)
        {
            // The table delegate is responsible for populating our new value
            [self.delegate inlineEditTableViewCell: self
                                   propertyUpdated: self.detailTextLabel ? kDetailTextProperty : kTextProperty
                                             value: self.editor.text];
            self.editor.hidden          = YES;
            self.detailTextLabel.hidden = NO;
            self.textLabel.hidden       = NO;
        }
    }
}

- (void) createEditor
{
    self.editor         = [UITextField new];
    
    CGRect teFrame      = self.textLabel.frame;
    
    if (nil == self.textLabel.text)
    {
        teFrame = self.contentView.frame;
        teFrame.origin = CGPointMake( skLeftPadding, skTopPadding);
        teFrame.size   = CGSizeMake( teFrame.size.width - skLeftPadding, teFrame.size.height - skTopPadding);
        
    }
    else
    {
        self.editor.text    = self.textLabel.text;
    }

    self.textLabel.text = self.editor.text;
    
    // This is lame, it would be nice to have access to the style
    
    if (self.detailTextLabel)
    {
        teFrame             = self.detailTextLabel.frame;
        teFrame.size        = CGSizeMake(self.contentView.frame.size.width - teFrame.origin.x,
                                         [@"Xg" sizeWithFont: self.editor.font].height);
        self.editor.text    = self.detailTextLabel.text;
    }
    
    self.editor.frame = teFrame;
    [self.contentView addSubview: self.editor];
}

- (UITextField*) editor
{
    if (nil == _editor)
    {
        [self createEditor];
    }
    
    return _editor;
}

@end
