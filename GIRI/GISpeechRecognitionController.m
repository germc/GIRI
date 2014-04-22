//
//  GISpeechRecognitionController.m
//  GIRI
//
//  Created by Jason Hurt on 4/21/14.
//  Copyright (c) 2014 8byte8. All rights reserved.
//

#import "GISpeechRecognitionController.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "NSData+Godzippa.h"

@implementation GISpeechRecognitionController
{
    AFHTTPClient *_httpClient;
    NSOperationQueue *_operationQueue;
}

//singleton
+ (GISpeechRecognitionController*)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static GISpeechRecognitionController *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[GISpeechRecognitionController alloc] init];
        
    });
    return shared;
}

- (id)init {
    self = [super init];
    if (self) {
        _httpClient =  [[AFHTTPClient alloc] init];
        _operationQueue = [[NSOperationQueue alloc] init];
        _operationQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)googleSpeechRecognizeFiles:(NSMutableArray*)flacFiles currentText:(NSMutableString*)text onComplete:(void (^)(NSString* text, NSError *error))onComplete {
    if(flacFiles.count == 0) {
        if(text.length > 0) {
            onComplete(text, nil);
        }
        else {
            NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:@"received an empty response from the Google's speech API", NSLocalizedDescriptionKey, nil];
            onComplete(nil, [NSError errorWithDomain:@"GIRI" code:0 userInfo:errorDict]);
        }
    }
    else {
        NSString *flacFileToRecognize = [flacFiles objectAtIndex:0];
        [flacFiles removeObjectAtIndex:0];
        NSData *soundData = [[NSData alloc] initWithContentsOfFile:flacFileToRecognize];
        if(soundData.length > 0) {
            //NSData *compressed = [soundData dataByGZipCompressingWithError:nil];
            
            NSMutableURLRequest *request =
            [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=en-US"]];
            [request setHTTPMethod:@"POST"];
            //[request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
            [request setValue:@"audio/x-flac; rate=44100" forHTTPHeaderField:@"Content-type"];
            [request setHTTPBody:soundData];
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSArray *hypotheses = [JSON objectForKey:@"hypotheses"];
                if(hypotheses.count > 0) {
                    //get the first one
                    NSDictionary *hypothesis = [hypotheses objectAtIndex:0];
                    NSString *utterance = [hypothesis objectForKey:@"utterance"];
                    [text appendFormat:@" %@", utterance];
                }
                
                //recurse
                [self googleSpeechRecognizeFiles:flacFiles currentText:text onComplete:onComplete];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                
                //recurse
                [self googleSpeechRecognizeFiles:flacFiles currentText:text onComplete:onComplete];
            }];
            [_operationQueue addOperation:operation];
        }
        else {
            //recurse
            [self googleSpeechRecognizeFiles:flacFiles currentText:text onComplete:onComplete];
        }
    }
}


@end
