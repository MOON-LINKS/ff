import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/catalogue/utils/hive.dart';

final catalogueProvider =
    StateNotifierProvider<CatalogueNotifier, Map<String, dynamic>>((ref) {
  final hivePayload = getCatalogueData('payload') != null
      ? Map<String, dynamic>.from(getCatalogueData('payload'))
      : {
          'categories': [
            /*
            {
              "uuid": "item_def456",
              "title": "Summer Linen Tee",
              "description": "Breathable linen, oversized fit",
              "main_image_url": "https://cdn.example.com/items/def456.jpg",
              "badges": [],
              "is_active": 1,
              "display_order": 2,
              "images": [],
              "main_price": 24.99,
              "pricing_config": {
                "template_name": null,
                "derived_from": "T-Shirt",
                "is_modified": true,
                "parameters": [
                  {
                    "id": "prm_001",
                    "name": "Color",
                    "type": "color",
                    "values": [
                      { "id": "val_010", "label": "Beige", "hex": "#F5F0E8" }
                    ]
                  },
                  {
                    "id": "prm_002",
                    "name": "Size",
                    "type": "text",
                    "values": [
                      { "id": "val_011", "label": "M" },
                      { "id": "val_012", "label": "L" }
                    ]
                  },
                  {
                    "id": "prm_099",
                    "name": "Length",
                    "type": "text",
                    "values": [
                      { "id": "val_013", "label": "Regular" },
                      { "id": "val_014", "label": "Cropped" }
                    ]
                  }
                ],
                "combinations": [
                  { "ids": ["val_010", "val_011", "val_013"], "labels": ["Beige", "M", "Regular"], "price": null , "quantity": 50},
                  { "ids": ["val_010", "val_011", "val_014"], "labels": ["Beige", "M", "Cropped"], "price": 22.99, "quantity": null},
                  { "ids": ["val_010", "val_012", "val_013"], "labels": ["Beige", "L", "Regular"], "price": null , "quantity": 50},
                  { "ids": ["val_010", "val_012", "val_014"], "labels": ["Beige", "L", "Cropped"], "price": 22.99, "quantity": 50}
                ]
              }
            }
         */
          ],
          'logo': '',
          'bio': '',
          'banner': '',
          'inner-banner': '',
          'offer': '',
          'loader': '',
          'font': '',
          'google': '',
          'order': {
            'countryISOCode': '',
            'countryCode': '',
            'number': '',
            'platforms': [],
          },
          'analytics': 0,
          'animation': 'none',
          'design': {
            'primary-color': 4294967295,
            'secondary-color': 4294967295,
            'title-color': 4294967295,
            'text-color': 4294967295,
            'category-primary': 4294967295,
            'category-secondary': 4278190080
          },
          'status': 'inactive',
          'currency': '',
          'feedback': false,
          'openclose': {
            'enabled': false,
            'hours': [
              {
                'day': 'Monday',
                'from': null,
                'to': null,
              },
              {
                'day': 'Tuesday',
                'from': null,
                'to': null,
              },
              {
                'day': 'Wednesday',
                'from': null,
                'to': null,
              },
              {
                'day': 'Thursday',
                'from': null,
                'to': null,
              },
              {
                'day': 'Friday',
                'from': null,
                'to': null,
              },
              {
                'day': 'Saturday',
                'from': null,
                'to': null,
              },
              {
                'day': 'Sunday',
                'from': null,
                'to': null,
              },
            ]
          },
          'country-branch': {'enabled': false, 'countries': []},
          'social_media': {'enabled': false, 'media': []},
          'languages': {
            'lang0': {'name': 'English', 'code': 'en', 'active': true}
          },
          'domain': {
            'name': '',
            'status': '',
            'created_at': '',
            'dns': {
              'ns1': '',
              'ns2': '',
            }
          },
          "saved_templates": [
            {
              "id": "tpl_001",
              "name": "T-Shirt",
              "parameters": [
                {"id": "prm_001", "name": "Color", "type": "color"},
                {"id": "prm_002", "name": "Size", "type": "text"}
              ]
            }
          ]
        };

  final hiveFeatures = getCatalogueData('features') != null
      ? Map<String, dynamic>.from(getCatalogueData('features'))
      : {};
  final hiveMeta = getCatalogueData('meta') != null
      ? Map<String, dynamic>.from(getCatalogueData('meta'))
      : {'sameAsDatabase': false, 'isPublished': false};
  final hiveAssets = getCatalogueData('assets') != null
      ? Map<String, dynamic>.from(getCatalogueData('assets'))
      : {'media': [], 'category': []};
  final hiveName = getCatalogueData('name') ?? '';

  final hiveImagecounter = getCatalogueData('image_counter') ?? 0;
  final hiveAddOn = getCatalogueData('addons_images') ??
      {'quantity': 0, 'status': 'inactive', 'ends_at': null};
  final initialHive = {
    'payload': hivePayload,
    'features': hiveFeatures,
    'meta': hiveMeta,
    'assets': hiveAssets,
    'image_counter': hiveImagecounter,
    'name': hiveName,
    'addons_images': hiveAddOn
  };
  return CatalogueNotifier(initialHive);
});

class CatalogueNotifier extends StateNotifier<Map<String, dynamic>> {
  final Map<String, dynamic> _initialState;
  CatalogueNotifier(Map<String, dynamic> initialState)
      : _initialState = Map<String, dynamic>.from(initialState),
        super(Map<String, dynamic>.from(initialState));
  Future<void> resetAll() async {
    await getCatalogueBox().clear();
    state = {
      'payload': {
        'categories': [],
        'logo': '',
        'bio': '',
        'banner': '',
        'inner-banner': '',
        'offer': '',
        'loader': '',
        'font': '',
        'google': '',
        'order': {
          'countryISOCode': '',
          'countryCode': '',
          'number': '',
          'platforms': [],
        },
        'analytics': 0,
        'animation': 'none',
        'design': {
          'primary-color': 4294967295,
          'secondary-color': 4294967295,
          'title-color': 4294967295,
          'text-color': 4294967295,
          'category-primary': 4294967295,
          'category-secondary': 4278190080
        },
        'status': 'inactive',
        'currency': '',
        'feedback': false,
        'openclose': {
          'enabled': false,
          'hours': [
            {'day': 'Monday', 'from': null, 'to': null},
            {'day': 'Tuesday', 'from': null, 'to': null},
            {'day': 'Wednesday', 'from': null, 'to': null},
            {'day': 'Thursday', 'from': null, 'to': null},
            {'day': 'Friday', 'from': null, 'to': null},
            {'day': 'Saturday', 'from': null, 'to': null},
            {'day': 'Sunday', 'from': null, 'to': null},
          ]
        },
        'country-branch': {'enabled': false, 'countries': []},
        'social_media': {'enabled': false, 'media': []},
        'languages': {
          'lang0': {'name': 'English', 'code': 'en', 'active': true}
        },
        'domain': {
          'name': '',
          'status': '',
          'created_at': '',
          'dns': {
            'ns1': '',
            'ns2': '',
          }
        },
        "saved_templates": []
      },
      'features': {},
      'meta': {'sameAsDatabase': false, 'isPublished': false},
      'assets': {'media': [], 'category': []},
      'image_counter': 0,
      'name': '',
      'addons_images': {'quantity': 0, 'status': 'inactive', 'ends_at': null},
    };
  }

  //assets
  Future<void> updateAssets(Map<String, dynamic> newAssets) async {
    state = {...state, 'assets': newAssets};
    await saveCatalogueData('assets', newAssets);
  }

  //addons
  Future<void> updateAddOns(dynamic addOns) async {
    state = {...state, 'addons_images': addOns};
    await saveCatalogueData('addons_images', addOns);
  }

  //meta
  Future<void> updateMeta(String key, dynamic value) async {
    final newMeta = {...state['meta'], key: value};
    state = {...state, 'meta': newMeta};
    await saveCatalogueData('meta', newMeta);
  }

  //name
  Future<void> updateName(String newName) async {
    state = {...state, 'name': newName};
    await saveCatalogueData('name', newName);
  }

  //features
  Future<void> updateFeatures(Map<String, dynamic> newFeatures) async {
    state = {...state, 'features': newFeatures};
    await saveCatalogueData('features', newFeatures);
  }

  bool canUseFeature(String key) {
    return state['features']?[key] == 1;
  }

  int getFeatureLimit(String key) {
    final value = state['features']?[key];
    if (value is int) return value;
    return 0;
  }

  //payload
  Future<void> _savePayloadToHive() async {
    await saveCatalogueData('payload', state['payload']);
    await updateMeta('sameAsDatabase', false);
  }

  void updateCatalogue(Map<String, dynamic> newCatalogue) {
    state = {...state, 'payload': newCatalogue};
    _savePayloadToHive();
  }

  //domain
  Future<void> updateDomain(Map domain) async {
    state = {
      ...state,
      'payload': {
        ...state['payload'],
        'domain': {...state['payload']['domain'], ...domain}
      }
    };
    _savePayloadToHive();
  }

  //update other info
  Future<void> addOrUpdateInfo(String key, dynamic value) async {
    state = {
      ...state,
      'payload': {...state['payload'], key: value}
    };
    _savePayloadToHive();
  }

  //search logic
  dynamic searchCategoryNode(String uuid) {
    final List categories = List.from(state['payload']['categories']);
    for (final cat in categories) {
      if (cat['uuid'] == uuid) {
        return cat;
      }
    }
  }

  dynamic searchSubCategoryNode(String catUuid, String subCatUuid) {
    final List categories = List.from(state['payload']['categories']);
    for (final cat in categories) {
      if (cat['uuid'] == catUuid) {
        for (final subCat in cat['subcategories']) {
          if (subCat['uuid'] == subCatUuid) {
            return subCat;
          }
        }
      }
    }
    return null;
  }

  dynamic searchItemNode(String catUuid, String subCatUuid, String itemUuid) {
    final List categories = List.from(state['payload']['categories']);
    for (final cat in categories) {
      if (cat['uuid'] == catUuid) {
        for (final subCat in cat['subcategories']) {
          if (subCat['uuid'] == subCatUuid) {
            for (final item in subCat['items']) {
              if (item['uuid'] == itemUuid) {
                return item;
              }
            }
          }
        }
      }
    }
    return null;
  }

  //check items and image_allowed
  Future<void> checkItems() async {
    int totalImages = state['features']['total_image'] ?? 0;
    int addedOnImages = state['addons_images']['quantity'] ?? 0;
    if (state['addons_images']['status'] == 'active' ||
        (state['addons_images']['status'] == 'cancelled' &&
            DateTime.parse(state['addons_images']['ends_at'])
                .isAfter(DateTime.now()))) {
      totalImages += addedOnImages;
    }
    int globalCounter = 0;
    final payload = state['payload'];
    if (payload['categories'] == null) return;
    for (var category in payload['categories']) {
      if (category['image_url'] != null &&
          category['image_url'].toString().trim().isNotEmpty) {
        globalCounter++;
      }
    }
    final newCategories = payload['categories'].map((category) {
      final newSubcategories = category['subcategories'].map((subcategory) {
        final List<Map<String, dynamic>> items =
            (subcategory['items'] as List? ?? [])
                .map((e) => Map<String, dynamic>.from(e))
                .toList();
        items.sort((a, b) =>
            (a['display_order'] ?? 0).compareTo(b['display_order'] ?? 0));

        final updateItems = items.map((item) {
          final int itemImagesCount =
              ((item['main_image_url'] != null && item['main_image_url'] != '')
                      ? 0
                      : 1) +
                  ((item['images'] as List?)?.length ?? 0);
          if (globalCounter + itemImagesCount > totalImages &&
              itemImagesCount > 0) {
            return {...item, 'is_active': 0};
          } else {
            globalCounter += itemImagesCount;
            return {...item, 'is_active': 1};
          }
        }).toList();
        return {...subcategory, 'items': updateItems};
      }).toList();
      return {...category, 'subcategories': newSubcategories};
    }).toList();
    state = {
      ...state,
      'payload': {
        ...state['payload'],
        'categories': newCategories,
      },
      'image_counter': globalCounter,
    };
    await saveCatalogueData('payload', state['payload']);
    await saveCatalogueData('image_counter', globalCounter);
  }

  //category
  //add modify category
  Future<void> addOrModifyCategory(String categoryUuid, String title,
      String? iconKey, String? imageUrl, int order) async {
    final categories = (state['payload']['categories'] as List<dynamic>?) ?? [];
    bool found = false;
    for (final category in categories) {
      if (category['uuid'] == categoryUuid) {
        category['title'] = title;
        category['icon_key'] = iconKey;
        category['image_url'] = imageUrl;

        found = true;
        break;
      }
    }
    if (!found) {
      categories.add({
        'uuid': categoryUuid,
        'title': title,
        'icon_key': iconKey,
        'image_url': imageUrl,
        'display_order': categories.length,
        'subcategories': [],
      });
    }
    state = {
      ...state,
      'payload': {...state['payload'], 'categories': categories}
    };
    await checkItems();
  }

  //remove category
  Future<void> deleteCategory(String categoryUuid) async {
    var categories = state['payload']['categories'] as List<dynamic>;
    final newCategories =
        categories.where((c) => c['uuid'] != categoryUuid).toList();
    state = {
      ...state,
      'payload': {...state['payload'], 'categories': newCategories}
    };
    await checkItems();
  }

  //categories order
  Future<void> updateCategoriesOrder() async {
    final categories = List<Map<String, dynamic>>.from(
        (state['payload']['categories'] as List)
            .map((e) => Map<String, dynamic>.from(e)));
    categories.sort(
        (a, b) => (a['display_order'] ?? 0).compareTo(b['display_order'] ?? 0));
    state = {
      ...state,
      'payload': {
        ...state['payload'],
        'categories': categories,
      }
    };
    await checkItems();
  }

  Future<void> reorderCategories(int oldIndex, int newIndex) async {
    final categories = List<Map<String, dynamic>>.from(
        ((state['payload']['categories'] as List?) ?? [])
            .map((e) => Map<String, dynamic>.from(e)));
    categories.sort(
        (a, b) => (a['display_order'] ?? 0).compareTo(b['display_order'] ?? 0));

    final moved = categories.removeAt(oldIndex);
    categories.insert(newIndex, moved);

    for (int i = 0; i < categories.length; i++) {
      categories[i]['display_order'] = i;
    }

    state = {
      ...state,
      'payload': {
        ...state['payload'],
        'categories': categories,
      }
    };
    await _savePayloadToHive();
  }

  //subcategory
  //add modify subcategory
  Future<void> addOrModifySubcategory(String subcategoryUuid,
      String categoryUuid, String title, int order) async {
    final categories = (state['payload']['categories'] as List<dynamic>?) ?? [];
    final newCategories = categories.map((category) {
      if (category['uuid'] != categoryUuid) return category;
      final subcategories = (category['subcategories'] as List<dynamic>?) ?? [];
      bool found = false;
      final newSubcategories = subcategories.map((subcategory) {
        if (subcategory['uuid'] == subcategoryUuid) {
          found = true;
          return {...subcategory, 'display_order': order, 'title': title};
        }
        return subcategory;
      }).toList();
      if (!found) {
        newSubcategories.add({
          'uuid': subcategoryUuid,
          'title': title,
          'display_order': order,
          'items': []
        });
      }
      return {...category, 'subcategories': newSubcategories};
    }).toList();
    state = {
      ...state,
      'payload': {...state['payload'], 'categories': newCategories}
    };
    await checkItems();
  }

  //remove subcategory
  Future<void> deleteSubcategory(
      String subcategoryUuid, String categoryUuid) async {
    final categories = (state['payload']['categories'] as List<dynamic>?) ?? [];
    final newCategories = categories.map((category) {
      if (category['uuid'] != categoryUuid) {
        return category;
      }
      final subcategories = (category['subcategories'] as List<dynamic>?) ?? [];
      final newSubcategories =
          subcategories.where((a) => a['uuid'] != subcategoryUuid);
      return {...category, 'subcategories': newSubcategories};
    }).toList();
    state = {
      ...state,
      'payload': {...state['payload'], 'categories': newCategories}
    };
    await checkItems();
  }

  //subcategories order
  Future<void> updateSubcategoriesOrder(String categoryUuid) async {
    final catalogue = state['payload'];
    final categoryIndex =
        catalogue['categories'].indexWhere((c) => c['uuid'] == categoryUuid);
    if (categoryIndex == -1) return;
    final subcategories =
        catalogue['categories'][categoryIndex]['subcategories'];
    for (int i = 0; i < subcategories.length; i++) {
      subcategories[i]['display_order'] = i;
    }
    subcategories
        .sort((a, b) => a['display_order'].compareTo(b['display_order']));
    final newPayload = Map<String, dynamic>.from(catalogue);
    state = {...state, 'payload': newPayload};
    await checkItems();
  }

  //items
  //add modify item
  Future<void> addOrModifyItem(
      String categoryUuid, String subcategoryUuid, dynamic paramItem) async {
    var categories = state['payload']['categories'] as List<dynamic>;
    var found = false;

    final newCategories = categories.map((category) {
      if (category['uuid'] == categoryUuid) {
        final subcategories = category['subcategories'] as List<dynamic>? ?? [];
        final newSubcategories = subcategories.map((subcategory) {
          if (subcategory['uuid'] == subcategoryUuid) {
            final items = subcategory['items'] as List<dynamic>? ?? [];
            final newItems = items.map((item) {
              if (item['uuid'] == paramItem['uuid']) {
                found = true;
                return {
                  ...item,
                  'title': paramItem['title'],
                  'description': paramItem['description'],
                  'main_image_url': paramItem['main_image_url'],
                  'badges': paramItem['badges'],
                  'is_active': 1,
                  'display_order': paramItem['display_order'],
                  'images': paramItem['images'],
                  'main_price': paramItem['main_price'],
                  'pricing_config': paramItem['pricing_config']
                };
              }
              return item;
            }).toList();
            if (!found) {
              newItems.add({
                'uuid': paramItem['uuid'],
                'title': paramItem['title'],
                'description': paramItem['description'],
                'main_image_url': paramItem['main_image_url'],
                'badges': paramItem['badges'],
                'is_active': 1,
                'display_order': paramItem['display_order'],
                'images': paramItem['images'],
                'main_price': paramItem['main_price'],
                'pricing_config': paramItem['pricing_config']
              });
            }
            return {...subcategory, 'items': newItems};
          }
          return subcategory;
        }).toList();
        return {...category, 'subcategories': newSubcategories};
      }
      return category;
    }).toList();
    state = {
      ...state,
      'payload': {
        ...state['payload'],
        'categories': newCategories,
      }
    };
    await checkItems();
  }

  //remove item
  Future<void> deleteItem(
    String itemUuid,
    String subcategoryUuid,
    String categoryUuid,
  ) async {
    final categories = state['payload']['categories'] as List<dynamic>;
    final newCategories = categories.map((category) {
      if (category['uuid'] == categoryUuid) {
        final subcategories =
            (category['subcategories'] as List<dynamic>?) ?? [];
        final newSubcategories = subcategories.map((subcategory) {
          if (subcategory['uuid'] == subcategoryUuid) {
            final items = (subcategory['items'] as List<dynamic>?) ?? [];
            final newItems =
                items.where((item) => item['uuid'] != itemUuid).toList();
            return {...subcategory, 'items': newItems};
          }
          return subcategory;
        }).toList();
        return {
          ...category,
          'subcategories': newSubcategories,
        };
      }
      return category;
    }).toList();
    state = {
      ...state,
      'payload': {...state['payload'], 'categories': newCategories}
    };
    await checkItems();
  }

  //items order
  Future<void> updateItemsOrder(
      String subcategoryUuid, String categoryUuid) async {
    final catalogue = state['payload'];
    final categoryIndex =
        catalogue['categories'].indexWhere((c) => c['uuid'] == categoryUuid);
    if (categoryIndex == -1) return;
    final subcategories =
        catalogue['categories'][categoryIndex]['subcategories'];
    final subcategoryIndex =
        subcategories.indexWhere((s) => s['uuid'] == subcategoryUuid);
    if (subcategoryIndex == -1) return;
    final List items = subcategories[subcategoryIndex]['items'];
    for (int i = 0; i < items.length; i++) {
      items[i]['display_order'] = i;
    }
    items.sort((a, b) => a['display_order'].compareTo(b['display_order']));
    final newPayload = Map<String, dynamic>.from(catalogue);
    state = {...state, 'payload': newPayload};
    await checkItems();
  }
}
