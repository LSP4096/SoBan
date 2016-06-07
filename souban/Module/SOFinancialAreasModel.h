//
//  SOFinancialAreasModel.h
//  souban
//
//  Created by Rawlings on 1/26/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import "OMBaseModel.h"

@protocol SOFinancialAreasBlockModel <NSObject>
@end
@interface SOFinancialAreasBlockModel : OMBaseModel
@property (nonatomic, strong) NSString *name;/**<  */
// id
@end



@interface SOFinancialAreasModel : OMBaseModel

@property (nonatomic, strong) NSString *name;/**<  */
@property (nonatomic, strong) NSString *areaCode;/**<  */
@property (nonatomic, strong) NSArray<SOFinancialAreasBlockModel> *blocks;/**<  */

@end
