//
//  GGRichTextView.m
//  GGToolKit
//
//  Created by yg on 2023/6/11.
//

#import "GGRichTextView.h"

@interface GGRichTextView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GGRichTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)addText:(NSString *)text{
    GGRichTextLineCellModel *model = [[GGRichTextLineCellModel alloc] init];
    model.text = text;
    [self.dataSource addObject:model];
    [self.tableView reloadData];
}

- (void)addImage:(UIImage *)image{
    GGRichTextImageCellModel *model = [[GGRichTextImageCellModel alloc] init];
    model.image = image;
    [self.dataSource addObject:model];
    [self.tableView reloadData];
}

- (void)confitContentWithHtml:(NSString *)html{
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSData *htmlData = [html dataUsingEncoding:(NSUnicodeStringEncoding)];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:htmlData options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        // 遍历所有属性
        [attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            
            // 判断属性类型
            if (attrs[NSAttachmentAttributeName]) {
                // 属性类型为 NSTextAttachment，即为图片
                NSTextAttachment *attachment = attrs[NSAttachmentAttributeName];
                UIImage *image = attachment.image;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf addImage:image];
                });
                // 处理图片
            } else {
                // 属性类型非 NSTextAttachment，即为文字
                NSString *text = [attributedString.string substringWithRange:range];
                // 处理文字
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf addText:text];
                });
            }
        }];
    });
}

- (void)loadUI{
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerClass:[GGRichTextLineCell class] forCellReuseIdentifier:@"GGRichTextLineCell"];
    [self.tableView registerClass:[GGRichTextImageCell class] forCellReuseIdentifier:@"GGRichTextImageCell"];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id object = [self.dataSource objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[GGRichTextLineCellModel class]]){
        GGRichTextLineCellModel *model = object;
        [model calculatedHeightWithWidth:self.frame.size.width];
        return model.height;
    }else if ([object isKindOfClass:[GGRichTextImageCellModel class]]){
        GGRichTextImageCellModel *model = object;
        [model calculatedHeightWithWidth:self.frame.size.width];
        return model.height;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    id object = [self.dataSource objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[GGRichTextLineCellModel class]]){
        GGRichTextLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGRichTextLineCell" forIndexPath:indexPath];
        cell.model = object;
        cell.textChange = ^(GGRichTextLineCell * _Nonnull cell) {
            [weakSelf.tableView performBatchUpdates:nil completion:nil];
        };
        return cell;
    }else if ([object isKindOfClass:[GGRichTextImageCellModel class]]){
        GGRichTextImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGRichTextImageCell" forIndexPath:indexPath];
        cell.model = object;
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

- (NSMutableArray *)dataSource{
    if (_dataSource == nil){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end

@implementation GGRichTextLineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _textView.textContainer.lineFragmentPadding = 0.0;
        _textView.scrollEnabled = NO;
        [self.contentView addSubview:_textView];
    }
    return self;
}

- (void)textViewDidChange:(UITextView *)textView {
    _model.text = textView.text;
    if (self.textChange){
        self.textChange(self);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.textView.frame = self.bounds;
}

- (void)setModel:(GGRichTextLineCellModel *)model{
    _model = model;
    _textView.font = model.font;
    _textView.text = model.text;
}

@end

@implementation GGRichTextLineCellModel

- (instancetype)init{
    if (self = [super init]){
        
        self.font = [UIFont systemFontOfSize:20];
    }
    return self;
}

- (CGFloat)calculatedHeightWithWidth:(CGFloat)width{
   CGRect infoRect = [self.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
    self.height = infoRect.size.height + 1;
    return self.height;
}

@end


@implementation GGRichTextImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        _attachmentsImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_attachmentsImageView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat imageHeight = [self.model calculatedHeightWithWidth:self.frame.size.width];
    CGFloat imageWidth = self.model.imageWidth;
    if (imageWidth == 0){
        imageWidth = self.frame.size.width;
    }
    if (_model.imageAlignmentMode == 0){
        _attachmentsImageView.frame = CGRectMake(self.frame.size.width / 2 - imageWidth / 2, 0, imageWidth, imageHeight);
    }else if (_model.imageAlignmentMode == 1){
        _attachmentsImageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);
    }else if (_model.imageAlignmentMode == 2){
        _attachmentsImageView.frame = CGRectMake(self.frame.size.width - imageWidth, 0, imageWidth, imageHeight);
    }
}

- (void)setModel:(GGRichTextImageCellModel *)model{
    _model = model;
    self.attachmentsImageView.image = model.image;
}

@end


@implementation GGRichTextImageCellModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageWidth = 0;
        self.imageAlignmentMode = 0;
    }
    return self;
}

- (CGFloat)calculatedHeightWithWidth:(CGFloat)width{
    CGFloat imageWidth = self.imageWidth;
    if (imageWidth == 0){
        imageWidth = width;
    }
    CGSize size = self.image.size;
    if (self.image == nil || size.width==0 || size.height == 0){
        self.height = 0;
    }else{
        CGFloat imageHeight = self.image.size.height / self.image.size.width * imageWidth;
        self.height = imageHeight;
    }
    return self.height;
}

@end
