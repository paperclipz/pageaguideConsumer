#import "ConnectionManager.h"
//#import "NSArray+JSON.h"
#import "AFNetworking.h"
#import "ConnectionHelper.h"


//#define SERVER_PATH_LIVE @"vmi85167.contabo.host:8080/beep-server/rest"

#define SERVER_PATH_LIVE @"ec2-52-221-241-109.ap-southeast-1.compute.amazonaws.com/beep-server/rest"


#define Header_X_Auth @"X-Authorization"
@interface ConnectionManager()
{
    BOOL isForceUpdatePrompt;
}

@property (strong, nonatomic) DataManager *dataManager;
@property(strong,nonatomic)AFHTTPSessionManager* manager;
@property(strong,nonatomic)ConnectionHelper* connHelper;


@end

@implementation ConnectionManager

#pragma mark - Initialization
+ (id)Instance {
    static ConnectionManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        
    });
    return instance;
}

-(id)init
{
    self = [super init];
    
    self.dataManager = [DataManager Instance];
    self.connHelper = [ConnectionHelper new];
    self.serverPath = SERVER_PATH_LIVE;
    
    return self;
}

-(AFHTTPSessionManager*)manager
{
    
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        _manager.securityPolicy.allowInvalidCertificates = YES;
        
        _manager.securityPolicy.validatesDomainName = NO;
        
        _manager.responseSerializer =[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",nil];
        
    }
    
    return _manager;
    
}

-(AFHTTPSessionManager*)createNewDataManager
{
    
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        _manager.securityPolicy.allowInvalidCertificates = YES;
        
        _manager.securityPolicy.validatesDomainName = NO;
        
        _manager.responseSerializer =[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",nil];
        
    }
    
    return _manager;
    
}

+(DataManager*)dataManager
{
    return [[ConnectionManager Instance] dataManager];
}


#pragma mark - Connection Checking
+(BOOL)isNetworkAvailable
{
    
    BOOL isReachable = [AFNetworkReachabilityManager sharedManager].reachable;
    
    
    return isReachable;
}


+(NSString*)getServerPath
{
    return [[ConnectionManager Instance]serverPath];
}

-(NSString*)serverPath
{
    return SERVER_PATH_LIVE;

}


//-(BOOL)isSimulatedRequest:(ServerRequestType)serverType fullURL:(NSString*)fullURL SuccessBlock:(IDBlock)success ErrorBlock:(IErrorBlock)failure
//{
//    
//    BOOL isSimulated = false;
//
//    if (IS_SIMULATOR) {
//        
//        isSimulated = true;
//        
//        switch (serverType) {
//                
//            case ServerRequestTypePostAccessLogin:
//                
//                [self validateAfterRequest:[self getLocalData:serverType] requestType:serverType withURL:fullURL completionBlock:success errorBlock:failure];
//                
//                break;
//                
//            default:
//                
//                break;
//        }
//    }
//    return isSimulated;
//
//}

+ (void)requestServerWith:(AFNETWORK_TYPE)networkType serverRequestType:(ServerRequestType)serverType parameter:(NSDictionary*)parameter appendString:(NSString*)appendString success:(IDBlock)success failure:(IErrorBlock)failure
{
    [[ConnectionManager Instance]requestServerWith:networkType serverRequestType:serverType parameter:parameter appendString:appendString success:success failure:failure];
}

+(void)requestServerWithNSURLSession:(AFNETWORK_TYPE)networkType serverRequestType:(ServerRequestType)serverType parameter:(NSDictionary*)parameter appendString:(NSString*)appendString success:(IDBlock)success failure:(IErrorBlock)failure
{
    [[ConnectionManager Instance]requestServerWithNSURLSession:networkType serverRequestType:serverType parameter:parameter appendString:appendString success:success failure:failure];
}

#pragma mark - Main Connection Function
-(void)requestServerWith:(AFNETWORK_TYPE)networkType serverRequestType:(ServerRequestType)serverType parameter:(NSDictionary*)parameter appendString:(NSString*)appendString success:(IDBlock)success failure:(IErrorBlock)failure
{
    
    NSString* fullURL;
    
    NSString* strNetworkType;
    
    if ([self validateBeforeRequest:serverType]) {
       
        if (failure) {
            
            failure(nil);
        }
        return;
    }
    else{
        
        if (![Utils isStringNull:appendString]) {
            
            fullURL = [NSString stringWithFormat:@"%@/%@",[self getFullURLwithType:serverType],appendString];
        }
        else
        {
            fullURL = [self getFullURLwithType:serverType];
        }
        
    }
    
    
      AFHTTPSessionManager* manager = self.manager;

    NSString* jtw = @"";
    
    NSLog(@"JWT : %@",jtw);
    
    if (!(serverType == ServerRequestTypePostCustomerJwt
          || serverType == ServerRequestTypePostAccessLogin)) {
        
        [manager.requestSerializer setValue:jtw forHTTPHeaderField:Header_X_Auth];
        
    }


    
   // AFHTTPSessionManager* manager = [self createNewDataManager];

        switch (networkType) {
            case AFNETWORK_GET:
            {
                strNetworkType = @"GET";
                
              //  NSString* jtw =     [[Utils getAppInfo] jwt];
               

                [manager GET:fullURL parameters:parameter progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                    
                    [LoadingManager hide];

                    [self validateAfterRequest:responseObject requestType:serverType withURL:fullURL completionBlock:success errorBlock:failure];
                    
                    
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"Error: %@", error);
                    
                    [LoadingManager hide];

                    if (serverType == ServerRequestTypePostCustomerLogouts) {
                        
                        if (failure) {
                            failure(nil);
                        }
                        
                        return;
                    }
                    
                    [self showErrorHandling:task Error:error WithRecallingPreviousMethod:^(id object) {
                       
                        NSString* jtw = @"";
                        
                        NSLog(@"JWT : %@",jtw);
                        
                        
                        if (!(serverType == ServerRequestTypePostCustomerJwt
                            || serverType == ServerRequestTypePostAccessLogin)) {
                            
                            [manager.requestSerializer setValue:jtw forHTTPHeaderField:Header_X_Auth];

                        }
                        
                        [manager GET:fullURL parameters:parameter progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                            
                            [LoadingManager hide];
                            
                            [self validateAfterRequest:responseObject requestType:serverType withURL:fullURL completionBlock:success errorBlock:failure];
                            
                            
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            NSLog(@"Error: %@", error);
                            
                            [LoadingManager hide];
                            
                            if (failure) {
                                failure(error.description);
                            }
                        }];

                    } ShowDefaultError:failure];
                }];
            }
                break;
                
            case AFNETWORK_POST:
            {
                strNetworkType = @"POST";
 
                [manager POST:fullURL
                              parameters:parameter
                              progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    [LoadingManager hide];
                    
                    [self validateAfterRequest:responseObject requestType:serverType withURL:fullURL completionBlock:success errorBlock:failure];
                    
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    NSLog(@"Error: %@", error);
                    
                    [LoadingManager hide];
                    
                    
                    if (serverType == ServerRequestTypePostCustomerLogouts) {
                        
                        if (failure) {
                            failure(nil);
                        }
                        
                        return;
                    }
                    
                    [self showErrorHandling:task Error:error WithRecallingPreviousMethod:^(id object) {
                        
                        [manager POST:fullURL
                           parameters:parameter
                             progress:^(NSProgress * _Nonnull uploadProgress) {
                                 
                             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 
                                 [LoadingManager hide];
                                 
                                 [self validateAfterRequest:responseObject requestType:serverType withURL:fullURL completionBlock:success errorBlock:failure];
                                 
                                 
                             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                 
                                 NSLog(@"Error: %@", error);
                                 
                                 [LoadingManager hide];
                                 
                                 if (failure) {
                                     failure(error.description);
                                 }
                                
                             }];
                        
                    } ShowDefaultError:failure];
                }];
                
            }
                break;
                
            case AFNETWORK_DELETE:
            {
                strNetworkType = @"DELETE";
                [manager DELETE:fullURL parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    NSLog(@"RESPONSE: %@", responseObject);
                    
                    [LoadingManager hide];

                    [self validateAfterRequest:responseObject requestType:serverType withURL:fullURL completionBlock:success errorBlock:failure];
                    
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    [LoadingManager hide];

                    NSLog(@"Error: %@", error);
                    
                    
                    
                    [self showErrorHandling:task Error:error WithRecallingPreviousMethod:^(id object) {
                        
                        [task resume];
                        
                    } ShowDefaultError:failure];
                }];
            }
                break;
                
            case AFNETWORK_PUT:
            {
                strNetworkType = @"PUT";
                
                [manager PUT:fullURL parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    [LoadingManager hide];

                    [self validateAfterRequest:responseObject requestType:serverType withURL:fullURL completionBlock:success errorBlock:failure];
                    
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    [LoadingManager hide];

                    NSLog(@"Error: %@", error);
                    
                   
                    [self showErrorHandling:task Error:error WithRecallingPreviousMethod:^(id object) {
                        
                        
                    } ShowDefaultError:failure];
                    
                }];
            }
                break;
                
            case AFNETWORK_CUSTOM_GET:
            {
                
                fullURL = appendString;
                
                [manager GET:fullURL parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                    [LoadingManager hide];

                    
                    [self validateAfterRequest:responseObject requestType:serverType withURL:fullURL completionBlock:success errorBlock:failure];
                    
                    
                    
                } failure:^(NSURLSessionTask *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    
                    [LoadingManager hide];

                    
                    [self showErrorHandling:operation Error:error WithRecallingPreviousMethod:^(id object) {
                        
                        [operation resume];
                        
                    } ShowDefaultError:failure];
                    
                }];
                
                strNetworkType = @"CUSTOM_GET";
                
            }
                break;
                
            case AFNETWORK_CUSTOM_POST:
            {
                
                fullURL = appendString;
                
                [manager POST:fullURL parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                    
                    [LoadingManager hide];

                    [self validateAfterRequest:responseObject requestType:serverType withURL:fullURL completionBlock:success errorBlock:failure];
                    
                    
                    
                } failure:^(NSURLSessionTask *operation, NSError *error) {
                    NSLog(@"Error: %@", error);
                    
                    [LoadingManager hide];

                
                    
                    [self showErrorHandling:operation Error:error WithRecallingPreviousMethod:^(id object) {
                        
                        [operation resume];
                        
                    } ShowDefaultError:failure];
                }];
                
                strNetworkType = @"CUSTOM_POST";
                
            }
                break;
                
            default:
                break;
        }
        
    //    NSLog(@"\n\n ===== [REQUEST SERVER WITH %@][URL] : %@ \n [REQUEST JSON] : %@\n\n",strNetworkType,fullURL,[parameter bv_jsonStringWithPrettyPrint:YES]);
    
        
}


-(void)requestServerWithNSURLSession:(AFNETWORK_TYPE)networkType serverRequestType:(ServerRequestType)serverType parameter:(NSDictionary*)parameter appendString:(NSString*)appendString success:(IDBlock)success failure:(IErrorBlock)failure
{
    
    NSString* fullURL;
    
    
    if ([self validateBeforeRequest:serverType]) {
        
        if (failure) {
            
            failure(nil);
        }
        return;
    }
    else{
        
        if (![Utils isStringNull:appendString]) {
            
            fullURL = [NSString stringWithFormat:@"%@/%@",[self getFullURLwithType:serverType],appendString];
        }
        else
        {
            fullURL = [self getFullURLwithType:serverType];
        }
        
    }

    NSString* strNetworkType;

    
    switch (networkType) {
        case AFNETWORK_POST:
            strNetworkType = @"POST";
            break;
        case AFNETWORK_GET:
            strNetworkType = @"GET";

            break;
        default:
            break;
    }
    
    NSError *error;
    
    NSURL *url = [NSURL URLWithString:fullURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    NSString* jtw = @"";
    
    NSLog(@"jwt : %@",jtw);
    
    [request addValue:jtw forHTTPHeaderField:Header_X_Auth];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:strNetworkType];
  
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameter options:0 error:&error];
    
    [request setHTTPBody:postData];
    

    NSURLSessionDataTask *postDataTask = [[[self class] session] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError* jsonError;
        
        
        
        
        if (error) {
            NSLog(@"Error: %@", error);

        }
        else{
          //  NSLog(@"%@ %@", response, response);
            NSDictionary* responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:kNilOptions
                                                                             error:&jsonError];
            //NSLog(@"response : %@",responseObject);

            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[NSThread currentThread] isMainThread]){
                
                    [self validateAfterRequest:responseObject requestType:serverType withURL:fullURL completionBlock:success errorBlock:failure];

                }
                else{
                }

            });
            
            
        }
        


    }];
    
    [postDataTask resume];
    
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:fullURL parameters:parameter constructingBodyWithBlock:block error:nil];
//    
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    
//    NSURLSessionUploadTask *uploadTask;
//    uploadTask = [manager
//                  uploadTaskWithStreamedRequest:request
//                  progress:^(NSProgress * _Nonnull uploadProgress) {
//                      // This is not called back on the main queue.
//                      // You are responsible for dispatching to the main queue for UI updates
//                      dispatch_async(dispatch_get_main_queue(), ^{
//                          //Update the progress view
//                      });
//                  }
//                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//                      if (error) {
//                          NSLog(@"Error: %@", error);
//                      } else {
//                          NSLog(@"%@ %@", response, responseObject);
//                          
//                          [self validateAfterRequest:responseObject requestType:serverType withURL:fullURL completionBlock:success errorBlock:failure];
//
//                      }
//                  }];
//    
//    [uploadTask resume];
    
   // NSLog(@"\n\n ===== [REQUEST SERVER WITH %@][URL] : %@ \n [REQUEST JSON] : %@\n\n",strNetworkType,fullURL,[parameter bv_jsonStringWithPrettyPrint:YES]);


}

#pragma mark - APP URL
-(NSString*)getFullURLwithType:(ServerRequestType)type
{
    NSString* str;
    switch (type) {
        case ServerRequestTypePostAccessLogin:
            str = [NSString stringWithFormat:@"access/logins"];
            
            break;
            case ServerRequestTypePostAccessRegistration:
            str = [NSString stringWithFormat:@"access/registrations"];
            
            break;
            case ServerRequestTypePostAccessVerification:
            str = [NSString stringWithFormat:@"access/verifications"];
            
            break;
            case ServerRequestTypePostAccessPasswordRenewal:
            str = [NSString stringWithFormat:@"access/passwords/renewals"];
            
            break;
            case ServerRequestTypePostAccessReset:
            str = [NSString stringWithFormat:@"access/passwords/resets"];
            
            break;
            case ServerRequestTypePostAccessPasswordVerifications:
            str = [NSString stringWithFormat:@"access/passwords/verifications"];
            
            break;
            case ServerRequestTypePostAccessUsernamesAvailability:
            str = [NSString stringWithFormat:@"access/usernames/availability"];
            
            break;
        case ServerRequestTypePostInfoHelpersChat:
            str = [NSString stringWithFormat:@"chats"];

            break;

        case ServerRequestTypePostCustomerCompletions:
        case ServerRequestTypePostInfo:
        case ServerRequestTypePostCustomerTutorial:
        case ServerRequestTypeGetCustomer:
        case ServerRequestTypePostCustomerPasswords:
        case ServerRequestTypeGetCustomerNotifications:
        case ServerRequestTypePostCustomerNotificationsReads:
        case ServerRequestTypePostCustomerRevision:
        case ServerRequestTypePostCustomerPostsInfosHelpersStatus:
        case ServerRequestTypePostCustomerPostsHelpsHelpersStatus:
        case ServerRequestTypePostInfohelpersHigh5s:
            //POST /customers/{userId}/posts/infos/{postId}/helpers/{helperId}/high5s
        case ServerRequestTypePostInfoHelpersCreateChat:
            // POST /customers/{userId}/posts/infos/{postId}/helpers/{helperId}/chats
        case ServerRequestTypePostCustomerPostsFBConnects:
           // POST /customers/{userId}/fb/connects
        case ServerRequestTypePostHelpHelpersCreateChat:
        case ServerRequestTypePostHelpThanks:
        case ServerRequestTypePostCustomerHelpHelpersSpams:
        case ServerRequestTypePostCustomerInfoHelpersSpams:
        case ServerRequestTypePostInfoCloses:
        case ServerRequestTypePostHelpCloses:
        case ServerRequestTypePostHelpHelpersChat:
        case ServerRequestTypePostCustomerJwt:
        case ServerRequestTypePostCustomerPicture:
        case ServerRequestTypePostCustomerPreference:
        case ServerRequestTypeGetCustomerPreference:
        case ServerRequestTypePostCustomerLogouts:
        case ServerRequestTypePostCustomerPurchase:
            str = [NSString stringWithFormat:@"customers"];
            
            break;

        case ServerRequestTypeGetBeepOwnRequestor:
            str = [NSString stringWithFormat:@"beeps/own/requestors"];

            break;

        case ServerRequestTypeGetBeepOthersRequestor:
            str = [NSString stringWithFormat:@"beeps/others/requestors"];
            
            break;
//            POST /posts/infos/{postId}/helpers/{helperId}/replies
        case ServerRequestTypePostInfosHelpersReplies:
        case ServerRequestTypeGetInfosReplies:
        case ServerRequestTypeGetInfosRequestors:
        case ServerRequestTypePostInfoHelpersCancellations:
            //POST /posts/infos/{postId}/helpers/{helperId}/cancellations
        case ServerRequestTypePostInfosHelpersSpams:

            str = [NSString stringWithFormat:@"posts/infos"];

            break;
            
            //GET /posts/helps/{postId}/requestors/{requestorId}

        case ServerRequestTypeGetHelpsRequestors:
            
            //POST /posts/helps/{postId}/helpers/{helperId}/offers
        case ServerRequestTypePostHelpsHelpersOffers:
        case ServerRequestTypePostHelpHelpersSpams:
        case ServerRequestTypePostHelpHelpersCancellations:
            str = [NSString stringWithFormat:@"posts/helps"];

            break;
        case ServerRequestTypeGetPostHelpersChat:

            str = [NSString stringWithFormat:@"posts"];
            break;
            
        case ServerRequestTypeGetStoreCredits:
            str = [NSString stringWithFormat:@"stores/credits"];

            break;
            
        case ServerRequestTypePostChatResponderStatus:
            str = [NSString stringWithFormat:@"chats"];

            break;
            
        case ServerRequestTypeGetCreditConsumptions:
            str = [NSString stringWithFormat:@"credits"];

        default:
            break;
    }
    return [NSString stringWithFormat:@"http://%@/%@",self.serverPath,str];
    
}

-(void)storeServerData:(id)obj requestType:(ServerRequestType)type
{
    [self.connHelper storeServerData:obj requestType:type];
}

#pragma mark - PRE REQUEST VALIDATION

-(BOOL)validateBeforeRequest:(ServerRequestType)type
{
    BOOL flag = [self.connHelper validateBeforeRequest:type];
    
    return flag;
}

#pragma mark - POST REQUEST VALIDATION

-(void)validateAfterRequest:(id)obj requestType:(ServerRequestType)type withURL:(NSString*)url completionBlock:(IDBlock)success errorBlock:(IDBlock)failure
{
    
    
 //   NSLog(@"\n\n\n [SUCCESS RESPONSE RESULT URL : %@] \n%@ \n\n\n", url,[obj bv_jsonStringWithPrettyPrint:YES]);

    
 //   NSError* error;
    
//    BaseModel* model = [[BaseModel alloc]initWithDictionary:obj error:&error];
//   
//    
//    AppInfoModel* appModel = [AppInfoModel new];
//
//    if (model.jwt) {
//       
//        appModel.jwt = model.jwt;
//        
//        appModel.refreshToken = model.refreshToken;
//        
//        [Utils setAppInfo:appModel];
//    }
//    
    
   // NSString* jtw =     [[Utils getAppInfo] jwt];


      // NSLog(@"jwt = :%@",[GVUserDefaults standardUserDefaults].jwt);

//    if (model.isSuccessful) {
//        
//        
//        [self storeServerData:obj requestType:type];
//
//        if (success) {
//            success(obj);
//        }
//    }
//    else{
//        
//        if ([model.result.responseCode isEqualToString:INVALID_REFRESH_TOKEN]) {
//            
//            [Utils showLogin];
//            
//        }
//        
//        if (failure) {
//            
//            
//            NSString* erorrMessage = [NSString stringWithFormat:@"code : %@ , Error: %@",model.result.responseCode,model.result.responseMsg];
//            
//            failure(erorrMessage);
//        }
//    
//       
//    }
//    
}

#pragma mark  - ERROR handling for HTTP errors

-(void)showErrorHandling:(NSURLSessionTask*)task Error:(NSError*)error WithRecallingPreviousMethod:(IDBlock)recallBlock ShowDefaultError:(IDBlock)defaultBlock
{
    NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
    
    if ([response statusCode] == 503)
    {
        
    }
    else if([response statusCode] == 401)
    {
//        //POST /customers/{userId}/jwt
//        
//        
//        AppInfoModel* appModel = [Utils getAppInfo];
//        ProfileModel* pModel = [Utils getUserProfile];
//        
//        NSDictionary* dict = @{@"refreshToken" : appModel.refreshToken};
//        
//        NSString* appendString = [NSString stringWithFormat:@"%@/jwt",pModel.userId];
//        
//        [ConnectionManager requestServerWith:AFNETWORK_POST serverRequestType:ServerRequestTypePostCustomerJwt parameter:dict appendString:appendString success:^(id object) {
//            
//            
//            if (recallBlock) {
//                recallBlock(nil);
//            }
//            
//        } failure:^(id object) {
//            
//            NSLog(@"request jwt fail");
//        }];
//    }
//    else{
//        if (defaultBlock) {
//            defaultBlock(nil);
//        }
    }
}

+ (NSURLSession *)session
{
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        [configuration setHTTPMaximumConnectionsPerHost:1];
        
//        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];

        
        session = [NSURLSession sharedSession];
    });
    return session;
}

@end
