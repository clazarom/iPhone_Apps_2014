//
//  BoardView.h
//  Connect4
//
//  Created by Michael Lee on 4/18/14.
//  Copyright (c) 2014 Michael Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BoardViewDelegate;

@interface BoardView : UIView
@property (readonly) double gridWidth;
@property (readonly) double gridHeight;
@property (readonly) double slotDiameter;
@property (strong) id<BoardViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame slotDiameter:(double)diameter;
@end

@protocol BoardViewDelegate <NSObject>
- (void)boardView:(BoardView *)boardView columnSelected:(int)column;
@end