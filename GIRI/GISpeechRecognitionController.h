//
//  GISpeechRecognitionController.h
//  GIRI
//
//  Created by Jason Hurt on 4/21/14.
//  Copyright (c) 2014 8byte8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GISpeechRecognitionController : NSObject

+ (GISpeechRecognitionController*)sharedInstance;

- (void)googleSpeechRecognizeFiles:(NSMutableArray*)flacFiles currentText:(NSMutableString*)text onComplete:(void (^)(NSString* text, NSError *error))onComplete;

@end
