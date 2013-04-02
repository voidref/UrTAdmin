//
//  InlineEditTableViewCell.h
//  UrTAdmin
//
//  Created by Alan Westbrook on 3/26/13.
//  Copyright (c) 2013 Rockwood Software. All rights reserved.
//

@class InlineEditTableViewCell;

@protocol InlineEditTableViewCellDelegate <NSObject>

// Currently only supports kDetailTextProperty. (the text value of the detail text label)
// Nomenclature is always the hardest part.
- (void) inlineEditTableViewCell: (InlineEditTableViewCell*) cell_
                 propertyUpdated: (NSString*)                property_
                           value: (NSString*)                value_;

@end

extern NSString* kDetailTextProperty;
extern NSString* kTextProperty;



@interface InlineEditTableViewCell : UITableViewCell
{
    NSInteger _style;
}

@property (strong, nonatomic)               UITextField*                        editor;
@property (weak, nonatomic)     IBOutlet    id<InlineEditTableViewCellDelegate> delegate;
@end

