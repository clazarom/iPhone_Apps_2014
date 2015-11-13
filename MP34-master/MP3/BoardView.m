//
//  BoardView.m
//  Connect4
//
//  Created by Michael Lee on 4/18/14.
//  Copyright (c) 2014 Michael Lee. All rights reserved.
//

#import "BoardView.h"

@interface BoardView ()
- (void)addSubviews;
@end

@implementation BoardView {
    NSMutableArray *_columnViews;
}

- (id)initWithFrame:(CGRect)frame slotDiameter:(double)diameter
{
    if (self = [super initWithFrame:frame]) {
        self.opaque = NO;
        _gridWidth  = self.bounds.size.width / 8;
        _gridHeight = self.bounds.size.height / 7;
        _slotDiameter = diameter;
        _columnViews = [NSMutableArray array];
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    for (int i=1; i<=7; i++) {
        UIView *columnView = [[UIView alloc] initWithFrame:CGRectMake(_gridWidth*i-_slotDiameter/2.0, 0, _slotDiameter, self.bounds.size.height)];
        columnView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(columnTapped:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        
        [columnView addGestureRecognizer:tap];
        
        [_columnViews addObject:columnView];
        [self addSubview:columnView];
    }
}

- (void)columnTapped:(UIGestureRecognizer *)gestureRecognizer
{ 
    int idx = [_columnViews indexOfObject:gestureRecognizer.view];
    [self.delegate boardView:self columnSelected:idx+1];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextAddRect(context, self.bounds);
    for (int i=1; i<=7; i++) {
        for (int j=1; j<=6; j++) {
            CGContextAddEllipseInRect(context, CGRectMake(i*_gridWidth-_slotDiameter/2.0,
                                                          j*_gridHeight-_slotDiameter/2.0,
                                                          _slotDiameter,
                                                          _slotDiameter));
        }
    }
    CGContextEOFillPath(context);
}
@end
