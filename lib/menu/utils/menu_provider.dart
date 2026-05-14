import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/menu/utils/hive.dart';

final menuProvider =
    StateNotifierProvider<MenuNotifier, Map<String, dynamic>>((ref) {
  final hivePayload = getMenuData('payload') != null
      ? Map<String, dynamic>.from(getMenuData('payload'))
      : {
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
          }
        };

  final hiveFeatures = getMenuData('features') != null
      ? Map<String, dynamic>.from(getMenuData('features'))
      : {};
  final hiveMeta = getMenuData('meta') != null
      ? Map<String, dynamic>.from(getMenuData('meta'))
      : {'sameAsDatabase': false, 'isPublished': false};
  final hiveAssets = getMenuData('assets') != null
      ? Map<String, dynamic>.from(getMenuData('assets'))
      : {'media': [], 'category': []};
  final hiveName = getMenuData('name') ?? '';

  final hiveImagecounter = getMenuData('image_counter') ?? 0;
  final hiveAddOn = getMenuData('addons_images') ??
      {'quantity': 0, 'status': 'inactive', 'ends_at': null};
  final hiveChosenLanguage = getMenuData('language_chosen') ?? 'lang0';
  final initialHive = {
    'payload': hivePayload,
    'features': hiveFeatures,
    'meta': hiveMeta,
    'assets': hiveAssets,
    'image_counter': hiveImagecounter,
    'name': hiveName,
    'addons_images': hiveAddOn,
    'language_chosen': hiveChosenLanguage
  };
  return MenuNotifier(initialHive);
});

class MenuNotifier extends StateNotifier<Map<String, dynamic>> {
  final Map<String, dynamic> _initialState;

  MenuNotifier(Map<String, dynamic> initialState)
      : _initialState = Map<String, dynamic>.from(initialState),
        super(Map<String, dynamic>.from(initialState));

  Future<void> resetAll() async {
    await getMenuBox().clear();
    state = Map<String, dynamic>.from(_initialState);
  }
/*   //image counter
  Future<void> imageCounter() async {
    int imageCount = 499;

    final payload = state['payload'];
    /*  if (payload['logo'] != null && payload['logo'] != '') {
      imageCount++;
    }
    if (payload['banner'] != null && payload['banner'] != '') {
      imageCount++;
    }
    if (payload['inner-banner'] != null && payload['inner-banner'] != '') {
      imageCount++;
    }
    if (payload['offer'] != null && payload['offer'] != '') {
      imageCount++;
    } */

    if (payload['categories'] != null) {
      for (var category in payload['categories']) {
        /*  if (category['image_url'] != null && category['image_url'] != '') {
          imageCount++;
        } */

        if (category['subcategories'] != null) {
          for (var subcategory in category['subcategories']) {
            if (subcategory['items'] != null) {
              for (var item in subcategory['items']) {
                if (item['main_image_url'] != null &&
                    item['main_image_url'] != '') {
                  imageCount++;
                }
                if (item['images'] != null) {
                  imageCount += (item['images'] as List).length;
                }
              }
            }
          }
        }
      }
    }
    state = {...state, 'image_counter': imageCount};
    await saveMenuData('image_counter', imageCount);
  } */

//image_allowed and items
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
      final newSubcategories =
          (category['subcategories'] ?? []).map((subcategory) {
        final List<Map<String, dynamic>> items =
            (subcategory['items'] as List? ?? [])
                .map((e) => Map<String, dynamic>.from(e))
                .toList();

        items.sort(
          (a, b) =>
              (a['display_order'] ?? 0).compareTo(b['display_order'] ?? 0),
        );

        final updatedItems = items.map((item) {
          final int itemImageCost =
              ((item['main_image_url'] != null && item['main_image_url'] != '')
                      ? 1
                      : 0) +
                  ((item['images'] as List?)?.length ?? 0);
          if (globalCounter + itemImageCost > totalImages &&
              itemImageCost > 0) {
            return {
              ...item,
              'is_active': 0,
            };
          } else {
            globalCounter += itemImageCost;
            return {
              ...item,
              'is_active': 1,
            };
          }
        }).toList();

        return {
          ...subcategory,
          'items': updatedItems,
        };
      }).toList();

      return {
        ...category,
        'subcategories': newSubcategories,
      };
    }).toList();
    state = {
      ...state,
      'payload': {
        ...state['payload'],
        'categories': newCategories,
      },
      'image_counter': globalCounter,
    };
    await saveMenuData('payload', state['payload']);
    await saveMenuData('image_counter', globalCounter);
  }

  //assets
  Future<void> updateAssets(Map<String, dynamic> newAssets) async {
    state = {...state, 'assets': newAssets};
    await saveMenuData('assets', newAssets);
  }

  //addOns
  Future<void> setAddOns(dynamic addOns) async {
    state = {...state, 'addons_images': addOns};
    await saveMenuData('addons_images', addOns);
  }

  //meta
  Future<void> updateMeta(String key, dynamic value) async {
    final newMeta = {...state['meta'], key: value};
    state = {...state, 'meta': newMeta};
    await saveMenuData('meta', newMeta);
  }

  //name
  Future<void> updateName(String newName) async {
    state = {...state, 'name': newName};
    await saveMenuData('name', newName);
  }

  //language_chosen
  Future<void> updateChosenLang(String newLangChosen) async {
    state = {...state, 'language_chosen': newLangChosen};
    await saveMenuData('language_chosen', newLangChosen);
  }

  //features
  Future<void> updateFeatures(Map<String, dynamic> newFeatures) async {
    state = {...state, 'features': newFeatures};
    await saveMenuData('features', newFeatures);
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
    await saveMenuData('payload', state['payload']);
    await updateMeta('sameAsDatabase', false);
  }

  void updateMenu(Map<String, dynamic> newMenu) {
    state = {...state, 'payload': newMenu};
    _savePayloadToHive();
  }

  //category
  Future<void> addOrModifyCategory(String categoryUuid, String title,
      String? iconKey, String? imageUrl) async {
    final categories = (state['payload']['categories'] as List<dynamic>?) ?? [];
    bool found = false;
    for (var category in categories) {
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
        'subcategories': [],
      });
    }
    state = {
      ...state,
      'payload': {
        ...state['payload'],
        'categories': categories,
      }
    };
    await checkItems();
    //_savePayloadToHive();
    //await imageCounter();
  }

  Future<void> deleteCategory(String categoryUuid) async {
    var categories = state['payload']['categories'] as List<dynamic>;
    final newCategories =
        categories.where((c) => c['uuid'] != categoryUuid).toList();
    state = {
      ...state,
      'payload': {
        ...state['payload'],
        'categories': newCategories,
      }
    };
    await checkItems();
    //_savePayloadToHive();
    //await imageCounter();
  }

  //subcategory
  Future<void> addOrModifySubcategory(
    String subcategoryUuid,
    String categoryUuid,
    String title,
  ) async {
    final categories = (state['payload']['categories'] as List<dynamic>?) ?? [];

    final newCategories = categories.map((category) {
      if (category['uuid'] != categoryUuid) return category;

      final subcategories = (category['subcategories'] as List<dynamic>?) ?? [];
      bool found = false;

      final newSubcategories = subcategories.map((subcategory) {
        if (subcategory['uuid'] == subcategoryUuid) {
          found = true;
          return {
            ...subcategory,
            'title': title,
          };
        }
        return subcategory;
      }).toList();

      if (!found) {
        newSubcategories
            .add({'uuid': subcategoryUuid, 'title': title, 'items': []});
      }

      return {...category, 'subcategories': newSubcategories};
    }).toList();

    state = {
      ...state,
      'payload': {
        ...state['payload'],
        'categories': newCategories,
      }
    };
    await checkItems();
    //_savePayloadToHive();
    //await imageCounter();
  }

  Future<void> deleteSubcategory(
      String subcategoryUuid, String categoryUuid) async {
    final categories = state['payload']['categories'] as List<dynamic>;
    final newCategories = categories.map((category) {
      if (category['uuid'] == categoryUuid) {
        final subcategories = category['subcategories'] as List<dynamic>;
        final newSubcategories = subcategories
            .where((sub) => sub['uuid'] != subcategoryUuid)
            .toList();
        return {
          ...category,
          'subcategories': newSubcategories,
        };
      } else {
        return category;
      }
    }).toList();

    state = {
      ...state,
      'payload': {
        ...state['payload'],
        'categories': newCategories,
      }
    };
    await checkItems();
    //_savePayloadToHive();
    //await imageCounter();
  }

  //items
  Future<void> addOrModifyItem(
      String itemUuid,
      String subcategoryUuid,
      String categoryUuid,
      String title,
      String description,
      String mainImageUrl,
      dynamic badges,
      int activate,
      int displayOrder,
      List<dynamic> types,
      List<dynamic> prices,
      List<dynamic> images) async {
    var categories = state['payload']['categories'] as List<dynamic>;
    var found = false;

    final newCategories = categories.map((category) {
      if (category['uuid'] == categoryUuid) {
        final subcategories = category['subcategories'] as List<dynamic>;
        final newSubcategories = subcategories.map((subcategory) {
          if (subcategory['uuid'] == subcategoryUuid) {
            final items = subcategory['items'] as List<dynamic>;
            final newItems = items.map((item) {
              if (item['uuid'] == itemUuid) {
                found = true;
                return {
                  ...item,
                  'title': title,
                  'description': description,
                  'main_image_url': mainImageUrl,
                  'badges': badges,
                  'is_active': 1,
                  'display_order': displayOrder,
                  'types': types,
                  'prices': prices,
                  'images': images
                };
              }
              return item;
            }).toList();
            if (!found) {
              newItems.add({
                'uuid': itemUuid,
                'title': title,
                'description': description,
                'main_image_url': mainImageUrl,
                'badges': badges,
                'is_active': 1,
                'display_order': displayOrder,
                'types': types,
                'prices': prices,
                'images': images
              });
            }
            return {
              ...subcategory,
              'items': newItems,
            };
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
      'payload': {
        ...state['payload'],
        'categories': newCategories,
      }
    };
    await checkItems();
    //_savePayloadToHive();
    //await imageCounter();
  }

  Future<void> updateItemsOrder(
      String subcategoryUuid, String categoryUuid) async {
    final menu = state['payload'];
    final categoryIndex =
        menu['categories'].indexWhere((c) => c['uuid'] == categoryUuid);
    if (categoryIndex == -1) return;

    final subcategories = menu['categories'][categoryIndex]['subcategories'];
    final subIndex =
        subcategories.indexWhere((s) => s['uuid'] == subcategoryUuid);
    if (subIndex == -1) return;

    final List items = subcategories[subIndex]['items'];
    for (int i = 0; i < items.length; i++) {
      items[i]['display_order'] = i;
    }
    items.sort((a, b) => a['display_order'].compareTo(b['display_order']));

    final newPayload = Map<String, dynamic>.from(menu);
    state = {...state, 'payload': newPayload};
    await checkItems();
    //_savePayloadToHive();
  }

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
            return {
              ...subcategory,
              'items': newItems,
            };
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
      'payload': {
        ...state['payload'],
        'categories': newCategories,
      }
    };
    await checkItems();
    //_savePayloadToHive();
    //await imageCounter();
  }

  //other info (it will work for name and will be called after the set name is clicked from backend)
  Future<void> addOrUpdateInfo(String key, dynamic value) async {
    state = {
      ...state,
      'payload': {...state['payload'], key: value}
    };
    _savePayloadToHive();
  }

  //Lang info content
/*   Future<void> addOrUpdateCustomLangInfo(
      String key, dynamic value, String lang) async {
    final payload = state['payload'] ?? {};
    final currentField = payload[key];
    final newValue = Map<String, dynamic>.from(
        (currentField is Map && currentField['custom'] is Map)
            ? currentField['custom']
            : {});
    newValue[lang] = value;
    state = {
      ...state,
      'payload': {
        ...state['payload'],
        key: {'custom': newValue}
      }
    };
    _savePayloadToHive();
  }
 */
  //search using uuid
  dynamic searchCategoryNode(String uuid) {
    final List categories = state['payload']['categories'];
    for (final cat in categories) {
      if (cat['uuid'] == uuid) {
        return {'title': cat['title'], 'subcategories': cat['subcategories']};
      }
    }
    return null;
  }

  dynamic searchSubcategoryNode(String catUuid, String subUuid) {
    final List categories = state['payload']['categories'];
    for (final cat in categories) {
      if (cat['uuid'] == catUuid) {
        final List subcategories = cat['subcategories'];
        for (final sub in subcategories) {
          if (sub['uuid'] == subUuid) {
            return {
              'category_title': cat['title'],
              'title': sub['title'],
              'items': sub['items']
            };
          }
        }
      }
    }
    return null;
  }

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
}
//search using title : will be used in editor to check if title exists or no
