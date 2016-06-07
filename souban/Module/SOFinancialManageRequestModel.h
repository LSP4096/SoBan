//
//  SOFinancialManageRequestModel.h
//  souban
//
//  Created by Rawlings on 1/26/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SOFinancialManageRequestModel : JSONModel

@property (nonatomic, strong) NSString *areaCode;/**< 户籍所在地编码	 */
@property (nonatomic, strong) NSNumber *monthlyWage;/**< 月工资	 */
@property (nonatomic, strong) NSString *name;/**< 姓名 */
@property (nonatomic, strong) NSString *phoneNum;/**< 手机号码 */
@property (nonatomic, strong) NSString *remarks;/**< 备注 */
@property (nonatomic, strong) NSString *socialSecurity;/**< 社保:  是 / 否 */

@end
