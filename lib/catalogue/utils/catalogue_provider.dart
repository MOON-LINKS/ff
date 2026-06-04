import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/catalogue/utils/hive.dart';

final catalogueProvider =
    StateNotifierProvider<CatalogueNotifier, Map<String, dynamic>>((ref) {
  final hivePayload = getCatalogueData('payload') != null
      ? Map<String, dynamic>.from(getCatalogueData('payload'))
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

  final hiveFeatures = ('features') != null
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
        }
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
  }

  //update other info
  Future<void> addOrUpdateinfo(String key, dynamic value) async {
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
  Future<void> checkItems() async {}

  //category
  //add modify category
  Future<void> addOrModifyCategory(String categoryUuid, String title,
      String? iconKey, String? imageUrl) async {}
  //remove category
  Future<void> deleteCategory(String categoryUuid) async {}

  //subcategory
  //add modify subcategory
  Future<void> addOrModifySubcategory(
    String subcategoryUuid,
    String categoryUuid,
    String title,
  ) async {}
  //remove subcategory
  Future<void> deleteSubcategory(
      String subcategoryUuid, String categoryUuid) async {}

  //items
  //add modify item
  Future<void> addOrModifyItem(dynamic item) async {}
}
