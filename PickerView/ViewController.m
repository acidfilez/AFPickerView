//
//  ViewController.m
//  PickerView
//
//  Created by Fraerman Arkady on 24.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    daysData = [[NSArray alloc] initWithObjects:@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday", nil];
    
    //First Example
    defaultPickerView = [[AFPickerView alloc] initWithFrame:
                         CGRectMake(30.0, 30.0, 126.0, 197.0)];
    defaultPickerView.dataSource = self;
    defaultPickerView.delegate = self;
    [defaultPickerView reloadData];
    
    //Second Example
    daysPickerView = [[AFPickerView alloc] initWithFrame:CGRectMake(30.0, 250.0, 126.0, 197.0)];
    daysPickerView.dataSource = self;
    daysPickerView.delegate = self;
    daysPickerView.rowFont = [UIFont boldSystemFontOfSize:19.0];
    daysPickerView.rowIndentLeft = 10.0;
    [daysPickerView reloadData];
    
    
    //Third Example
    UIImage *backImage = [[UIImage imageNamed:@"pickerBackgroundCustom"]
                          resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
    
    UIImage *glassImage = [[UIImage imageNamed:@"pickerGlassCustom"]
                           resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    
    int visibleRows = 5;
    
    //Set height depening of the glass and visible picker rows
    CGRect framePicker = CGRectMake(30.0, 470.0, 70.0, glassImage.size.height * visibleRows);
    
    defaultPickerCustomView = [[AFPickerView alloc] initWithFrameCustom:framePicker
                                                              backImage:backImage
                                                            shadowImage:nil
                                                             glassImage:glassImage];
    
    defaultPickerCustomView.dataSource = self;
    defaultPickerCustomView.delegate = self;
    
    defaultPickerCustomView.rowFont = [UIFont boldSystemFontOfSize:12.0];
    defaultPickerCustomView.rowTextColor = [UIColor grayColor];
    defaultPickerCustomView.rowTextAlign = NSTextAlignmentCenter;
    [defaultPickerCustomView reloadData];
    
    
    //Four Exampe - Time
    visibleRows = 3;
    UIImage *glassImage2 = [[UIImage imageNamed:@"pickerGlass2Custom"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
    //timeView is behind the pickers.
    UIImageView *timeView = [[UIImageView alloc] initWithImage:backImage];
    timeView.frame = CGRectMake(29, 690, 69, glassImage2.size.height * visibleRows);
    
    CGRect frameHourPicker = CGRectMake(30, 690, 40.0, glassImage2.size.height * visibleRows);
    CGRect frameMinutePicker = CGRectMake(67, 690, 30.0, glassImage2.size.height * visibleRows);
    
    hourPickerCustomView = [[AFPickerView alloc] initWithFrameCustom:frameHourPicker
                                                           backImage:nil
                                                         shadowImage:nil
                                                          glassImage:glassImage2];
    
    hourPickerCustomView.dataSource = self;
    hourPickerCustomView.delegate = self;
    
    hourPickerCustomView.rowFont = [UIFont boldSystemFontOfSize:14.0];
    hourPickerCustomView.rowTextColor = [UIColor grayColor];
    hourPickerCustomView.rowTextAlign = NSTextAlignmentRight;
    [hourPickerCustomView reloadData];
    
    
    minutePickerCustomView = [[AFPickerView alloc] initWithFrameCustom:frameMinutePicker
                                                             backImage:nil
                                                           shadowImage:nil
                                                            glassImage:glassImage2];
    
    minutePickerCustomView.dataSource = self;
    minutePickerCustomView.delegate = self;
    
    minutePickerCustomView.rowFont = [UIFont boldSystemFontOfSize:14.0];
    minutePickerCustomView.rowTextColor = [UIColor grayColor];
    minutePickerCustomView.rowTextAlign = NSTextAlignmentLeft;
    [minutePickerCustomView reloadData];
    
    
    
    //Fifth Example, resizable default
    UIImage *backImage3 = [[UIImage imageNamed:@"pickerBackground"]
                           resizableImageWithCapInsets:UIEdgeInsetsMake(62, 5, 62, 5)];
    
    UIImage *shadowImage3 = [[UIImage imageNamed:@"pickerShadows"]
                             resizableImageWithCapInsets:UIEdgeInsetsMake(62, 5, 62, 5)];
    
    
    UIImage *glassImage3 = [[UIImage imageNamed:@"pickerGlass"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(20, 5, 20, 5)];
    
    glassImage3 = [ViewController imageWithImage:glassImage3 scaledToSize:CGSizeMake(63, 24)];
    
    visibleRows = 5;
    
    //Set height depening of the glass and visible picker rows
    CGRect framePicker3 = CGRectMake(30.0, 800.0, 70.0, glassImage3.size.height * visibleRows);
    
    defaultPickerViewResize = [[AFPickerView alloc] initWithFrameCustom:framePicker3
                                                              backImage:backImage3
                                                            shadowImage:shadowImage3
                                                             glassImage:glassImage3];
    
    defaultPickerViewResize.dataSource = self;
    defaultPickerViewResize.delegate = self;
    
    defaultPickerViewResize.rowFont = [UIFont boldSystemFontOfSize:12.0];
    defaultPickerViewResize.rowTextColor = [UIColor blackColor];
    defaultPickerViewResize.rowTextAlign = NSTextAlignmentCenter;
    [defaultPickerViewResize reloadData];
    
    
    
    //////////////////////////////////////////////////////////////////////////////////////////
    //Add Pickers to view
    
    [_scroll addSubview:defaultPickerView];
    [_scroll addSubview:daysPickerView];
    [_scroll addSubview:defaultPickerCustomView];
    
    
    [_scroll addSubview:timeView];
    [_scroll addSubview:hourPickerCustomView];
    [_scroll addSubview:minutePickerCustomView];
    
    
    [_scroll addSubview:defaultPickerViewResize];
    
    [self setups];
}


//move things around the xib. internal use only
-(void)setups{
    //Setting for the scrollbar
    //make room for third example
    _scroll.contentSize = CGSizeMake(320, 1200);
    
    //move scroll to middle to see other examples
    [_scroll scrollRectToVisible:CGRectMake(0.0, 570, 1, 1) animated:YES];
    
    //Reposition Labels
    _numberLabel.frame = CGRectMake(180.0, defaultPickerView.frame.origin.y + 100.0, 134.0, 21);
    _dayLabel.frame = CGRectMake(180.0, daysPickerView.frame.origin.y + 100.0, 134.0, 21);
    _numberCustomLabel.frame = CGRectMake(180, defaultPickerCustomView.frame.origin.y  + defaultPickerCustomView.frame.size.height / 2, 134.0, 21.0);
    
    _timeLabel.frame = CGRectMake(180, minutePickerCustomView.frame.origin.y  + minutePickerCustomView.frame.size.height / 2, 134.0, 21.0);
    
}


#pragma mark - AFPickerViewDataSource

- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView
{
    //Day Picker
    if (pickerView == daysPickerView)
        return [daysData count];
    
    
    //Time Pickers
    if (pickerView == hourPickerCustomView)
        return 24;
    
    if (pickerView == minutePickerCustomView)
        return 60;
    
    //Numbers pickers
    return 30;
}




- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row
{
    if (pickerView == daysPickerView)
        return [daysData objectAtIndex:row];
    
    if (pickerView == defaultPickerView)
        return [NSString stringWithFormat:@"%i", row + 1];
    
    if (pickerView == defaultPickerCustomView)
        return [NSString stringWithFormat:@"%i", row + 1];
    
    if (pickerView == defaultPickerViewResize)
        return [NSString stringWithFormat:@"%i", row + 1];
    
    
    //Time Pickers
    if (pickerView == hourPickerCustomView){
        NSLog(@"housrs moved");
        return [NSString stringWithFormat:@"%i : ", row + 1];
    }
    
    if (pickerView == minutePickerCustomView)
        return [NSString stringWithFormat:@" %i", row + 1];
    
    return @"N/A";
}




#pragma mark - AFPickerViewDelegate

- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row
{
    if (pickerView == daysPickerView)
        self.dayLabel.text = [daysData objectAtIndex:row];
    
    if (pickerView == defaultPickerCustomView)
        self.numberCustomLabel.text = [NSString stringWithFormat:@"%i", row + 1];
    
    if (pickerView == defaultPickerView)
        self.numberLabel.text = [NSString stringWithFormat:@"%i", row + 1];
    
    if (pickerView == defaultPickerViewResize)
        self.numberLabel.text = [NSString stringWithFormat:@"%i", row + 1];
    
    
    //Time Picker
    if (pickerView == minutePickerCustomView || pickerView == hourPickerCustomView )
        self.timeLabel.text = [NSString stringWithFormat:@"It's: %i:%i hrs",
                               [hourPickerCustomView selectedRow] + 1,
                               [minutePickerCustomView selectedRow] + 1 ];
    
    
}




#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}




- (void)viewDidUnload
{
    [self setNumberLabel:nil];
    [self setNumberCustomLabel:nil];
    [self setDayLabel:nil];
    [self setScroll:nil];
    [self setTimeLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
