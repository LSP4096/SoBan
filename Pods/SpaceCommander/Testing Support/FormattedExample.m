// Copyright 2015 Square, Inc
#import @"XYZGeometry.h"
#import "Blah.h"
#import <Great.h>


#define FQCommonInitInterfaceDeclaration(className) -(void)_##className##_commonInit

#define SDAssertIsQueueBackedContext(context) \
    NSAssert(NO, @"Should there be a semicolon at the end of this macro line?")

ThisIsAMacroThatIsMissingASemicolon();
ThisIsAMacroThatIsMissingASemicolon();

#if __has_include(<SafariServices/SafariServices.h>)
#endif

ThisIsAMacroThatShouldNotHaveASemicolonAppended()
{
    // do stuff
}

BOOL extraSemicolonsNotInsertedAfterCGStructInitializer()
{
    CAShapeLayer *contentViewVerticalDividerLayer = [TAFStyles lineShapeLayerFromPoint:CGPointMake(0.0f,
                                                                                                   CGRectGetHeight(contentView.bounds) - hairline)
                                                                               toPoint:CGPointMake(CGRectGetWidth(contentView.bounds),
                                                                                                   CGRectGetHeight(contentView.bounds) - hairline)
                                                                             withColor:[UIColor tef_tabletFilterHeaderDividerColor]
                                                                                 width:hairline];
}

#define RKTAddTestCaseCategoryInterface(klass, name)      \
    @class klass;                                         \
    @interface KIFTestCase (klass##_ConvenienceAdditions) \
    @property (nonatomic, readonly, strong) klass *name;  \
    @end


@interface ProblemChild <NeatInterface>
@property (nonatomic, assign, getter=isWackSpacingGetter, readonly) BOOL wackSpacing;

- (void)performOnMainThreadUsingBlock:(dispatch_block_t)block SQ_DEPRECATED("Should use addOperationWithBlock: on NSOperationQueue's mainQueue. Will be removed after 3/1/2015.");
@end

// The below interface should have its prepended newlines left alone due to this comment
@interface Foo
@end


// The inline constructors here are problematic and will get a semicolon added unless we put them on a single line.
struct Update {
    UpdateType type;
    string value;
    Update() : type(UPDATE_WRITE), value("") {}
    Update(UpdateType t, const Slice &v) : type(t), value(v.data(), v.size()) {}
};

/* Same deal here, don't mess with adding newlines after this comment block 
 * with a different comment style 
 * and trailing spaces */
@implementation Foo
@end


@implementation ProblemChild

- (void)methodWithParams:(NSString *)param1 another:(BOOL)param2
{
    SQSelfSelector1(_windowDidResignKeyNotification:);
    NSString *keys = [NSSet setWithArray:@[
        SQTypedKeyPath(MQItemControl, highlighted),
        SQTypedKeyPath(MQItemControl, enabled),
        SQTypedKeyPath(MQItemControl, selected)
    ]];
    NSArray *testLiteral = @[ cool ];
    NSDictionary *dictLiteral = @{ @"foo" : testLiteral };
    SQCheckCondition(NO, , @"Will the commas stay together?");
}

- (BOOL)methodThatReturnsSomething
{
    ThisIsAMacroThatIsMissingASemicolon("I need a semicolon");
    BOOL bleh = @"a" == nil;
    BOOL blah = bleh ?: YES;
    return YES ? blah : bleh;
}

#pragma mark - Section

- (id<ProtocolConformer>)spaceInTypeName;
{
    return nil;
}

- (void)paranthesisInMessage
{
    // The formatters can't distinguish between inline operators and casts, unfortunately.
    // We're either going to add or remove a space after the parens below.
    [headers setObject:(squareInstallationIdentifier ?: @"Unavailable")forKey:@"X-Device-Installation-ID"];
    [headers setObject:(@"Unavailable" + @"hello")forKey:nil];
    [self methodWithParams:(id)nil another:NO];
    // This is fine because it's a macro and not an operator.
    [self methodWithParams:NSStringFromClass(self.class) another:NO];
}

- (void)shortMethod {}

- (void)dictsInArray
{
    NSArray *dictionaries = @[
        @{
            @"token" : @"aaa",
            @"first_name" : @"Alice",
            @"last_name" : @"Adams"
        },
        @{
            @"token" : @"bbb",
            @"first_name" : @"Betty",
            @"last_name" : @"Brant"
        }
    ];
}

BOOL CStyleMethod()
{
    return false;
}


@end
