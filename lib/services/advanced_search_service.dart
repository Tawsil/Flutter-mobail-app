import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class AdvancedSearchService {
  static final AdvancedSearchService _instance = AdvancedSearchService._internal();
  factory AdvancedSearchService() => _instance;
  AdvancedSearchService._internal();

  late SharedPreferences _prefs;

  // تهيئة الخدمة
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // البحث مع فلاتر متقدمة
  Map<String, dynamic> searchWithFilters({
    required String query,
    String? type,
    String? location,
    String? dateFrom,
    String? dateTo,
    String? status,
    String? injuryDegree,
    bool? isFavorite,
  }) {
    Map<String, dynamic> results = {
      'martyrs': [],
      'injured': [],
      'prisoners': [],
      'total': 0,
      'hasResults': false,
    };

    // منطق البحث المطور
    // في التطبيق الحقيقي، ستربط بقاعدة البيانات

    if (query.isNotEmpty) {
      // البحث الأساسي
      // مثال: البحث في الأسماء
      // results['martyrs'] = _searchInMartyrs(query);
    }

    // تطبيق الفلاتر
    if (type != null && type.isNotEmpty) {
      _applyTypeFilter(results, type);
    }

    if (location != null && location.isNotEmpty) {
      _applyLocationFilter(results, location);
    }

    if (dateFrom != null || dateTo != null) {
      _applyDateFilter(results, dateFrom, dateTo);
    }

    if (status != null && status.isNotEmpty) {
      _applyStatusFilter(results, status);
    }

    if (injuryDegree != null && injuryDegree.isNotEmpty) {
      _applyInjuryDegreeFilter(results, injuryDegree);
    }

    if (isFavorite == true) {
      _applyFavoriteFilter(results);
    }

    // حساب النتائج
    results['total'] = (results['martyrs'] as List).length + 
                      (results['injured'] as List).length + 
                      (results['prisoners'] as List).length;
    results['hasResults'] = results['total'] > 0;

    return results;
  }

  // تطبيق فلتر النوع
  void _applyTypeFilter(Map<String, dynamic> results, String type) {
    Map<String, dynamic> filtered = {};
    
    switch (type.toLowerCase()) {
      case 'martyrs':
        filtered = {'martyrs': results['martyrs'], 'injured': [], 'prisoners': []};
        break;
      case 'injured':
        filtered = {'martyrs': [], 'injured': results['injured'], 'prisoners': []};
        break;
      case 'prisoners':
        filtered = {'martyrs': [], 'injured': [], 'prisoners': results['prisoners']};
        break;
    }
    
    results.addAll(filtered);
  }

  // تطبيق فلتر الموقع
  void _applyLocationFilter(Map<String, dynamic> results, String location) {
    // منطق البحث بالموقع
    // في التطبيق الحقيقي ستقوم بالبحث في قاعدة البيانات
    // مثال: البحث في محافظة فلسطينية
  }

  // تطبيق فلتر التاريخ
  void _applyDateFilter(Map<String, dynamic> results, String? from, String? to) {
    // منطق البحث بالتاريخ
    // من التعبير: from (YYYY-MM-DD) إلى to (YYYY-MM-DD)
  }

  // تطبيق فلتر الحالة
  void _applyStatusFilter(Map<String, dynamic> results, String status) {
    // فلترة حسب الحالة (قيد المراجعة، تم التوثيق، مرفوض)
  }

  // تطبيق فلتر درجة الإصابة
  void _applyInjuryDegreeFilter(Map<String, dynamic> results, String degree) {
    // فلترة حسب درجة الإصابة (خفيفة، متوسطة، خطيرة، حرجة)
  }

  // تطبيق فلتر المفضلة
  void _applyFavoriteFilter(Map<String, dynamic> results) {
    // عرض فقط العناصر المفضلة
  }

  // حفظ البحث الحديث
  Future<void> saveRecentSearch(String query) async {
    try {
      List<String> searches = _prefs.getStringList(AppConstants.keyRecentSearches) ?? [];
      
      // إزالة البحث إذا كان موجوداً مسبقاً
      searches.remove(query);
      
      // إضافة البحث في البداية
      searches.insert(0, query);
      
      // الاحتفاظ بآخر 10 عمليات بحث فقط
      if (searches.length > 10) {
        searches = searches.sublist(0, 10);
      }
      
      await _prefs.setStringList(AppConstants.keyRecentSearches, searches);
    } catch (e) {
      print('خطأ في حفظ البحث: $e');
    }
  }

  // الحصول على عمليات البحث الحديثة
  List<String> getRecentSearches() {
    return _prefs.getStringList(AppConstants.keyRecentSearches) ?? [];
  }

  // مسح تاريخ البحث
  Future<void> clearRecentSearches() async {
    await _prefs.remove(AppConstants.keyRecentSearches);
  }

  // حفظ إعدادات البحث
  Future<void> saveSearchFilters(Map<String, dynamic> filters) async {
    try {
      String filtersJson = json.encode(filters);
      await _prefs.setString(AppConstants.keySearchFilters, filtersJson);
    } catch (e) {
      print('خطأ في حفظ فلاتر البحث: $e');
    }
  }

  // الحصول على إعدادات البحث المحفوظة
  Map<String, dynamic>? getSavedFilters() {
    try {
      String? filtersJson = _prefs.getString(AppConstants.keySearchFilters);
      if (filtersJson != null) {
        return json.decode(filtersJson) as Map<String, dynamic>;
      }
    } catch (e) {
      print('خطأ في استعادة فلاتر البحث: $e');
    }
    return null;
  }

  // اقتراحات البحث الذكي
  List<String> getSearchSuggestions(String partialQuery) {
    List<String> suggestions = [];
    
    // اقتراحات من عمليات البحث السابقة
    List<String> recent = getRecentSearches();
    suggestions.addAll(recent.where((search) => 
      search.toLowerCase().contains(partialQuery.toLowerCase())
    ));
    
    // اقتراحات من أسماء الشهداء المعروفة
    suggestions.addAll(_getKnownNamesSuggestions(partialQuery));
    
    // اقتراحات من أسماء الأماكن
    suggestions.addAll(AppConstants.palestineRegions.where((region) => 
      region.toLowerCase().contains(partialQuery.toLowerCase())
    ));
    
    // إزالة التكرارات وترتيب
    suggestions = suggestions.toSet().toList();
    
    return suggestions.take(5).toList(); // إرجاع أقصى 5 اقتراحات
  }

  // اقتراحات من أسماء معروفة
  List<String> _getKnownNamesSuggestions(String query) {
    // في التطبيق الحقيقي، ستقرأ من قاعدة بيانات
    List<String> commonNames = [
      'أحمد محمد',
      'فاطمة علي',
      'محمد أحمد',
      'عائشة محمد',
      'خالد أحمد'
    ];
    
    return commonNames.where((name) => 
      name.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // إحصائيات البحث
  Map<String, dynamic> getSearchStatistics() {
    List<String> recentSearches = getRecentSearches();
    
    return {
      'totalSearches': recentSearches.length,
      'lastSearch': recentSearches.isNotEmpty ? recentSearches.first : null,
      'mostSearchedTerms': _getMostSearchedTerms(recentSearches),
      'searchTypes': _analyzeSearchTypes(recentSearches)
    };
  }

  // تحليل المصطلحات الأكثر بحثاً
  List<String> _getMostSearchedTerms(List<String> searches) {
    Map<String, int> termCounts = {};
    
    for (String search in searches) {
      List<String> terms = search.split(' ');
      for (String term in terms) {
        termCounts[term] = (termCounts[term] ?? 0) + 1;
      }
    }
    
    // ترتيب حسب العدد
    List<MapEntry<String, int>> sorted = termCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sorted.take(5).map((entry) => entry.key).toList();
  }

  // تحليل أنواع البحث
  Map<String, int> _analyzeSearchTypes(List<String> searches) {
    Map<String, int> typeCounts = {
      'اسم': 0,
      'موقع': 0,
      'تاريخ': 0,
      'حالة': 0,
      'أخرى': 0
    };
    
    for (String search in searches) {
      if (search.contains(AppConstants.palestineRegions.toString())) {
        typeCounts['موقع'] = (typeCounts['موقع'] ?? 0) + 1;
      } else if (search.contains(RegExp(r'\d{4}-\d{2}-\d{2}'))) {
        typeCounts['تاريخ'] = (typeCounts['تاريخ'] ?? 0) + 1;
      } else if (search.contains('قيد المراجعة') || search.contains('تم التوثيق')) {
        typeCounts['حالة'] = (typeCounts['حالة'] ?? 0) + 1;
      } else if (search.contains(' ') && search.split(' ').length > 1) {
        typeCounts['اسم'] = (typeCounts['اسم'] ?? 0) + 1;
      } else {
        typeCounts['أخرى'] = (typeCounts['أخرى'] ?? 0) + 1;
      }
    }
    
    return typeCounts;
  }
}
