class BannerModel {
  Data? data;
  String? message;
  int? status;

  BannerModel({this.data, this.message, this.status});

  BannerModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class Data {
  Banner? banner;

  Data({this.banner});

  Data.fromJson(Map<String, dynamic> json) {
    banner = json['banner'] != null ? Banner.fromJson(json['banner']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (banner != null) {
      data['banner'] = banner!.toJson();
    }
    return data;
  }
}

class Banner {
  String? mainSliderBackgroundImage;
  String? mainSliderImage;
  String? mainSliderText;

  String? mainSliderVideo;
  bool? isVideo;
  String? videoThumbnail;

  Banner({
    this.mainSliderBackgroundImage,
    this.mainSliderImage,
    this.mainSliderText,
    this.mainSliderVideo,
    this.isVideo,
    this.videoThumbnail,
  });

  Banner.fromJson(Map<String, dynamic> json) {
    mainSliderBackgroundImage = json['main_slider_background_image'];
    mainSliderImage = json['main_slider_image'];
    mainSliderText = json['main_slider_text'];
    mainSliderVideo = json['main_slider_video'];
    isVideo = json['is_video'] ?? false;
    videoThumbnail = json['video_thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['main_slider_background_image'] = mainSliderBackgroundImage;
    data['main_slider_image'] = mainSliderImage;
    data['main_slider_text'] = mainSliderText;
    data['main_slider_video'] = mainSliderVideo;
    data['is_video'] = isVideo;
    data['video_thumbnail'] = videoThumbnail;
    return data;
  }
}
