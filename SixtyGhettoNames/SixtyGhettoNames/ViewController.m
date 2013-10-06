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
    // 1
    UIImage *image = [UIImage imageNamed:@"graffitiWall.jpg"];
    _background = [[UIImageView alloc]initWithImage:image];
    self.background.frame = CGRectMake(0, 0, 3000 , self.view.bounds.size.height);
    [_backgroundView addSubview:self.background];
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
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}

-(void)setButtons{
    int count = 0;
    for (int i = 0; i < [_ghettoButtons count]; i++) {
        UIButton *gb = [_ghettoButtons objectAtIndex:i];
        CGSize theSize = [[_ghettoNames objectAtIndex:count] sizeWithFont:[UIFont fontWithName:FONT_TYPE size:NAME_FONT_SIZE] constrainedToSize:CGSizeMake(self.view.frame.size.width, 30) lineBreakMode:UILineBreakModeMiddleTruncation];

        gb.tag = count;
        [gb setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
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
//        [gb removeFromSuperview];
//        [self.backgroundView addSubview:gb];

    }
    
}


-(NSArray*)loadGhettoNames{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"GhettoNames"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    _ghettoNames = [[NSArray alloc]initWithArray:[content componentsSeparatedByString:@"\n"]];
    NSLog(@"%@",_ghettoNames);
    _ghettoNames = [[_ghettoNames reverseObjectEnumerator] allObjects];


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
