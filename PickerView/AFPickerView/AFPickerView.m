//
//  AFPickerView.m
//  PickerView
//
//  Created by Fraerman Arkady on 24.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AFPickerView.h"

@implementation AFPickerView

#pragma mark - Synthesization

@synthesize dataSource;
@synthesize delegate;
@synthesize selectedRow = currentRow;
@synthesize rowFont = _rowFont;
@synthesize rowTextColor = _rowTextColor;
@synthesize rowTextAlign = _rowTextAlign;
@synthesize rowIndentLeft = _rowIndentLeft;
@synthesize rowIndentTop = _rowIndentTop;
//@synthesize rowHeight = _rowHeight;


#pragma mark - Custom getters/setters

- (void)setSelectedRow:(int)selectedRow
{
    if (selectedRow >= rowsCount)
        return;
    
    currentRow = selectedRow;
    [contentView setContentOffset:CGPointMake(0.0, _rowHeight * currentRow) animated:NO];
}




- (void)setRowFont:(UIFont *)rowFont
{
    _rowFont = rowFont;
    
    for (UILabel *aLabel in visibleViews)
    {
        aLabel.font = _rowFont;
    }
    
    for (UILabel *aLabel in recycledViews)
    {
        aLabel.font = _rowFont;
    }
}


- (void)setRowTextColor:(UIColor *)rowTextColor
{
    _rowTextColor = rowTextColor;
    
    for (UILabel *aLabel in visibleViews)
    {
        aLabel.textColor = _rowTextColor;
    }
    
    for (UILabel *aLabel in recycledViews)
    {
        aLabel.textColor = _rowTextColor;
    }
}


- (void)setRowTextAlign:(NSTextAlignment *)rowTextAlign
{
    _rowTextAlign = rowTextAlign;
    
    for (UILabel *aLabel in visibleViews)
    {
        aLabel.textAlignment = _rowTextAlign;
    }
    
    for (UILabel *aLabel in recycledViews)
    {
        aLabel.textAlignment = _rowTextAlign;
    }
}


- (void)setRowIndentLeft:(CGFloat)rowIndentLeft
{
    _rowIndentLeft = rowIndentLeft;
    
    for (UILabel *aLabel in visibleViews)
    {
        CGRect frame = aLabel.frame;
        frame.origin.x = _rowIndentLeft;
        frame.size.width = self.frame.size.width - _rowIndentLeft;
        aLabel.frame = frame;
    }
    
    for (UILabel *aLabel in recycledViews)
    {
        CGRect frame = aLabel.frame;
        frame.origin.x = _rowIndentLeft;
        frame.size.width = self.frame.size.width - _rowIndentLeft;
        aLabel.frame = frame;
    }
}


- (void)setRowIndentTop:(CGFloat)rowIndentTop
{
    _rowIndentTop = rowIndentTop;
    
    for (UILabel *aLabel in visibleViews)
    {
        CGRect frame = aLabel.frame;
        frame.origin.y = _rowIndentTop;
        frame.size.height = self.frame.size.height - _rowIndentTop;
        aLabel.frame = frame;
    }
    
    for (UILabel *aLabel in recycledViews)
    {
        CGRect frame = aLabel.frame;
        frame.origin.y = _rowIndentTop;
        frame.size.height = self.frame.size.height - _rowIndentTop;
        aLabel.frame = frame;
    }
}


//- (void)setMiddleRowAtIndex:(int)middleRowAtIndex
//{
//    middleRowAtIndex = middleRowAtIndex;
//}


#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // setup
        [self setup];
        
        // backgound
        UIImageView *bacground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pickerBackground.png"]];
        [self addSubview:bacground];
        
        // content
        contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        contentView.showsHorizontalScrollIndicator = NO;
        contentView.showsVerticalScrollIndicator = NO;
        contentView.delegate = self;
        [self addSubview:contentView];
        
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [contentView addGestureRecognizer:tapRecognizer];
        
        
        // shadows
        UIImageView *shadows = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pickerShadows.png"]];
        [self addSubview:shadows];
        
        // glass
        UIImage *glassImage = [UIImage imageNamed:@"pickerGlass.png"];
        glassImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 76.0, glassImage.size.width, glassImage.size.height)];
        glassImageView.image = glassImage;
        [self addSubview:glassImageView];
    }
    return self;
}


//Use a resizble image with insets, height must be of correct size,
//if glass is 29pixel, then set height as 29*number of rows
- (id) initWithFrameCustom:(CGRect)frame
                 backImage:(UIImage *)backImage
               shadowImage:(UIImage *)shadowImage
                glassImage:(UIImage *)glassImage
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // setup
        [self setupCustom];
        
        
        _rowHeight = glassImage.size.height;
        
        NSAssert(_rowHeight,
                 @"GlassImage Cant be Nill, Use transparent Glass to get and use as the height of the row");
        
        NSAssert(( (int)frame.size.height % (int)glassImage.size.height == 0),
                 @"Warning Oddity: Try using frame height as a multiple of glass image height");
        

        
        
        
        middleRowAtIndex = (frame.size.height / _rowHeight) / 2;
        
        CGRect tmpFrame;
        
        UIImageView *bacground = [[UIImageView alloc] initWithImage:backImage];
        
        //Move backgroundimage
        tmpFrame = frame;
        tmpFrame.origin.x = 0;
        tmpFrame.origin.y = 0;
        bacground.frame = tmpFrame;
        
        [self addSubview:bacground];
        
        // content
        contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        contentView.showsHorizontalScrollIndicator = NO;
        contentView.showsVerticalScrollIndicator = NO;
        contentView.delegate = self;
        [self addSubview:contentView];
        
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [contentView addGestureRecognizer:tapRecognizer];
        
        
        UIImageView *shadows = [[UIImageView alloc] initWithImage:shadowImage];
        
        tmpFrame = frame;
        tmpFrame.origin.x = 0;
        tmpFrame.origin.y = 0;
        
        shadows.frame = tmpFrame;
        
        [self addSubview:shadows];
        
        
        UIImageView *glass = [[UIImageView alloc] initWithImage:glassImage];
        
        tmpFrame = frame;
        tmpFrame.origin.x = 0;
        tmpFrame.origin.y = middleRowAtIndex * _rowHeight;
        tmpFrame.size.height = _rowHeight;
        
        glass.frame = tmpFrame;
        
        [self addSubview:glass];
        
    }
    return self;
}

- (void)setupCustom
{
    _rowFont = [UIFont boldSystemFontOfSize:0.0];
    _rowTextColor = [UIColor clearColor];
    _rowTextAlign = NSTextAlignmentLeft;
    
    _rowIndentLeft = 0.0;
    _rowIndentTop = 0.0;
    
    middleRowAtIndex = 0;
    
    currentRow = 0;
    rowsCount = 0;
    
    visibleViews = [[NSMutableSet alloc] init];
    recycledViews = [[NSMutableSet alloc] init];
}

- (void)setup
{
    _rowFont = [UIFont boldSystemFontOfSize:24.0];
    _rowTextColor = RGBACOLOR(0.0, 0.0, 0.0, 0.75);
    _rowTextAlign = NSTextAlignmentLeft;
    
    _rowIndentLeft = 30.0;
    _rowIndentTop = 0.0;
    _rowHeight = 39.0;
    
    middleRowAtIndex = 2;
    
    currentRow = 0;
    rowsCount = 0;
    
    visibleViews = [[NSMutableSet alloc] init];
    recycledViews = [[NSMutableSet alloc] init];
}




#pragma mark - Buisness

- (void)reloadData
{
    // empry views
    currentRow = 0;
    rowsCount = 0;
    
    for (UIView *aView in visibleViews)
        [aView removeFromSuperview];
    
    for (UIView *aView in recycledViews)
        [aView removeFromSuperview];
    
    visibleViews = [[NSMutableSet alloc] init];
    recycledViews = [[NSMutableSet alloc] init];
    
    rowsCount = [dataSource numberOfRowsInPickerView:self];
    [contentView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
    
    //empty cells = visible cells - selected cell
    int total = self.frame.size.height /_rowHeight - 1;

    //total rows + empty cells.
    float scrollHeight = (_rowHeight * rowsCount) + (total * _rowHeight);
    
    
    contentView.contentSize = CGSizeMake(contentView.frame.size.width, scrollHeight);
    
    [self tileViews];
}




- (void)determineCurrentRow
{
    CGFloat delta = contentView.contentOffset.y;
    int position = round(delta / _rowHeight);
    currentRow = position;
    [contentView setContentOffset:CGPointMake(0.0, _rowHeight * position) animated:YES];
    [delegate pickerView:self didSelectRow:currentRow];
}




- (void)didTap:(id)sender
{
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    CGPoint point = [tapRecognizer locationInView:self];
    int steps = floor(point.y / _rowHeight) - middleRowAtIndex;
    [self makeSteps:steps];
}




- (void)makeSteps:(int)steps
{
    if (steps == 0 || steps > middleRowAtIndex || steps < -middleRowAtIndex)
        return;
    
    [contentView setContentOffset:CGPointMake(0.0, _rowHeight * currentRow) animated:NO];
    
    int newRow = currentRow + steps;
    if (newRow < 0 || newRow >= rowsCount)
    {
        if (steps == -middleRowAtIndex)
            [self makeSteps:-1];
        else if (steps == middleRowAtIndex)
            [self makeSteps:1];
        
        return;
    }
    
    currentRow = currentRow + steps;
    [contentView setContentOffset:CGPointMake(0.0, _rowHeight * currentRow) animated:YES];
    [delegate pickerView:self didSelectRow:currentRow];
}




#pragma mark - recycle queue

- (UIView *)dequeueRecycledView
{
	UIView *aView = [recycledViews anyObject];
	
    if (aView)
        [recycledViews removeObject:aView];
    return aView;
}



- (BOOL)isDisplayingViewForIndex:(NSUInteger)index
{
	BOOL foundPage = NO;
    for (UIView *aView in visibleViews)
	{
        int viewIndex = aView.frame.origin.y / _rowHeight - middleRowAtIndex; //mch
        if (viewIndex == index)
		{
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}




- (void)tileViews
{
    // Calculate which pages are visible
    CGRect visibleBounds = contentView.bounds;
    int firstNeededViewIndex = floorf(CGRectGetMinY(visibleBounds) / _rowHeight) - middleRowAtIndex;
    int lastNeededViewIndex  = floorf((CGRectGetMaxY(visibleBounds) / _rowHeight)) - middleRowAtIndex;
    firstNeededViewIndex = MAX(firstNeededViewIndex, 0);
    lastNeededViewIndex  = MIN(lastNeededViewIndex, rowsCount - 1);
	
    // Recycle no-longer-visible pages
	for (UIView *aView in visibleViews)
    {
        int viewIndex = aView.frame.origin.y / _rowHeight - middleRowAtIndex;
        if (viewIndex < firstNeededViewIndex || viewIndex > lastNeededViewIndex)
        {
            [recycledViews addObject:aView];
            [aView removeFromSuperview];
        }
    }
    
    [visibleViews minusSet:recycledViews];
    
    // add missing pages
	for (int index = firstNeededViewIndex; index <= lastNeededViewIndex; index++)
	{
        if (![self isDisplayingViewForIndex:index])
		{
            UILabel *label = (UILabel *)[self dequeueRecycledView];
            
			if (label == nil)
            {
				label = [[UILabel alloc] initWithFrame:CGRectMake(_rowIndentLeft, _rowIndentTop, self.frame.size.width - _rowIndentLeft, _rowHeight + _rowIndentTop)];
                label.backgroundColor = [UIColor clearColor];
                label.font = self.rowFont;
                label.textColor = self.rowTextColor;
                label.textAlignment = self.rowTextAlign;
            }
            
            [self configureView:label atIndex:index];
            [contentView addSubview:label];
            [visibleViews addObject:label];
        }
    }
}




- (void)configureView:(UIView *)view atIndex:(NSUInteger)index
{
    UILabel *label = (UILabel *)view;
    label.text = [dataSource pickerView:self titleForRow:index];
    CGRect frame = label.frame;
    
    
    frame.origin.y = _rowHeight * index + (_rowHeight * middleRowAtIndex);
    label.frame = frame;
   
}




#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tileViews];
}




- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
        [self determineCurrentRow];
}




- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self determineCurrentRow];
}

@end
