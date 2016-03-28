//
//  StoryPartViewController.m
//  W3D5AVStorybook
//
//  Created by Karlo Pagtakhan on 03/26/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

#import "StoryPartViewController.h"
#import "SinglePageData.h"

@import AVFoundation;
@import AVKit;


@interface StoryPartViewController()<UIImagePickerControllerDelegate,AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@end

@implementation StoryPartViewController
static int totalCount;

-(void)viewDidLoad{
  [self.imageView setImage: self.dataObject.image];

  //[self prepareAudioRecorder];
  [self prepareAudioPlayer];
  
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
  [self.imageView setUserInteractionEnabled: YES];
  [self.imageView addGestureRecognizer:tapGestureRecognizer];
}
-(void)viewWillDisappear:(BOOL)animated{
  [self.audioRecorder stop];
  [self.audioPlayer stop];
}

//MARK: Image methods
- (IBAction)cameraButtonClicked:(id)sender {
  NSLog(@"Camera clicked");
  
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
  imagePicker.delegate = self;
  
  //Show an action with Camera and Photo library upload
  UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select image" message:@"Select source" preferredStyle:UIAlertControllerStyleActionSheet];
  UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:nil];
  }];

  UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Photo Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
  }];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    [actionSheet dismissViewControllerAnimated:YES completion:nil];
  }];

  //Disable source type if it is not available
  if ( ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
    cameraAction.enabled = NO;
  }
  [actionSheet addAction:cameraAction];
  
  if ( ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
    libraryAction.enabled = NO;
  }
  [actionSheet addAction:libraryAction];
  
  [actionSheet addAction:cancelAction];
  
  //Display alert controller
  [self presentViewController:actionSheet animated:YES completion:nil];
  
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
  self.dataObject.image = info[@"UIImagePickerControllerOriginalImage"];
  [self.imageView setImage: self.dataObject.image];
  [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
  [self dismissViewControllerAnimated:YES completion:nil];
}

//MARK: Recording Audio methods
- (IBAction)microphoneButtonClicked:(id)sender {
  NSLog(@"Microphone clicked");
  [self prepareAudioRecorder];
  
  if(!self.audioRecorder.recording){
    NSLog(@"Start recording");
    [self.audioRecorder record];
  } else{
    NSLog(@"Stop recording");
    [self.audioRecorder stop];
    [self saveRecordedAudio];
  }
  
}
-(void) prepareAudioRecorder{
  if (self.audioRecorder == nil){
    
    NSArray *folderPathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *folderPath = folderPathArray[0];
    NSString *saveAudioTo = [NSString stringWithFormat:@"%@/test%d.m4a",folderPath,totalCount];
    NSURL *saveToURL = [NSURL fileURLWithPath:saveAudioTo];
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    if (self.dataObject.audioURL == nil){
      self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:saveToURL settings:recordSetting error:nil];
    } else {
      self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:self.dataObject.audioURL settings:recordSetting error:nil];
    }
    self.audioRecorder.delegate = self;
    self.audioRecorder.meteringEnabled = YES;
    
    [self.audioRecorder prepareToRecord];
  }
}
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
  if (flag) {
    NSLog(@"Finished recording");
  }
}
-(void)saveRecordedAudio{
  self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.audioRecorder.url error:nil];
  self.dataObject.audioURL = self.audioRecorder.url;
  self.audioRecorder = nil;
}

//MARK: Playing Audio methods
-(void) prepareAudioPlayer{
  if (self.dataObject.audioURL != nil){
    if (self.audioPlayer == nil){
      self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.dataObject.audioURL error:nil];
    } else {
      self.audioPlayer = [self.audioPlayer initWithContentsOfURL:self.dataObject.audioURL error:nil];
    }
    [self.audioPlayer prepareToPlay];
    self.audioPlayer.meteringEnabled = YES;
    
    NSLog(@"Instantiate Player");
    NSLog(@"Using file %@", self.audioPlayer.url);
  } else{
    NSLog(@"No audio currently saved");
  }
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
  if (flag) {
    NSLog(@"Finished playing");
  }
}


//MARK: Gestures
-(void)imageTapped:(UITapGestureRecognizer *)recognizer{
  if (recognizer.state == UIGestureRecognizerStateEnded) {
    [self prepareAudioPlayer];
    
    if (!self.audioPlayer.playing) {
      NSLog(@"Play audio");
      [self.audioPlayer play];
    } else{
      NSLog(@"Stop audio");
      [self.audioPlayer stop];
    }
  }
}

//MARK: Helper methods
-(void)setDataObject:(SinglePageData *)dataObject{
  _dataObject = dataObject;
  if (self.imageView == nil){
    self.imageView = [[UIImageView alloc] init];
  }
  [self.imageView setImage: dataObject.image];
  
  [self prepareAudioPlayer];
}




@end
