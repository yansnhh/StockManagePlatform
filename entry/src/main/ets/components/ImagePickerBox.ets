@Component
export struct ImagePickerBox {
  @Link imageUri: string;
  onPickImage?: () => void;
  onTakePhoto?: () => void;

  build() {
    Column() {
      if (this.imageUri && this.imageUri.length > 0) {
        Image(this.imageUri)
          .width(96)
          .height(96)
          .borderRadius(12)
          .objectFit(ImageFit.Cover)
      } else {
        Text('添加图片')
          .fontSize(14)
          .fontColor('#888888')
          .width(96)
          .height(96)
          .textAlign(TextAlign.Center)
          .backgroundColor('#F2F3F5')
          .borderRadius(12)
      }

      Row() {
        Button('相册')
          .fontSize(12)
          .height(32)
          .onClick(() => {
            if (this.onPickImage) this.onPickImage();
          })

        Button('拍照')
          .fontSize(12)
          .height(32)
          .margin({ left: 8 })
          .onClick(() => {
            if (this.onTakePhoto) this.onTakePhoto();
          })
      }
      .margin({ top: 8 })
    }
    .alignItems(HorizontalAlign.Start)
  }
}
