//
//  ViewController.h
//  SixtyGhettoNames
//
//  Created by Ben Smith on 04/10/2013.
//  Copyright (c) 2013 Ben Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) NSArray *ghettoNames;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *ghettoButtons;
@property (weak, nonatomic) IBOutlet UIScrollView *backgroundView;
@property (strong, nonatomic) UIImageView *background;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;


@end
