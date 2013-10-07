//
//  ViewController.m
//  SixtyGhettoNames
//
//  Created by Ben Smith on 04/10/2013.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import "Sound.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize ghettoNames = _ghettoNames;
@synthesize ghettoButtons = _ghettoButtons;
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"panoramicWall.jpg"];
    _background = [[UIImageView alloc]initWithImage:image];
    self.background.frame = CGRectMake(0, 0, 3000 , self.backgroundView.bounds.size.height);
    [_backgroundView addSubview:self.background];
    [_backgroundView sendSubviewToBack:self.background];
    [_backgroundView setContentSize:CGSizeMake(3000,self.view.bounds.size.height)];
    [self.view addSubview:_backgroundView];

    [self loadGhettoNames];
    [self getSoundNames];
    [self setButtons];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;

}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_ghettoNames count];

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UIButton *gb = [[UIButton alloc]init];
    CGSize theSize = [[_ghettoNames objectAtIndex:row]
                     sizeWithFont:[UIFont fontWithName:FONT_TYPE size:NAME_FONT_SIZE]
                     constrainedToSize:CGSizeMake(self.picker.frame.size.width, 30)
                     lineBreakMode:UILineBreakModeMiddleTruncation];
    CGRect aFrame = gb.frame;
    aFrame.size = theSize;
    gb.frame = aFrame;
    //[_ghettoButtons objectAtIndex:row];
    gb.tag = row;
    NSLog(@"%@",[_ghettoNames objectAtIndex:row]);
//    [gb setText:[_ghettoNames objectAtIndex:row]];
    [gb setTitle:[_ghettoNames objectAtIndex:row] forState:UIControlStateNormal];
    gb.titleLabel.font = [UIFont fontWithName:FONT_TYPE size:NAME_FONT_SIZE];
    float r = arc4random() % 12;
    [gb setTitleColor:[UIColor colorWithHue:(30*r)/360 saturation:0.5f brightness:0.8f alpha:1.0f] forState:(UIControlStateNormal)];
    [gb addTarget:self action:@selector(playSound:) forControlEvents:UIControlEventTouchUpInside];
//    gb.font = [UIFont fontWithName:FONT_TYPE size:NAME_FONT_SIZE];
//    gb.textAlignment = NSTextAlignmentCenter;
    return gb;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 320;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [[Sound retrieveSingleton] playSound:[[Sound retrieveSingleton].funnyClipsPlayer objectAtIndex:row] numberofTimes:0];
    CGSize theSize = [[_ghettoNames objectAtIndex:row] sizeWithFont:[UIFont fontWithName:FONT_TYPE size:NAME_FONT_SIZE] constrainedToSize:CGSizeMake(600, 30) lineBreakMode:UILineBreakModeMiddleTruncation];
    [pickerView viewForRow:row forComponent:0].frame = CGRectMake(0, 100,theSize.width,theSize.height);
    UIButton *temp = [[UIButton alloc]init];
    [temp addTarget:self action:@selector(playSound:) forControlEvents:UIControlEventTouchUpInside];
    temp.showsTouchWhenHighlighted = YES;

    [temp addSubview:[pickerView viewForRow:row forComponent:0]];
    [self.view addSubview:temp];
//    [_ghettoNames removeObjectAtIndex:row];
//    [pickerView reloadComponent:0];
}

-(void)setButtons{
    int count = 0;
    for (int i = 0; i < [_ghettoButtons count]; i++) {
        UIButton *gb = [_ghettoButtons objectAtIndex:i];
        CGSize theSize = [[_ghettoNames objectAtIndex:count] sizeWithFont:[UIFont fontWithName:FONT_TYPE size:NAME_FONT_SIZE] constrainedToSize:CGSizeMake(600, 30) lineBreakMode:UILineBreakModeMiddleTruncation];

        gb.tag = count;
        float r = arc4random() % 12;
        [gb setTitleColor:[UIColor colorWithHue:(30*r)/360 saturation:1.0f brightness:1.0f alpha:1.0f] forState:(UIControlStateNormal)];
        [gb setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];


//        [gb setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
        NSLog(@"%@",[_ghettoNames objectAtIndex:count]);
        [gb setTitle:[_ghettoNames objectAtIndex:count] forState:UIControlStateNormal];
        gb.showsTouchWhenHighlighted = YES;
        [gb setTitleShadowColor:[UIColor redColor] forState:UIControlStateNormal];
        CGRect aFrame = gb.frame;
        aFrame.size = theSize;
        gb.frame = aFrame;


        gb.titleLabel.font = [UIFont fontWithName:FONT_TYPE size:NAME_FONT_SIZE];
        gb.titleLabel.textAlignment = NSTextAlignmentCenter;
        [gb addTarget:self action:@selector(playSound:) forControlEvents:UIControlEventTouchUpInside];
        count++;
        [gb removeFromSuperview];
        [self.backgroundView addSubview:gb];

    }
    
}


-(NSArray*)loadGhettoNames{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"GhettoNames"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    _ghettoNames = [[NSMutableArray alloc]initWithArray:[content componentsSeparatedByString:@"\n"]];
    NSLog(@"%@",_ghettoNames);
    NSArray *names = [[_ghettoNames reverseObjectEnumerator] allObjects];
    _ghettoNames = [[NSMutableArray alloc]initWithArray:names];
    return _ghettoNames;
}

-(void)getSoundNames{
    NSError *error = nil;
    
    NSString *yourFolderPath = [[NSBundle mainBundle] resourcePath];
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:yourFolderPath error:&error];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.mp3'"];
    NSArray *onlyMP3s = [dirContents filteredArrayUsingPredicate:fltr];

//    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:@selector(localizedCompare:)];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"integerValue" ascending:YES];

    NSArray* sortedArray = [onlyMP3s sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    [[Sound retrieveSingleton] initWithSounds:sortedArray];

    NSLog(@"%@",sortedArray);
}

-(void)playSound:(id)sender
{
    UIButton *buttonPressed = (UIButton*)sender;
    int tag = buttonPressed.tag;
    NSLog(@"%i",tag);
    [[Sound retrieveSingleton] playSound:[[Sound retrieveSingleton].funnyClipsPlayer objectAtIndex:tag] numberofTimes:0];

}

@end
