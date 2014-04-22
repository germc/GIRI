#import "GIRI.h"
#include "wav_to_flac.h"
#import "GISpeechRecognitionController.h"

@implementation GIRI

+ (void)recognizeSpeech:(NSString*)wavFile durationPerFile:(NSInteger)durationPerFile onComplete:(void (^)(NSString* text, NSError *error))onComplete {
    const char *wave_file = [wavFile UTF8String];
    
    //convert to FLAC
    NSString *flacFileWithoutExtension = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp"];
    char** flac_files = (char**) malloc(sizeof(char*) * 1024);
    for(int i = 0; i < 1024; i++) {
        *(flac_files+i) = NULL;
    }
    int conversionResult = convertWavToFlac(wave_file, [flacFileWithoutExtension UTF8String], 20, flac_files);
    
    if(conversionResult == 0) {
        //convert the output files to an array of strings
        NSMutableArray *flacFilesOut = [NSMutableArray array];
        for(int i = 0; i < 1024; i++) {
            char *out_file = *(flac_files+i);
            if(out_file == NULL) {
                break;
            }
            [flacFilesOut addObject:[NSString stringWithUTF8String:out_file]];
            free(out_file);
        }

        GISpeechRecognitionController *speechRecognitionController = [GISpeechRecognitionController sharedInstance];
        [speechRecognitionController googleSpeechRecognizeFiles:flacFilesOut currentText:[[NSMutableString alloc] init] onComplete:^(NSString *text, NSError *error) {
            onComplete(text, error);
        }];
    }
    else {
        NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Error converting wave file to flac file", NSLocalizedDescriptionKey, nil];
        onComplete(nil, [NSError errorWithDomain:@"GIRI" code:0 userInfo:errorDict]);
    }
}

+ (void)recognizeSpeech:(NSString*)wavFile onComplete:(void (^)(NSString* text, NSError *error))onComplete {
    [GIRI recognizeSpeech:wavFile durationPerFile:20 onComplete:onComplete];
}


@end