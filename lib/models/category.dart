class Category {
  final String id;
  final String name;
  final String? slug;
  final CategoryImage? img;
  final String? parent;
  final bool isFeature;
  final String? metaTitle;
  final String? metaDescription;
  final String? metaKeywords;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    this.slug,
    this.img,
    this.parent,
    required this.isFeature,
    this.metaTitle,
    this.metaDescription,
    this.metaKeywords,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      img: json['img'] != null ? CategoryImage.fromJson(json['img']) : null,
      parent: json['parent'],
      isFeature: json['isFeature'] ?? false,
      metaTitle: json['metaTitle'],
      metaDescription: json['metaDescription'],
      metaKeywords: json['metaKeywords'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'img': img?.toJson(),
      'parent': parent,
      'isFeature': isFeature,
      'metaTitle': metaTitle,
      'metaDescription': metaDescription,
      'metaKeywords': metaKeywords,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class CategoryImage {
  final String id;
  final String url;
  final String filename;
  final String mimeType;
  final int filesize;
  final int? width;
  final int? height;
  final String? alt;

  CategoryImage({
    required this.id,
    required this.url,
    required this.filename,
    required this.mimeType,
    required this.filesize,
    this.width,
    this.height,
    this.alt,
  });

  factory CategoryImage.fromJson(Map<String, dynamic> json) {
    return CategoryImage(
      id: json['id'],
      url: json['url'],
      filename: json['filename'],
      mimeType: json['mimeType'],
      filesize: json['filesize'],
      width: json['width'],
      height: json['height'],
      alt: json['alt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'filename': filename,
      'mimeType': mimeType,
      'filesize': filesize,
      'width': width,
      'height': height,
      'alt': alt,
    };
  }
}
