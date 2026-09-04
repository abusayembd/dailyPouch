import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../features/image_compressor/domain/entities/compression_preset.dart';
import '../../features/pantry_expiry/domain/entities/pantry_item_entity.dart';
import '../../features/price_calculator/domain/entities/comparison_item_entity.dart';
import '../../features/subscription_tracker/domain/entities/subscription_entity.dart';

/// Type-safe localization lookup class for DailyPouch
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  String get languageCode => locale.languageCode;

  // -------------------------------------------------------------
  // Number & Currency Formatting Helpers
  // -------------------------------------------------------------
  String formatNumber(String input) {
    if (languageCode == 'bn') {
      const bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
      return input.split('').map((char) {
        final code = char.codeUnitAt(0);
        if (code >= 48 && code <= 57) {
          return bnDigits[code - 48];
        }
        return char;
      }).join('');
    } else if (languageCode == 'ar') {
      const arDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
      return input.split('').map((char) {
        final code = char.codeUnitAt(0);
        if (code >= 48 && code <= 57) {
          return arDigits[code - 48];
        }
        return char;
      }).join('');
    }
    return input;
  }

  String formatCurrency(double amount, String symbol) {
    final formatted = formatNumber(amount.toStringAsFixed(2));
    return '$symbol$formatted';
  }

  String formatYearlyBurn(double amount, String symbol) {
    final val = formatCurrency(amount, symbol);
    final suffix = _localizedValue({
      'en': '/yr',
      'bn': '/বছর',
      'es': '/año',
      'fr': '/an',
      'de': '/Jahr',
      'hi': '/वर्ष',
      'ar': '/سنة',
      'zh': '/年',
      'ja': '/年',
    });
    return '$val$suffix';
  }

  String formatDate(DateTime date) {
    final year = formatNumber(date.year.toString());
    final day = formatNumber(date.day.toString());

    switch (languageCode) {
      case 'bn':
        const bnMonths = [
          'জানু', 'ফেব্রু', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
          'জুলাই', 'আগস্ট', 'সেপ্টে', 'অক্টো', 'নভে', 'ডিসে'
        ];
        final month = bnMonths[date.month - 1];
        return '$day $month, $year';
      case 'es':
        const esMonths = [
          'ene', 'feb', 'mar', 'abr', 'may', 'jun',
          'jul', 'ago', 'sept', 'oct', 'nov', 'dic'
        ];
        return '$day ${esMonths[date.month - 1]} $year';
      case 'fr':
        const frMonths = [
          'janv', 'févr', 'mars', 'avr', 'mai', 'juin',
          'juil', 'août', 'sept', 'oct', 'nov', 'déc'
        ];
        return '$day ${frMonths[date.month - 1]} $year';
      case 'de':
        const deMonths = [
          'Jan', 'Feb', 'März', 'Apr', 'Mai', 'Juni',
          'Juli', 'Aug', 'Sept', 'Okt', 'Nov', 'Dez'
        ];
        return '$day. ${deMonths[date.month - 1]} $year';
      case 'hi':
        const hiMonths = [
          'जनवरी', 'फ़रवरी', 'मार्च', 'अप्रैल', 'मई', 'जून',
          'जुलाई', 'अगस्त', 'सितंबर', 'अक्टूबर', 'नवंबर', 'दिसंबर'
        ];
        return '$day ${hiMonths[date.month - 1]} $year';
      case 'ar':
        const arMonths = [
          'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
          'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
        ];
        return '$day ${arMonths[date.month - 1]} $year';
      case 'zh':
        return '$year年${formatNumber(date.month.toString())}月$day日';
      case 'ja':
        return '$year年${formatNumber(date.month.toString())}月$day日';
      default:
        return DateFormat('MMM d, yyyy').format(date);
    }
  }

  String formatDateTime(DateTime date) {
    if (languageCode == 'en') {
      return DateFormat('MMM d, h:mm a').format(date);
    }
    final timeStr = DateFormat('h:mm a').format(date);
    return '${formatDate(date)}, ${formatNumber(timeStr)}';
  }

  String formatDateRange(DateTime start, DateTime end) {
    return '${formatDate(start)} - ${formatDate(end)}';
  }

  String formatDuration(int totalSeconds) {
    final mins = totalSeconds ~/ 60;
    final secs = totalSeconds % 60;
    final minsStr = formatNumber(mins.toString());
    final secsStr = formatNumber(secs.toString().padLeft(2, '0'));
    return '${minsStr}m ${secsStr}s';
  }

  // -------------------------------------------------------------
  // 1. Hub Launcher & Settings
  // -------------------------------------------------------------
  String get appTitle => _localizedValue({
        'en': 'DailyPouch',
        'bn': 'ডেইলি পাউচ',
        'es': 'DailyPouch',
        'fr': 'DailyPouch',
        'de': 'DailyPouch',
        'hi': 'डेली पाउच',
        'ar': 'ديلي باوتش',
        'zh': 'DailyPouch',
        'ja': 'DailyPouch',
      });

  String get appSubtitle => _localizedValue({
        'en': 'Offline Life Tools',
        'bn': 'অফলাইন লাইফ টুলস',
        'es': 'Herramientas de Vida Offline',
        'fr': 'Outils de Vie Hors Ligne',
        'de': 'Offline Lebenswerkzeuge',
        'hi': 'ऑफ़लाइन लाइफ़ टूल्स',
        'ar': 'أدوات الحياة بدون إنترنت',
        'zh': '离线生活工具箱',
        'ja': 'オフライン生活ツール',
      });

  String get searchHint => _localizedValue({
        'en': 'Search utilities (e.g. bills, grocery, timer...)',
        'bn': 'টুল খুঁজুন (যেমন: বিল, বাজার, টাইমার...)',
        'es': 'Buscar utilidades (ej. facturas, súper, temporizador...)',
        'fr': 'Rechercher des utilitaires...',
        'de': 'Werkzeuge suchen (z.B. Rechnungen, Einkaufen, Timer...)',
        'hi': 'टूल खोजें (जैसे बिल, किराना, टाइमर...)',
        'ar': 'البحث عن الأدوات (مثل الفواتير، التسوق، المؤقت...)',
        'zh': '搜索工具 (如账单、单价、计时器...)',
        'ja': 'ツールを検索 (請求書、買い物、タイマーなど)',
      });

  String get open => _localizedValue({
        'en': 'Open',
        'bn': 'খুলুন',
        'es': 'Abrir',
        'fr': 'Ouvrir',
        'de': 'Öffnen',
        'hi': 'खोलें',
        'ar': 'فتح',
        'zh': '打开',
        'ja': '開く',
      });

  String get allTools => _localizedValue({
        'en': 'All',
        'bn': 'সকল',
        'es': 'Todo',
        'fr': 'Tous',
        'de': 'Alle',
        'hi': 'सभी',
        'ar': 'الكل',
        'zh': '全部',
        'ja': 'すべて',
      });

  String get categoryFinance => _localizedValue({
        'en': 'Finance',
        'bn': 'অর্থনীতি',
        'es': 'Finanzas',
        'fr': 'Finance',
        'de': 'Finanzen',
        'hi': 'वित्त',
        'ar': 'المالية',
        'zh': '财务',
        'ja': 'ファイナンス',
      });

  String get categoryKitchen => _localizedValue({
        'en': 'Kitchen & Home',
        'bn': 'রান্নাঘর ও ঘরবাড়ি',
        'es': 'Cocina y Hogar',
        'fr': 'Cuisine & Maison',
        'de': 'Küche & Haushalt',
        'hi': 'रसोई और घर',
        'ar': 'المطبخ والمنزل',
        'zh': '厨房与居家',
        'ja': 'キッチン＆ホーム',
      });

  String get categoryTools => _localizedValue({
        'en': 'Media & Tools',
        'bn': 'মিডিয়া ও টুলস',
        'es': 'Medios y Herramientas',
        'fr': 'Médias & Outils',
        'de': 'Medien & Werkzeuge',
        'hi': 'मीडिया व टूल्स',
        'ar': 'الوسائط والأدوات',
        'zh': '媒体与工具',
        'ja': 'メディア＆ツール',
      });

  String get categoryFitness => _localizedValue({
        'en': 'Fitness',
        'bn': 'ফিটনেস',
        'es': 'Fitness',
        'fr': 'Fitness',
        'de': 'Fitness',
        'hi': 'स्वास्थ्य/फिटनेस',
        'ar': 'اللياقة البدنية',
        'zh': '健身运动',
        'ja': 'フィットネス',
      });

  String get settingsAndAbout => _localizedValue({
        'en': 'Settings & About',
        'bn': 'সেটিংস ও পরিচিতি',
        'es': 'Ajustes y Acerca de',
        'fr': 'Paramètres et À propos',
        'de': 'Einstellungen & Über',
        'hi': 'सेटिंग्स और विवरण',
        'ar': 'الإعدادات والمعلومات',
        'zh': '设置与关于',
        'ja': '設定とアプリ情報',
      });

  String get preferences => _localizedValue({
        'en': 'PREFERENCES & HUB OVERVIEW',
        'bn': 'পছন্দসমূহ ও হাব পরিচিতি',
        'es': 'PREFERENCIAS Y VISTA GENERAL',
        'fr': 'PRÉFÉRENCES ET VUE D\'ENSEMBLE',
        'de': 'EINSTELLUNGEN & ÜBERSICHT',
        'hi': 'प्राथमिकताएं और अवलोकन',
        'ar': 'التفضيلات ونظرة عامة',
        'zh': '偏好设置与总览',
        'ja': '環境設定と概要',
      });

  String get centralCurrency => _localizedValue({
        'en': 'CENTRAL CURRENCY',
        'bn': 'প্রধান মুদ্রা (কারেন্সি)',
        'es': 'MONEDA PRINCIPAL',
        'fr': 'DEVISE CENTRALE',
        'de': 'HAUPTWÄHRUNG',
        'hi': 'केंद्रीय मुद्रा',
        'ar': 'العملة الرئيسية',
        'zh': '默认货币',
        'ja': '基準通貨',
      });

  String get centralCurrencyDesc => _localizedValue({
        'en': 'Select your default currency. Applied across bill tracking, shopping calculators, and budget envelopes.',
        'bn': 'আপনার ডিফল্ট মুদ্রা নির্বাচন করুন। এটি বিল ট্র্যাকার, শপিং ক্যালকুলেটর ও বাজেটে স্বয়ংক্রিয়ভাবে ব্যবহৃত হবে।',
        'es': 'Selecciona tu moneda predeterminada para facturas, calculadora y presupuestos.',
        'fr': 'Sélectionnez votre devise par défaut pour le suivi des factures et les calculs.',
        'de': 'Wählen Sie Ihre Standardwährung für Rechnungen, Rechner und Budgets.',
        'hi': 'अपनी डिफ़ॉल्ट मुद्रा चुनें। यह बिल ट्रैकर, कैलकुलेटर और बजट में लागू होगी।',
        'ar': 'حدد عملتك الافتراضية. سيتم تطبيقها عبر تتبع الفواتير والآلات الحاسبة والميزانيات.',
        'zh': '选择您的默认货币，将应用于账单跟踪、购物计算器和预算信封。',
        'ja': '請求書管理、買い物計算機、予算で適用されるデフォルト通貨を選択します。',
      });

  String get appLanguageLabel => _localizedValue({
        'en': 'APP LANGUAGE',
        'bn': 'অ্যাপের ভাষা',
        'es': 'IDIOMA DE LA APP',
        'fr': 'LANGUE DE L\'APPLICATION',
        'de': 'APP-SPRACHE',
        'hi': 'ऐप की भाषा',
        'ar': 'لغة التطبيق',
        'zh': '应用语言',
        'ja': 'アプリの言語',
      });

  String get appLanguageDesc => _localizedValue({
        'en': 'Choose your preferred language for the user interface.',
        'bn': 'ব্যবহারকারী ইন্টারফেসের জন্য আপনার পছন্দের ভাষা নির্বাচন করুন।',
        'es': 'Elige tu idioma preferido para la interfaz de usuario.',
        'fr': 'Choisissez votre langue préférée pour l\'interface utilisateur.',
        'de': 'Wählen Sie Ihre bevorzugte Sprache für die Benutzeroberfläche.',
        'hi': 'यूज़र इंटरफ़ेस के लिए अपनी पसंदीदा भाषा चुनें.',
        'ar': 'اختر لغتك المفضلة لواجهة المستخدم.',
        'zh': '选择您偏好的用户界面语言。',
        'ja': 'ユーザーインターフェースで使用する言語を選択してください。',
      });

  String get aboutTheApp => _localizedValue({
        'en': 'ABOUT THE APP',
        'bn': 'অ্যাপ সম্পর্কে',
        'es': 'ACERCA DE LA APLICACIÓN',
        'fr': 'À PROPOS DE L\'APPLICATION',
        'de': 'ÜBER DIE APP',
        'hi': 'ऐप के बारे में',
        'ar': 'حول التطبيق',
        'zh': '关于应用',
        'ja': 'アプリについて',
      });

  String get aboutAppDesc => _localizedValue({
        'en': 'DailyPouch is a small pocket container holding all your daily essentials — 6 fast, purposeful offline utility tools designed to replace cluttered single-use apps with an intuitive on-device experience.',
        'bn': 'ডেইলি পাউচ আপনার সমস্ত দৈনন্দিন প্রয়োজনীয় জিনিস রাখার একটি ছোট পকেট কন্টেইনার — একাধিক অ্যাপের ঝামেলা কমিয়ে সম্পূর্ণ অফলাইনে কাজ করে এমন ৬টি দ্রুত ও নির্ভরযোগ্য টুলস।',
        'es': 'DailyPouch es un pequeño contenedor de bolsillo para tus elementos esenciales diarios: 6 herramientas offline rápidas e intuitivas.',
        'fr': 'DailyPouch est une petite pochette contenant tous vos essentiels du quotidien : 6 outils hors ligne rapides et intuitifs.',
        'de': 'DailyPouch ist eine kleine Tasche für alle wichtigen Dinge des Alltags – 6 schnelle und intuitive Offline-Werkzeuge.',
        'hi': 'डेली पाउच आपके सभी दैनिक आवश्यक चीजों को रखने वाला एक छोटा पॉकेट कंटेनर है — 6 तेज़ और सहज ऑफ़लाइन टूल्स।',
        'ar': 'ديلي باوتش هو حافظة جيب صغيرة تجمع جميع أساسياتك اليومية — 6 أدوات سريعة ومفيدة تعمل بدون إنترنت تماماً.',
        'zh': 'DailyPouch 是装载您日常必需品的口袋工具袋——6 款快速、专注且完全离线运行的实用工具集。',
        'ja': 'DailyPouchは毎日の必需品をすべて詰め込んだ小さなポケットポーチです。完全オフラインで動作する6つの実用的なツール集。',
      });

  String get done => _localizedValue({
        'en': 'Done',
        'bn': 'সম্পন্ন',
        'es': 'Listo',
        'fr': 'Terminé',
        'de': 'Fertig',
        'hi': 'पूर्ण',
        'ar': 'تم',
        'zh': '完成',
        'ja': '完了',
      });

  String get cancel => _localizedValue({
        'en': 'Cancel',
        'bn': 'বাতিল',
        'es': 'Cancelar',
        'fr': 'Annuler',
        'de': 'Abbrechen',
        'hi': 'रद्द करें',
        'ar': 'إلغاء',
        'zh': '取消',
        'ja': 'キャンセル',
      });

  String get delete => _localizedValue({
        'en': 'Delete',
        'bn': 'মুছে ফেলুন',
        'es': 'Eliminar',
        'fr': 'Supprimer',
        'de': 'Löschen',
        'hi': 'हटाएं',
        'ar': 'حذف',
        'zh': '删除',
        'ja': '削除',
      });

  String get activate => _localizedValue({
        'en': 'Activate',
        'bn': 'সক্রিয় করুন',
        'es': 'Activar',
        'fr': 'Activer',
        'de': 'Aktivieren',
        'hi': 'सक्रिय करें',
        'ar': 'تفعيل',
        'zh': '激活',
        'ja': '有効化',
      });

  String get noUtilityFound => _localizedValue({
        'en': 'No Utility Found',
        'bn': 'কোনো টুল পাওয়া যায়নি',
        'es': 'No se encontró utilidad',
        'fr': 'Aucun utilitaire trouvé',
        'de': 'Kein Werkzeug gefunden',
        'hi': 'कोई टूल नहीं मिला',
        'ar': 'لم يتم العثور على أداة',
        'zh': '未找到工具',
        'ja': 'ツールが見つかりません',
      });

  String get resetFilters => _localizedValue({
        'en': 'Reset Filters',
        'bn': 'ফিল্টার রিসেট করুন',
        'es': 'Restablecer filtros',
        'fr': 'Réinitialiser les filtres',
        'de': 'Filter zurücksetzen',
        'hi': 'फ़िल्टर रीसेट करें',
        'ar': 'إعادة تعيين الفلاتر',
        'zh': '重置筛选',
        'ja': 'フィルターをリセット',
      });

  // -------------------------------------------------------------
  // 2. 6 FEATURE MODULE CARDS LOCALIZATION (DYNAMIC BY ID)
  // -------------------------------------------------------------
  String getModuleTitle(String id) {
    switch (id) {
      case 'subscription_tracker':
        return _localizedValue({
          'en': 'Subscription Tracker',
          'bn': 'সাবস্ক্রিপশন ট্র্যাকার',
          'es': 'Rastreador de Suscripciones',
          'fr': 'Suivi des Abonnements',
          'de': 'Abo-Tracker',
          'hi': 'सब्सक्रिप्शन ट्रैकर',
          'ar': 'تتبع الاشتراكات',
          'zh': '周期订阅管理',
          'ja': 'サブスク管理',
        });
      case 'price_calculator':
        return _localizedValue({
          'en': 'Smart Price Compare',
          'bn': 'স্মার্ট প্রাইস কম্পেয়ার',
          'es': 'Comparador de Precios',
          'fr': 'Comparateur de Prix',
          'de': 'Smarter Preisvergleich',
          'hi': 'स्मार्ट मूल्य तुलना',
          'ar': 'مقارنة الأسعار الذكية',
          'zh': '智能比价助手',
          'ja': 'スマート価格比較',
        });
      case 'pantry_expiry':
        return _localizedValue({
          'en': 'Pantry & Medicine',
          'bn': 'প্যান্ট্রি ও ওষুধ ট্র্যাকার',
          'es': 'Despensa y Medicinas',
          'fr': 'Garde-manger & Médicaments',
          'de': 'Vorratskammer & Medizin',
          'hi': 'रसोई व दवा एक्सपायरी',
          'ar': 'مؤن المنزل والأدوية',
          'zh': '食品与药品管理',
          'ja': '食品庫＆常備薬管理',
        });
      case 'image_compressor':
        return _localizedValue({
          'en': 'IMG & PDF Compressor',
          'bn': 'ছবি ও পিডিএফ কম্প্রেসর',
          'es': 'Compresor de Imágenes y PDF',
          'fr': 'Compresseur Image & PDF',
          'de': 'Bild & PDF Kompressor',
          'hi': 'फोटो व पीडीएफ कंप्रेसर',
          'ar': 'ضغط الصور ومستندات PDF',
          'zh': '图片与PDF压缩工具',
          'ja': '画像＆PDF圧縮ツール',
        });
      case 'micro_budgeter':
        return _localizedValue({
          'en': 'Single-Goal Budgeter',
          'bn': 'একক-লক্ষ্য বাজেট',
          'es': 'Micro-Presupuesto',
          'fr': 'Micro-Budget par Objectif',
          'de': 'Einzelziel-Budgeter',
          'hi': 'एकल-लक्ष्य बजट',
          'ar': 'ميزانية الهدف الواحد',
          'zh': '单一目标微预算',
          'ja': '目標別マイクロ予算',
        });
      case 'interval_timer':
        return _localizedValue({
          'en': 'Interval & Rest Timer',
          'bn': 'ইন্টারভাল ও রেস্ট টাইমার',
          'es': 'Temporizador de Intervalos y Descanso',
          'fr': 'Minuteur d\'Intervalles & Repos',
          'de': 'Intervall- & Pausen-Timer',
          'hi': 'इंटरवल व रेस्ट टाइमर',
          'ar': 'مؤقت الفترات والراحة للتمارين',
          'zh': '间歇训练与休息计时器',
          'ja': 'インターバル＆レストタイマー',
        });
      default:
        return id;
    }
  }

  String getModuleDescription(String id) {
    switch (id) {
      case 'subscription_tracker':
        return _localizedValue({
          'en': 'Track recurring expenses, burn rate & renewal alerts',
          'bn': 'নিয়মিত খরচ, মাসিক ব্যয় ও নবায়ন নোটিফিকেশন ট্র্যাক করুন',
          'es': 'Rastrea gastos recurrentes, gasto mensual y alertas de renovación',
          'fr': 'Suivez les dépenses récurrentes, le coût mensuel et les alertes',
          'de': 'Wiederkehrende Kosten, Monatsausgaben & Fristen im Blick',
          'hi': 'आवर्ती खर्च, मासिक बजट और नवीनीकरण अलर्ट ट्रैक करें',
          'ar': 'تتبع النفقات المتكررة ومعدل الإنفاق وتنبيهات التجديد',
          'zh': '跟踪周期性开支、每月消耗率及续费到期提醒',
          'ja': '定期支出、月間コスト、更新リマインダーを管理',
        });
      case 'price_calculator':
        return _localizedValue({
          'en': 'Side-by-side grocery unit comparison & best deal finder',
          'bn': 'সুপারমার্কেটের পণ্য তুলনা করে সেরা সাশ্রয়ী ডিল খুঁজুন',
          'es': 'Comparación lado a lado de unidades y mejor oferta',
          'fr': 'Comparez les prix unitaires et trouvez la meilleure offre',
          'de': 'Vergleich von Einheiten im Supermarkt & Preis-Leistungssieger',
          'hi': 'किराना सामानों की तुलना करें और सर्वोत्तम डील पाएं',
          'ar': 'مقارنة وحدات البقالة والعثور على الصفقة الأفضل',
          'zh': '并排对比超市商品不同规格的实际单价并锁定最佳优惠',
          'ja': 'グラム/ml単位でスーパーの価格を比較し最安値を判定',
        });
      case 'pantry_expiry':
        return _localizedValue({
          'en': 'Zone tracking, freshness badges & spoilage warnings',
          'bn': '৪টি জোনে খাবার ও ওষুধের মেয়াদ এবং স্পয়েলেজ নোটিফিকেশন',
          'es': 'Seguimiento por zonas, frescura y alertas de caducidad',
          'fr': 'Suivi par zones, état de fraîcheur et alertes d\'expiration',
          'de': 'Zonen-Verwaltung, Frische-Status & Verfallswarnungen',
          'hi': 'ज़ोन ट्रैकिंग, ताज़गी स्थिति और एक्सपायरी चेतावनी',
          'ar': 'تتبع المناطق وحالة الصلاحية وتنبيهات التلف',
          'zh': '分区收纳、保质期倒计时状态与临期预警通知',
          'ja': 'ゾーン別管理、鮮度バッジ、賞味期限切れ前の通知',
        });
      case 'image_compressor':
        return _localizedValue({
          'en': 'Target-size photo squisher, passport crop & PDF merge',
          'bn': 'নির্দিষ্ট KB সাইজে ছবি কম্প্রেস, পাসপোর্ট ক্রপ ও পিডিএফ তৈরি',
          'es': 'Comprime imágenes a KB exactos, recorte de pasaporte y PDF',
          'fr': 'Compression en KB cibles, recadrage passeport et fusion PDF',
          'de': 'Fotos auf Ziel-KB komprimieren, Passbild-Zuschnitt & PDF',
          'hi': 'सटीक KB में फोटो कंप्रेस, पासपोर्ट साइज क्रॉप व पीडीएफ',
          'ar': 'ضغط الصور لحجم محدد، قص صور الجوازات وتجميع PDF',
          'zh': '按目标KB大小精准压缩图片、证件照裁剪及生成PDF',
          'ja': '指定KBへの画像圧縮、パスポート写真切り抜き、PDF作成',
        });
      case 'micro_budgeter':
        return _localizedValue({
          'en': 'Isolated budget envelopes, runway gauge & quick log',
          'bn': 'বাজেট খাম, দৈনিক খরচের রানওয়ে মিটার ও দ্রুত এন্ট্রি',
          'es': 'Sobres de presupuesto, indicador diario y registro rápido',
          'fr': 'Enveloppes de budget, jauge quotidienne et saisie rapide',
          'de': 'Umschlag-Budgetierung, Tagesausgaben-Gauge & Schnell-Log',
          'hi': 'अलग-अलग बजट लिफ़ाफ़े, दैनिक खर्च सीमा और त्वरित लॉग',
          'ar': 'أظرف ميزانية منفصلة ومقياس يومي آمن وتسجيل سريع',
          'zh': '独立目标信封预算、每日安全消费仪表盘及秒级记账',
          'ja': '封筒型予算分け、日別利用可能枠、ワンタップ支出記録',
        });
      case 'interval_timer':
        return _localizedValue({
          'en': 'Custom workout intervals, wakelock & audio chimes',
          'bn': 'কাস্টম ওয়ার্কআউট ইন্টারভাল, ওয়েক-লক ও অডিও অ্যালার্ম',
          'es': 'Intervalos de entrenamiento personalizados, sonido y pantalla activa',
          'fr': 'Intervalles personnalisés, signaux audio et écran actif',
          'de': 'Intervall-Training, Audio-Signale & Display-Aktivierung',
          'hi': 'कस्टम वर्कआउट इंटरवल, स्क्रीन वेकलॉक और ऑडियो बीप',
          'ar': 'فترات تمارين مخصصة مع إشارات صوتية وإبقاء الشاشة مفعلة',
          'zh': '自定义健身间歇组、常亮防息屏及节拍提示音',
          'ja': 'カスタムワークアウト間隔、画面常時点灯、チャイム音',
        });
      default:
        return '';
    }
  }

  String getModuleBadge(String id) {
    switch (id) {
      case 'subscription_tracker':
        return categoryFinance.toUpperCase();
      case 'price_calculator':
        return _localizedValue({
          'en': 'GROCERY',
          'bn': 'বাজার',
          'es': 'COMPRAS',
          'fr': 'ÉPICERIE',
          'de': 'EINKAUF',
          'hi': 'किराना',
          'ar': 'التسوق',
          'zh': '购物',
          'ja': '買い物',
        });
      case 'pantry_expiry':
        return _localizedValue({
          'en': 'PANTRY',
          'bn': 'প্যান্ট্রি',
          'es': 'DESPENSA',
          'fr': 'RÉSERVE',
          'de': 'VORRAT',
          'hi': 'भंडार',
          'ar': 'المؤن',
          'zh': '储物',
          'ja': '保存食',
        });
      case 'image_compressor':
        return _localizedValue({
          'en': 'TOOLS & PDF',
          'bn': 'টুলস ও পিডিএফ',
          'es': 'HERRAMIENTAS',
          'fr': 'OUTILS & PDF',
          'de': 'WERKZEUGE',
          'hi': 'টুल्स व পিডিএফ',
          'ar': 'أدوات وPDF',
          'zh': '工具与PDF',
          'ja': 'ツール＆PDF',
        });
      case 'micro_budgeter':
        return _localizedValue({
          'en': 'BUDGET',
          'bn': 'বাজেট',
          'es': 'PRESUPUESTO',
          'fr': 'BUDGET',
          'de': 'BUDGET',
          'hi': 'बजट',
          'ar': 'الميزانية',
          'zh': '预算',
          'ja': '予算',
        });
      case 'interval_timer':
        return _localizedValue({
          'en': 'FITNESS',
          'bn': 'ফিটনেস',
          'es': 'FITNESS',
          'fr': 'FITNESS',
          'de': 'FITNESS',
          'hi': 'फिटनेस',
          'ar': 'اللياقة',
          'zh': '健身',
          'ja': 'フィットネス',
        });
      default:
        return '';
    }
  }

  // -------------------------------------------------------------
  // 3. Subscription Tracker
  // -------------------------------------------------------------
  String get subTrackerTitle => _localizedValue({
        'en': 'Subscriptions',
        'bn': 'সাবস্ক্রিপশন ও বিল',
        'es': 'Suscripciones',
        'fr': 'Abonnements',
        'de': 'Abonnements',
        'hi': 'सब्सक्रिप्शन',
        'ar': 'الاشتراكات',
        'zh': '订阅管理',
        'ja': 'サブスクリプション',
      });

  String get subTrackerSubtitle => _localizedValue({
        'en': 'Recurring Expense Tracker',
        'bn': 'নিয়মিত খরচ ও বিল ট্র্যাকার',
        'es': 'Rastreador de Gastos Recurrentes',
        'fr': 'Suivi des Dépenses Récurrentes',
        'de': 'Verwaltung Wiederkehrender Kosten',
        'hi': 'आवर्ती व्यय ट्रैकर',
        'ar': 'تتبع المصاريف المتكررة',
        'zh': '周期性账单管理',
        'ja': '定期支出トラッカー',
      });

  String get monthlyCashBurn => _localizedValue({
        'en': 'MONTHLY CASH BURN',
        'bn': 'মাসিক মোট খরচ',
        'es': 'GASTO MENSUAL',
        'fr': 'DÉPENSE MENSUELLE',
        'de': 'MONATLICHE AUSGABEN',
        'hi': 'मासिक कुल खर्च',
        'ar': 'إجمالي الإنفاق الشهري',
        'zh': '每月支出总额',
        'ja': '月間支出額',
      });

  String get projectedAnnualCost => _localizedValue({
        'en': 'Projected Annual Cost',
        'bn': 'সম্ভাব্য বার্ষিক খরচ',
        'es': 'Costo Anual Proyectado',
        'fr': 'Coût Annuel Estimé',
        'de': 'Geschätzte Jahreskosten',
        'hi': 'अनुमानित वार्षिक लागत',
        'ar': 'التكلفة السنوية المتوقعة',
        'zh': '预计年度支出',
        'ja': '年間予測コスト',
      });

  String get addBill => _localizedValue({
        'en': 'Add Bill',
        'bn': 'বিল যোগ করুন',
        'es': 'Agregar Factura',
        'fr': 'Ajouter Facture',
        'de': 'Rechnung hinzufügen',
        'hi': 'बिल जोड़ें',
        'ar': 'إضافة فاتورة',
        'zh': '添加账单',
        'ja': '請求を追加',
      });

  String get addSubscription => _localizedValue({
        'en': 'Add Subscription',
        'bn': 'সাবস্ক্রিপশন যোগ করুন',
        'es': 'Agregar Suscripción',
        'fr': 'Ajouter Abonnement',
        'de': 'Abo hinzufügen',
        'hi': 'सब्सक्रिप्शन जोड़ें',
        'ar': 'إضافة اشتراك',
        'zh': '添加订阅',
        'ja': 'サブスクを追加',
      });

  String get editSubscription => _localizedValue({
        'en': 'Edit Subscription',
        'bn': 'সাবস্ক্রিপশন সম্পাদনা',
        'es': 'Editar Suscripción',
        'fr': 'Modifier l\'abonnement',
        'de': 'Abo bearbeiten',
        'hi': 'सब्सक्रिप्शन संपादित करें',
        'ar': 'تعديل الاشتراك',
        'zh': '编辑订阅',
        'ja': 'サブスクを編集',
      });

  String get serviceNameLabel => _localizedValue({
        'en': 'Service / Subscription Name',
        'bn': 'সার্ভিস বা সাবস্ক্রিপশনের নাম',
        'es': 'Nombre del Servicio o Suscripción',
        'fr': 'Nom du Service / Abonnement',
        'de': 'Name des Dienstes / Abos',
        'hi': 'सेवा / सब्सक्रिप्शन का नाम',
        'ar': 'اسم الخدمة أو الاشتراك',
        'zh': '服务或订阅名称',
        'ja': 'サービス・サブスク名',
      });

  String get serviceNameHint => _localizedValue({
        'en': 'e.g. Netflix, Spotify, Gym, AWS',
        'bn': 'যেমন: নেটফ্লিক্স, স্পটিফাই, জিম',
        'es': 'ej. Netflix, Spotify, Gimnasio',
        'fr': 'ex. Netflix, Spotify, Salle de sport',
        'de': 'z.B. Netflix, Spotify, Fitnessstudio',
        'hi': 'जैसे: नेटफ्लिक्स, स्पॉटीफ़ाई, जिम',
        'ar': 'مثل Netflix، Spotify، النادي',
        'zh': '如 Netflix, Spotify, 健身房',
        'ja': '例: Netflix, Spotify, ジム',
      });

  String get enterNameValidation => _localizedValue({
        'en': 'Please enter a name',
        'bn': 'দয়া করে একটি নাম লিখুন',
        'es': 'Por favor ingresa un nombre',
        'fr': 'Veuillez saisir un nom',
        'de': 'Bitte geben Sie einen Namen ein',
        'hi': 'कृपया एक नाम दर्ज करें',
        'ar': 'يرجى إدخال اسم',
        'zh': '请输入名称',
        'ja': '名前を入力してください',
      });

  String get amountLabel => _localizedValue({
        'en': 'Amount',
        'bn': 'পরিমাণ / মূল্য',
        'es': 'Monto',
        'fr': 'Montant',
        'de': 'Betrag',
        'hi': 'राशि',
        'ar': 'المبلغ',
        'zh': '金额',
        'ja': '金額',
      });

  String get enterAmountValidation => _localizedValue({
        'en': 'Enter amount',
        'bn': 'মূল্য লিখুন',
        'es': 'Ingresa el monto',
        'fr': 'Entrez le montant',
        'de': 'Betrag eingeben',
        'hi': 'राशि दर्ज करें',
        'ar': 'أدخل المبلغ',
        'zh': '请输入金额',
        'ja': '金額を入力してください',
      });

  String get enterValidAmountValidation => _localizedValue({
        'en': 'Enter valid amount > 0',
        'bn': 'সঠিক পরিমাণ (> ০) লিখুন',
        'es': 'Monto válido > 0',
        'fr': 'Montant valide > 0',
        'de': 'Gültigen Betrag > 0 eingeben',
        'hi': 'वैध राशि दर्ज करें > 0',
        'ar': 'أدخل مبلغاً صالحاً > 0',
        'zh': '请输入大于0的有效金额',
        'ja': '0より大きい金額を入力してください',
      });

  String get billingCycleLabel => _localizedValue({
        'en': 'Billing Cycle',
        'bn': 'বিলিং চক্র',
        'es': 'Ciclo de Facturación',
        'fr': 'Cycle de Facturation',
        'de': 'Abrechnungszeitraum',
        'hi': 'बिलिंग चक्र',
        'ar': 'دورة الفوترة',
        'zh': '计费周期',
        'ja': '請求サイクル',
      });

  String get categoryLabel => _localizedValue({
        'en': 'Category',
        'bn': 'ক্যাটাগরি',
        'es': 'Categoría',
        'fr': 'Catégorie',
        'de': 'Kategorie',
        'hi': 'श्रेणी',
        'ar': 'الفئة',
        'zh': '类别',
        'ja': 'カテゴリー',
      });

  String get nextBillingDateLabel => _localizedValue({
        'en': 'Next Billing Date',
        'bn': 'পরবর্তী বিলের তারিখ',
        'es': 'Próxima Facturación',
        'fr': 'Prochaine Facturation',
        'de': 'Nächste Fälligkeit',
        'hi': 'अगली बिलिंग तिथि',
        'ar': 'تاريخ الفاتورة القادمة',
        'zh': '下次扣费日期',
        'ja': '次回請求日',
      });

  String get renewalReminderLabel => _localizedValue({
        'en': 'Renewal Reminder',
        'bn': 'নবায়ন রিমাইন্ডার',
        'es': 'Recordatorio de Renovación',
        'fr': 'Rappel de Renouvellement',
        'de': 'Erinnerung vor Fälligkeit',
        'hi': 'नवीनीकरण अनुस्मारक',
        'ar': 'تنبيه التجديد',
        'zh': '续费提醒',
        'ja': '更新リマインダー',
      });

  String daysBefore(int days) {
    final numStr = formatNumber(days.toString());
    return _localizedValue({
      'en': '$numStr Days Before',
      'bn': '$numStr দিন আগে',
      'es': '$numStr Días Antes',
      'fr': '$numStr Jours Avant',
      'de': '$numStr Tage Vorher',
      'hi': '$numStr दिन पहले',
      'ar': 'قبل $numStr أيام',
      'zh': '提前 $numStr 天',
      'ja': '$numStr日前',
    });
  }

  String get oneDayBeforeUrgent => _localizedValue({
        'en': '1 Day Before (Urgent)',
        'bn': '১ দিন আগে (জরুরি)',
        'es': '1 Día Antes (Urgente)',
        'fr': '1 Jour Avant (Urgent)',
        'de': '1 Tag Vorher (Dringend)',
        'hi': '1 दिन पहले (अति आवश्यक)',
        'ar': 'قبل يوم واحد (عاجل)',
        'zh': '提前 1 天 (紧急)',
        'ja': '1日前 (緊急)',
      });

  String get paidCycleDesc => _localizedValue({
        'en': 'Current cycle is marked as paid',
        'bn': 'বর্তমান কিস্তির বিল পরিশোধিত হিসেবে চিহ্নিত',
        'es': 'El ciclo actual está marcado como pagado',
        'fr': 'Le cycle actuel est marqué comme payé',
        'de': 'Aktueller Zeitraum als bezahlt markiert',
        'hi': 'वर्तमान चक्र को भुगतान किया गया चिह्नित किया गया है',
        'ar': 'تم تحديد الدورة الحالية كمدفوعة',
        'zh': '本期账单已标记为已支付',
        'ja': '現在のサイクルは支払い済みです',
      });

  String get unpaidCycleDesc => _localizedValue({
        'en': 'Current cycle is unpaid (default)',
        'bn': 'বর্তমান কিস্তির বিল অপরিশোধিত (ডিফল্ট)',
        'es': 'El ciclo actual está pendiente (por defecto)',
        'fr': 'Le cycle actuel est impayé (par défaut)',
        'de': 'Aktueller Zeitraum ausstehend (Standard)',
        'hi': 'वर्तमान चक्र अदत्त है (डिफ़ॉल्ट)',
        'ar': 'الدورة الحالية غير مدفوعة (افتراضي)',
        'zh': '本期账单未支付 (默认)',
        'ja': '現在のサイクルは未払いです (デフォルト)',
      });

  String dueOnDate(String dateStr) {
    return _localizedValue({
      'en': 'Due $dateStr',
      'bn': 'প্রদেয় $dateStr',
      'es': 'Vence $dateStr',
      'fr': 'Dû $dateStr',
      'de': 'Fällig am $dateStr',
      'hi': 'देय $dateStr',
      'ar': 'مستحق $dateStr',
      'zh': '到期日 $dateStr',
      'ja': '期日 $dateStr',
    });
  }

  String activeCount(int active, int total) {
    final a = formatNumber(active.toString());
    final t = formatNumber(total.toString());
    return _localizedValue({
      'en': '$a of $t Active',
      'bn': '$tটির মধ্যে $aটি সক্রিয়',
      'es': '$a de $t Activas',
      'fr': '$a sur $t Actifs',
      'de': '$a von $t Aktiv',
      'hi': '$t में से $a सक्रिय',
      'ar': '$a من $t نشط',
      'zh': '$a / $t 活跃中',
      'ja': '$a / $t件 有効',
    });
  }

  String getLocalizedSubscriptionName(String name) {
    if (languageCode == 'en') {
      return name;
    }
    switch (name.trim().toLowerCase()) {
      case 'netflix test':
      case 'netflix':
        return _localizedValue({
          'bn': 'নেটফ্লিক্স',
          'es': 'Netflix',
          'fr': 'Netflix',
          'de': 'Netflix',
          'hi': 'नेटफ्लिक्स',
          'ar': 'نتفليكس',
          'zh': '奈飞',
          'ja': 'Netflix',
        });
      case 'spotify':
        return _localizedValue({
          'bn': 'স্পটিফাই',
          'es': 'Spotify',
          'fr': 'Spotify',
          'de': 'Spotify',
          'hi': 'स्पॉटीफ़ाई',
          'ar': 'سبوتيفاي',
          'zh': '声田',
          'ja': 'Spotify',
        });
      case 'gym membership':
      case 'gym':
        return _localizedValue({
          'bn': 'জিম মেম্বারশিপ',
          'es': 'Membresía de Gimnasio',
          'fr': 'Abonnement Salle de Sport',
          'de': 'Fitnessstudio-Mitgliedschaft',
          'hi': 'जिम सदस्यता',
          'ar': 'اشتراك النادي الرياضي',
          'zh': '健身房会员',
          'ja': 'ジム会員権',
        });
      case 'electric utility':
      case 'electricity':
        return _localizedValue({
          'bn': 'বিদ্যুৎ বিল',
          'es': 'Factura de Electricidad',
          'fr': 'Électricité',
          'de': 'Stromrechnung',
          'hi': 'बिजली बिल',
          'ar': 'فاتورة الكهرباء',
          'zh': '生活用电账单',
          'ja': '電気料金',
        });
      case 'icloud / storage':
      case 'cloud storage':
      case 'icloud':
        return _localizedValue({
          'bn': 'ক্লাউড স্টোরেজ',
          'es': 'Almacenamiento en la Nube',
          'fr': 'Stockage Cloud',
          'de': 'Cloud-Speicher',
          'hi': 'क्लाउड स्टोरेज',
          'ar': 'مساحة تخزين سحابية',
          'zh': '云存储空间',
          'ja': 'クラウドストレージ',
        });
      case 'amazon prime':
        return _localizedValue({
          'bn': 'অ্যামাজন প্রাইম',
          'es': 'Amazon Prime',
          'fr': 'Amazon Prime',
          'de': 'Amazon Prime',
          'hi': 'अमेज़न प्राइम',
          'ar': 'أمازون برايم',
          'zh': '亚马逊 Prime',
          'ja': 'Amazon プライム',
        });
      case 'internet & wifi':
      case 'internet':
        return _localizedValue({
          'bn': 'ইন্টারনেট ও ওয়াইফাই',
          'es': 'Internet y WiFi',
          'fr': 'Internet & WiFi',
          'de': 'Internet & WLAN',
          'hi': 'इंटरनेट व वाई-फाई',
          'ar': 'الإنترنت والواي فاي',
          'zh': '宽带网络与WiFi',
          'ja': 'インターネット＆Wi-Fi',
        });
      default:
        return name;
    }
  }

  String getBillingCycleName(BillingCycle cycle) {
    switch (cycle) {
      case BillingCycle.monthly:
        return _localizedValue({
          'en': 'MONTHLY',
          'bn': 'মাসিক',
          'es': 'MENSUAL',
          'fr': 'MENSUEL',
          'de': 'MONATLICH',
          'hi': 'मासिक',
          'ar': 'شهري',
          'zh': '按月',
          'ja': '月額',
        });
      case BillingCycle.yearly:
        return _localizedValue({
          'en': 'YEARLY',
          'bn': 'বার্ষিক',
          'es': 'ANUAL',
          'fr': 'ANNUEL',
          'de': 'JÄHRLICH',
          'hi': 'वार्षिक',
          'ar': 'سنوي',
          'zh': '按年',
          'ja': '年額',
        });
      case BillingCycle.weekly:
        return _localizedValue({
          'en': 'WEEKLY',
          'bn': 'সাপ্তাহিক',
          'es': 'SEMANAL',
          'fr': 'HEBDOMADAIRE',
          'de': 'WÖCHENTLICH',
          'hi': 'साप्ताहिक',
          'ar': 'أسبوعي',
          'zh': '按周',
          'ja': '週額',
        });
    }
  }

  String getSubscriptionCategoryName(SubscriptionCategory category) {
    switch (category) {
      case SubscriptionCategory.entertainment:
        return _localizedValue({
          'en': 'ENTERTAINMENT',
          'bn': 'বিনোদন',
          'es': 'ENTRETENIMIENTO',
          'fr': 'DIVERTISSEMENT',
          'de': 'UNTERHALTUNG',
          'hi': 'मनोरंजन',
          'ar': 'الترفيه',
          'zh': '娱乐影视',
          'ja': 'エンタメ',
        });
      case SubscriptionCategory.utilities:
        return _localizedValue({
          'en': 'UTILITIES',
          'bn': 'ইউটিলিটি ও বিল',
          'es': 'SERVICIOS',
          'fr': 'SERVICES PUBLICS',
          'de': 'NEBENKOSTEN',
          'hi': 'उपयोगिताएं',
          'ar': 'المرافق',
          'zh': '生活缴费',
          'ja': '公共料金',
        });
      case SubscriptionCategory.software:
        return _localizedValue({
          'en': 'SOFTWARE',
          'bn': 'সফটওয়্যার',
          'es': 'SOFTWARE',
          'fr': 'LOGICIEL',
          'de': 'SOFTWARE',
          'hi': 'सॉफ्टवेयर',
          'ar': 'البرمجيات',
          'zh': '软件服务',
          'ja': 'ソフトウェア',
        });
      case SubscriptionCategory.health:
        return _localizedValue({
          'en': 'HEALTH & GYM',
          'bn': 'স্বাস্থ্য ও জিম',
          'es': 'SALUD Y GIMNASIO',
          'fr': 'SANTÉ & SPORT',
          'de': 'GESUNDHEIT & GYM',
          'hi': 'स्वास्थ्य व जिम',
          'ar': 'الصحة واللياقة',
          'zh': '健康运动',
          'ja': 'ヘルス・ジム',
        });
      case SubscriptionCategory.work:
        return _localizedValue({
          'en': 'WORK & CLOUD',
          'bn': 'কাজ ও ক্লাউড',
          'es': 'TRABAJO Y NUBE',
          'fr': 'TRAVAIL & CLOUD',
          'de': 'ARBEIT & CLOUD',
          'hi': 'काम व क्लाउड',
          'ar': 'العمل والسحابة',
          'zh': '工作生产力',
          'ja': '仕事・クラウド',
        });
      case SubscriptionCategory.other:
        return _localizedValue({
          'en': 'OTHER',
          'bn': 'অন্যান্য',
          'es': 'OTRO',
          'fr': 'AUTRE',
          'de': 'SONSTIGES',
          'hi': 'अन्य',
          'ar': 'أخرى',
          'zh': '其他',
          'ja': 'その他',
        });
    }
  }

  String get dueToday => _localizedValue({
        'en': 'Due Today',
        'bn': 'আজকে প্রদেয়',
        'es': 'Vence Hoy',
        'fr': 'Dû Aujourd\'hui',
        'de': 'Heute Fällig',
        'hi': 'आज देय है',
        'ar': 'مستحق اليوم',
        'zh': '今日到期',
        'ja': '本日支払期日',
      });

  String inXDays(int days) {
    final numStr = formatNumber(days.toString());
    if (days == 1) {
      return _localizedValue({
        'en': 'In 1 Day',
        'bn': '১ দিনের মধ্যে',
        'es': 'En 1 Día',
        'fr': 'Dans 1 Jour',
        'de': 'In 1 Tag',
        'hi': '1 दिन में',
        'ar': 'خلال يوم واحد',
        'zh': '1天内到期',
        'ja': '1日後',
      });
    }
    return _localizedValue({
      'en': 'In $numStr Days',
      'bn': '$numStr দিনের মধ্যে',
      'es': 'En $numStr Días',
      'fr': 'Dans $numStr Jours',
      'de': 'In $numStr Tagen',
      'hi': '$numStr दिनों में',
      'ar': 'خلال $numStr أيام',
      'zh': '$numStr天内到期',
      'ja': '$numStr日後',
    });
  }

  String overdueByDays(int days) {
    final numStr = formatNumber(days.toString());
    if (days == 1) {
      return _localizedValue({
        'en': 'Overdue by 1 Day',
        'bn': '১ দিন অতিবাহিত',
        'es': 'Atrasado por 1 Día',
        'fr': 'En retard de 1 Jour',
        'de': '1 Tag überfällig',
        'hi': '1 दिन बकाया',
        'ar': 'متأخر بيوم واحد',
        'zh': '已逾期 1 天',
        'ja': '1日遅延',
      });
    }
    return _localizedValue({
      'en': 'Overdue by $numStr Days',
      'bn': '$numStr দিন অতিবাহিত',
      'es': 'Atrasado por $numStr Días',
      'fr': 'En retard de $numStr Jours',
      'de': '$numStr Tage überfällig',
      'hi': '$numStr দিন बकाया',
      'ar': 'متأخر بـ $numStr أيام',
      'zh': '已逾期 $numStr 天',
      'ja': '$numStr日遅延',
    });
  }

  String get paid => _localizedValue({
        'en': 'Paid',
        'bn': 'পরিশোধিত',
        'es': 'Pagado',
        'fr': 'Payé',
        'de': 'Bezahlt',
        'hi': 'भुगतान किया',
        'ar': 'مدفوع',
        'zh': '已支付',
        'ja': '支払済',
      });

  String get unpaid => _localizedValue({
        'en': 'Unpaid',
        'bn': 'অপরিশোধিত',
        'es': 'Pendiente',
        'fr': 'Impayé',
        'de': 'Ausstehend',
        'hi': 'अदत्त',
        'ar': 'غير مدفوع',
        'zh': '未支付',
        'ja': '未払い',
      });

  String get markAsPaid => _localizedValue({
        'en': 'Mark as Paid',
        'bn': 'পরিশোধিত হিসেবে চিহ্নিত করুন',
        'es': 'Marcar como Pagado',
        'fr': 'Marquer comme payé',
        'de': 'Als bezahlt markieren',
        'hi': 'भुगतान के रूप में चिह्नित करें',
        'ar': 'تحديد كمدفوع',
        'zh': '标记为已支付',
        'ja': '支払い済みにする',
      });

  String get markAsUnpaid => _localizedValue({
        'en': 'Mark as Unpaid',
        'bn': 'অপরিশোধিত হিসেবে চিহ্নিত করুন',
        'es': 'Marcar como Pendiente',
        'fr': 'Marquer comme impayé',
        'de': 'Als ausstehend markieren',
        'hi': 'अदत्त के रूप में चिह्नित करें',
        'ar': 'تحديد كغير مدفوع',
        'zh': '标记为未支付',
        'ja': '未払いに戻す',
      });

  String get noSubscriptionsYet => _localizedValue({
        'en': 'No Subscriptions Yet',
        'bn': 'এখনও কোনো সাবস্ক্রিপশন যোগ করা হয়নি',
        'es': 'Sin suscripciones aún',
        'fr': 'Aucun abonnement pour le moment',
        'de': 'Noch keine Abonnements',
        'hi': 'अभी कोई सब्सक्रिप्शन नहीं है',
        'ar': 'لا توجد اشتراكات حتى الآن',
        'zh': '暂无订阅账单',
        'ja': 'サブスクリプションがありません',
      });

  String get subscriptionEmptySubtitle => _localizedValue({
        'en': 'Track streaming, gym memberships, utilities, and software licenses.',
        'bn': 'স্ট্রিমিং, জিম সদস্যপদ, ইউটিলিটি বিল ও সফটওয়্যার লাইসেন্স হিসাব রাখুন।',
        'es': 'Rastrea streaming, gimnasio, servicios públicos y licencias de software.',
        'fr': 'Suivez le streaming, le sport, les factures et abonnements logiciels.',
        'de': 'Streaming, Fitness, Nebenkosten und Software-Lizenzen verwalten.',
        'hi': 'स्ट्रीमिंग, जिम सदस्यता, बिजली-पानी बिल और सॉफ्टवेयर लाइसेंस ट्रैक करें।',
        'ar': 'تتبع البث الرقمي، اشتراكات النوادي، الفواتير وتراخيص البرامج.',
        'zh': '轻松管理流媒体、健身房、水电网费及各类软件订阅。',
        'ja': '動画配信、ジム、光熱費、ソフトウェアのサブスクリプションを一元管理。',
      });

  // -------------------------------------------------------------
  // 4. Price Calculator
  // -------------------------------------------------------------
  String get priceCalcTitle => getModuleTitle('price_calculator');

  String get bestValueWinner => _localizedValue({
        'en': 'BEST VALUE WINNER',
        'bn': 'সেরা সাশ্রয়ী ডিল',
        'es': 'MEJOR OFERTA',
        'fr': 'MEILLEUR RAPPORT QUALITÉ/PRIX',
        'de': 'BESTER PREIS-LEISTUNGSSIEGER',
        'hi': 'सर्वोत्तम मूल्य डील',
        'ar': 'الصفقة الأفضل قيمة',
        'zh': '最高性价比之选',
        'ja': 'ベストバリュー',
      });

  String get addComparisonOption => _localizedValue({
        'en': 'Add Comparison Option',
        'bn': 'আরও পণ্য তুলনা করুন',
        'es': 'Agregar opción de comparación',
        'fr': 'Ajouter une option de comparaison',
        'de': 'Vergleichsoption hinzufügen',
        'hi': 'तुलना विकल्प जोड़ें',
        'ar': 'إضافة خيار مقارنة',
        'zh': '添加对比项',
        'ja': '比較項目を追加',
      });

  String get mismatchedUnits => _localizedValue({
        'en': 'Mismatched Units',
        'bn': 'ভিন্ন এককের পণ্য',
        'es': 'Unidades incompatibles',
        'fr': 'Unités incompatibles',
        'de': 'Unterschiedliche Einheiten',
        'hi': 'असंगत इकाइयां',
        'ar': 'وحدات غير متطابقة',
        'zh': '单位不一致',
        'ja': '単位の不一致',
      });

  String get mismatchedUnitsDesc => _localizedValue({
        'en': 'Cannot compare weight with volume or piece count. Please select consistent units.',
        'bn': 'ওজনের সাথে তরলের আয়তন বা পিস তুলনা করা সম্ভব নয়। একই ধরনের একক ব্যবহার করুন।',
        'es': 'No se puede comparar peso con volumen. Selecciona unidades coherentes.',
        'fr': 'Impossible de comparer le poids avec le volume.',
        'de': 'Gewicht kann nicht mit Volumen verglichen werden.',
        'hi': 'वजन की तुलना मात्रा (वॉल्यूम) से नहीं की जा सकती।',
        'ar': 'لا يمكن مقارنة الوزن بالحجم أو العدد. يرجى اختيار وحدات متوافقة.',
        'zh': '无法直接将重量与体积或个数进行对比，请选择同类单位。',
        'ja': '重量と体積・個数を直接比較することはできません。',
      });

  String get enterPricesAndSizes => _localizedValue({
        'en': 'Enter Prices & Sizes',
        'bn': 'মূল্য ও পরিমাণ লিখুন',
        'es': 'Ingresa precios y tamaños',
        'fr': 'Entrez les prix et quantités',
        'de': 'Preise & Mengen eingeben',
        'hi': 'मूल्य और मात्रा दर्ज करें',
        'ar': 'أدخل الأسعار والكميات',
        'zh': '输入价格与规格',
        'ja': '価格とサイズを入力',
      });

  String get enterPricesAndSizesDesc => _localizedValue({
        'en': 'Input item price and quantity to reveal normalized cost and best value deal.',
        'bn': 'পণ্যের দাম ও পরিমাণ লিখলে প্রতি ইউনিট খরচ ও সেরা সাশ্রয়ী ডিল দেখতে পাবেন।',
        'es': 'Ingresa precio y cantidad para ver el costo unitario y la mejor oferta.',
        'fr': 'Indiquez les prix et volumes pour calculer le meilleur rapport.',
        'de': 'Artikelpreis und Menge eingeben für den besten Preis.',
        'hi': 'यूनिट मूल्य और सर्वोत्तम डील देखने के लिए सामान की कीमत और मात्रा दर्ज करें।',
        'ar': 'أدخل السعر والكمية لحساب التكلفة الموحدة وأفضل صفقة.',
        'zh': '输入商品价格与数量即可自动计算换算单价并高亮显示最佳实惠选项。',
        'ja': '商品の価格と容量を入力すると、単価と最安オプションが自動計算されます。',
      });

  String get cheaper => _localizedValue({
        'en': 'CHEAPER',
        'bn': 'সাশ্রয়ী',
        'es': 'MÁS BARATO',
        'fr': 'MOINS CHER',
        'de': 'GÜNSTIGER',
        'hi': 'सस्ता',
        'ar': 'أرخص',
        'zh': '更划算',
        'ja': 'お得',
      });

  String get more => _localizedValue({
        'en': 'MORE',
        'bn': 'বেশি',
        'es': 'MÁS',
        'fr': 'DE PLUS',
        'de': 'MEHR',
        'hi': 'अधिक',
        'ar': 'أكثر',
        'zh': '更贵',
        'ja': '割高',
      });

  String get bestDeal => _localizedValue({
        'en': 'BEST DEAL',
        'bn': 'সেরা ডিল',
        'es': 'MEJOR OFERTA',
        'fr': 'MEILLEURE OFFRE',
        'de': 'TOP DEAL',
        'hi': 'सर्वोत्तम डील',
        'ar': 'أفضل صفقة',
        'zh': '最佳优惠',
        'ja': '最安値',
      });

  String get optionName => _localizedValue({
        'en': 'Option Name',
        'bn': 'পণ্যের নাম/বিকল্প',
        'es': 'Nombre de la opción',
        'fr': 'Nom de l\'option',
        'de': 'Optionsname',
        'hi': 'विकल्प का नाम',
        'ar': 'اسم الخيار',
        'zh': '规格/商品名',
        'ja': '商品・サイズ名',
      });

  String get price => _localizedValue({
        'en': 'Price',
        'bn': 'মূল্য',
        'es': 'Precio',
        'fr': 'Prix',
        'de': 'Preis',
        'hi': 'कीमत',
        'ar': 'السعر',
        'zh': '价格',
        'ja': '価格',
      });

  String get sizeOrQty => _localizedValue({
        'en': 'Qty / Size',
        'bn': 'পরিমাণ',
        'es': 'Cantidad',
        'fr': 'Quantité',
        'de': 'Menge',
        'hi': 'मात्रा',
        'ar': 'الكمية',
        'zh': '数量/规格',
        'ja': '数量/容量',
      });

  String get unit => _localizedValue({
        'en': 'Unit',
        'bn': 'একক',
        'es': 'Unidad',
        'fr': 'Unité',
        'de': 'Einheit',
        'hi': 'इकाई',
        'ar': 'الوحدة',
        'zh': '单位',
        'ja': '単位',
      });

  String get unitCost => _localizedValue({
        'en': 'Unit Cost',
        'bn': 'প্রতি একক খরচ',
        'es': 'Costo Unitario',
        'fr': 'Coût Unitaire',
        'de': 'Einheitenpreis',
        'hi': 'इकाई लागत',
        'ar': 'سعر الوحدة',
        'zh': '换算单价',
        'ja': '基準単価',
      });

  String get priceCalcSubtitle => _localizedValue({
        'en': 'Smart Grocery & Unit Value',
        'bn': 'স্মার্ট গ্রোসারি ও ইউনিট ভ্যালু',
        'es': 'Abarrotes y Valor Unitario',
        'fr': 'Épicerie & Valeur Unitaire',
        'de': 'Smarter Einkauf & Einheitenwert',
        'hi': 'स्मार्ट किराना व इकाई मूल्य',
        'ar': 'تسوق البقالة وقيمة الوحدة الذكية',
        'zh': '超市购物与规格性价比',
        'ja': '買い物＆単位価格計算',
      });

  String get saveBenchmarkTitle => _localizedValue({
        'en': 'Save Benchmark',
        'bn': 'বেঞ্চমার্ক সংরক্ষণ করুন',
        'es': 'Guardar Referencia',
        'fr': 'Enregistrer la Référence',
        'de': 'Referenzwert speichern',
        'hi': 'बेंचमार्क सहेजें',
        'ar': 'حفظ المعيار',
        'zh': '保存价格基准',
        'ja': '基準価格を保存',
      });

  String get saveBenchmarkDesc => _localizedValue({
        'en': 'Save this comparison to benchmark against future store prices.',
        'bn': 'ভবিষ্যতে দোকানের দামের সাথে তুলনা করার জন্য এটি সংরক্ষণ করুন।',
        'es': 'Guarda esta comparación para comparar con precios futuros.',
        'fr': 'Enregistrez cette comparaison pour vos futurs achats.',
        'de': 'Speichern Sie diesen Vergleich für spätere Einkäufe.',
        'hi': 'भविष्य की कीमतों से तुलना करने के लिए इसे सहेजें।',
        'ar': 'احفظ هذه المقارنة لمقارنتها بأسعار المتاجر المستقبلية.',
        'zh': '保存此对比项以便日后购物时快速比价。',
        'ja': '今後の買い物で価格を比較するために保存します。',
      });

  String get benchmarkNameHint => _localizedValue({
        'en': 'e.g. Olive Oil, Laundry Detergent, Coffee',
        'bn': 'যেমন: অলিভ অয়েল, ডিটারজেন্ট, কফি',
        'es': 'ej. Aceite de oliva, Detergente, Café',
        'fr': 'ex. Huile d\'olive, Lessive, Café',
        'de': 'z.B. Olivenöl, Waschmittel, Kaffee',
        'hi': 'जैसे: ऑलिव ऑयल, डिटर्जेंट, कॉफ़ी',
        'ar': 'مثل زيت الزيتون، مسحوق الغسيل، القهوة',
        'zh': '如 橄榄油、洗衣液、咖啡',
        'ja': '例: オリーブオイル, 洗剤, コーヒー',
      });

  String get savedBenchmarksTitle => _localizedValue({
        'en': 'Saved Price Benchmarks',
        'bn': 'সংরক্ষিত প্রাইজ বেঞ্চমার্ক',
        'es': 'Precios de Referencia Guardados',
        'fr': 'Références de Prix Enregistrées',
        'de': 'Gespeicherte Preis-Referenzen',
        'hi': 'सहेजे गए मूल्य बेंचमार्क',
        'ar': 'معايير الأسعار المحفوظة',
        'zh': '已保存的价格基准',
        'ja': '保存済み基準価格',
      });

  String get noSavedBenchmarks => _localizedValue({
        'en': 'No Saved Benchmarks',
        'bn': 'কোনো সংরক্ষিত বেঞ্চমার্ক নেই',
        'es': 'Sin Referencias Guardadas',
        'fr': 'Aucune Référence Enregistrée',
        'de': 'Keine Referenzen gespeichert',
        'hi': 'कोई सहेजा गया बेंचमार्क नहीं',
        'ar': 'لا توجد معايير محفوظة',
        'zh': '暂无保存的基准',
        'ja': '保存された基準価格はありません',
      });

  String get noSavedBenchmarksDesc => _localizedValue({
        'en': 'Save winning deals to recall when grocery shopping.',
        'bn': 'সুপারমার্কেটে কেনাকাটার সময় মনে রাখতে সেরা ডিল সংরক্ষণ করুন।',
        'es': 'Guarda las mejores ofertas para consultarlas al comprar.',
        'fr': 'Enregistrez les meilleures offres pour vos courses.',
        'de': 'Speichern Sie Top-Deals für den nächsten Supermarktbesuch.',
        'hi': 'खरीदारी करते समय याद रखने के लिए सर्वोत्तम डील सहेजें।',
        'ar': 'احفظ أفضل الصفقات لتتذكرها أثناء التسوق.',
        'zh': '保存最具性价比的商品基准，方便逛超市时随手对照。',
        'ja': '買い物時に確認できるようお得な価格を保存します。',
      });

  String get saveThisBenchmark => _localizedValue({
        'en': 'Save This Benchmark',
        'bn': 'এই বেঞ্চমার্ক সংরক্ষণ করুন',
        'es': 'Guardar Esta Referencia',
        'fr': 'Enregistrer Cette Référence',
        'de': 'Diese Referenz speichern',
        'hi': 'यह बेंचमार्क सहेजें',
        'ar': 'حفظ هذا المعيار',
        'zh': '保存当前价格基准',
        'ja': 'この基準価格を保存',
      });

  String get savedBenchmarksTooltip => _localizedValue({
        'en': 'Saved Benchmarks',
        'bn': 'সংরক্ষিত বেঞ্চমার্ক',
        'es': 'Referencias Guardadas',
        'fr': 'Références Enregistrées',
        'de': 'Gespeicherte Referenzen',
        'hi': 'सहेजे गए बेंचमार्क',
        'ar': 'المعايير المحفوظة',
        'zh': '已保存的基准',
        'ja': '保存された基準',
      });

  String get resetToDefaultTooltip => _localizedValue({
        'en': 'Reset to Default',
        'bn': 'ডিফল্টে রিসেট করুন',
        'es': 'Restablecer por Defecto',
        'fr': 'Réinitialiser par Défaut',
        'de': 'Auf Standard zurücksetzen',
        'hi': 'डिफ़ॉल्ट पर रीसेट करें',
        'ar': 'إعادة التعيين للافتراضي',
        'zh': '重置为默认对比',
        'ja': 'デフォルトに戻す',
      });

  String optionsCompared(int count, String dateStr) {
    final c = formatNumber(count.toString());
    return _localizedValue({
      'en': '$c options compared • $dateStr',
      'bn': '$cটি বিকল্প তুলনা করা হয়েছে • $dateStr',
      'es': '$c opciones comparadas • $dateStr',
      'fr': '$c options comparées • $dateStr',
      'de': '$c Optionen verglichen • $dateStr',
      'hi': '$c विकल्पों की तुलना • $dateStr',
      'ar': 'مقارنة $c خيارات • $dateStr',
      'zh': '对比了 $c 种规格 • $dateStr',
      'ja': '$c 項目を比較 • $dateStr',
    });
  }

  String getStandardUnitLabel(UnitCategory category) {
    switch (category) {
      case UnitCategory.weight:
        return _localizedValue({
          'en': '/ 100g',
          'bn': '/ ১০০গ্রাম',
          'es': '/ 100g',
          'fr': '/ 100g',
          'de': '/ 100g',
          'hi': '/ 100ग्रा',
          'ar': '/ ١٠٠ جم',
          'zh': '/ 100克',
          'ja': '/ 100g',
        });
      case UnitCategory.volume:
        return _localizedValue({
          'en': '/ 100ml',
          'bn': '/ ১০০মি.লি.',
          'es': '/ 100ml',
          'fr': '/ 100ml',
          'de': '/ 100ml',
          'hi': '/ 100मिली',
          'ar': '/ ١٠٠ مل',
          'zh': '/ 100毫升',
          'ja': '/ 100ml',
        });
      case UnitCategory.count:
        return _localizedValue({
          'en': '/ pc',
          'bn': '/ পিস',
          'es': '/ pieza',
          'fr': '/ pièce',
          'de': '/ Stk',
          'hi': '/ नग',
          'ar': '/ قطعة',
          'zh': '/ 个',
          'ja': '/ 個',
        });
    }
  }

  String getBulkUnitLabel(UnitCategory category) {
    switch (category) {
      case UnitCategory.weight:
        return _localizedValue({
          'en': '/ 1kg',
          'bn': '/ ১কেজি',
          'es': '/ 1kg',
          'fr': '/ 1kg',
          'de': '/ 1kg',
          'hi': '/ 1किग्रा',
          'ar': '/ ١ كجم',
          'zh': '/ 1公斤',
          'ja': '/ 1kg',
        });
      case UnitCategory.volume:
        return _localizedValue({
          'en': '/ 1L',
          'bn': '/ ১লিটার',
          'es': '/ 1L',
          'fr': '/ 1L',
          'de': '/ 1L',
          'hi': '/ 1लीटर',
          'ar': '/ ١ لتر',
          'zh': '/ 1升',
          'ja': '/ 1L',
        });
      case UnitCategory.count:
        return _localizedValue({
          'en': '/ 100pcs',
          'bn': '/ ১০০পিস',
          'es': '/ 100 pzas',
          'fr': '/ 100 pcs',
          'de': '/ 100 Stk',
          'hi': '/ 100 नग',
          'ar': '/ ١٠٠ قطعة',
          'zh': '/ 100个',
          'ja': '/ 100個',
        });
    }
  }

  String getLocalizedOptionLabel(String label) {
    if (languageCode == 'en') return label;

    final trimmed = label.trim();
    if (trimmed == 'Option A (Standard)') {
      return _localizedValue({
        'bn': 'বিকল্প ক (স্ট্যান্ডার্ড)',
        'es': 'Opción A (Estándar)',
        'fr': 'Option A (Standard)',
        'de': 'Option A (Standard)',
        'hi': 'विकल्प A (मानक)',
        'ar': 'الخيار أ (قياسي)',
        'zh': '规格 A (标准装)',
        'ja': 'オプション A (標準)',
      });
    } else if (trimmed == 'Option B (Bulk Pack)') {
      return _localizedValue({
        'bn': 'বিকল্প খ (বাল্ক প্যাক)',
        'es': 'Opción B (Paquete Grande)',
        'fr': 'Option B (Lot)',
        'de': 'Option B (Großpackung)',
        'hi': 'विकल्प B (बल्क पैक)',
        'ar': 'الخيار ب (حزمة اقتصادية)',
        'zh': '规格 B (家庭大包装)',
        'ja': 'オプション B (大容量)',
      });
    }

    final match = RegExp(r'^Option\s+([A-Za-z0-9]+)$').firstMatch(trimmed);
    if (match != null) {
      final code = match.group(1)!;
      const bnLetters = {
        'A': 'ক', 'B': 'খ', 'C': 'গ', 'D': 'ঘ', 'E': 'ঙ',
        'F': 'চ', 'G': 'ছ', 'H': 'জ', 'I': 'ঝ', 'J': 'ঞ',
        'K': 'ট', 'L': 'ঠ', 'M': 'ড', 'N': 'ঢ', 'O': 'ণ',
        'P': 'ত', 'Q': 'থ', 'R': 'দ', 'S': 'ধ', 'T': 'ন',
        'U': 'প', 'V': 'ফ', 'W': 'ব', 'X': 'ভ', 'Y': 'ম', 'Z': 'য'
      };
      const arLetters = {
        'A': 'أ', 'B': 'ب', 'C': 'ج', 'D': 'د', 'E': 'هـ',
        'F': 'و', 'G': 'ز', 'H': 'ح', 'I': 'ط', 'J': 'ي',
      };
      final bnCode = bnLetters[code] ?? formatNumber(code);
      final arCode = arLetters[code] ?? formatNumber(code);

      return _localizedValue({
        'bn': 'বিকল্প $bnCode',
        'es': 'Opción $code',
        'fr': 'Option $code',
        'de': 'Option $code',
        'hi': 'विकल्प $code',
        'ar': 'الخيار $arCode',
        'zh': '规格 $code',
        'ja': 'オプション $code',
      });
    }
    return label;
  }

  static String normalizeNumber(String input) {
    const bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    const arDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const faDigits = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

    String output = input.trim();
    for (int i = 0; i <= 9; i++) {
      output = output.replaceAll(bnDigits[i], '$i');
      output = output.replaceAll(arDigits[i], '$i');
      output = output.replaceAll(faDigits[i], '$i');
    }
    output = output.replaceAll('٫', '.').replaceAll('،', '.').replaceAll(',', '.');
    return output;
  }

  String getLocalizedUnitName(MeasurementUnit unit) {
    switch (unit) {
      case MeasurementUnit.g:
        return _localizedValue({
          'en': 'Grams (g)',
          'bn': 'গ্রাম (g)',
          'es': 'Gramos (g)',
          'fr': 'Grammes (g)',
          'de': 'Gramm (g)',
          'hi': 'ग्राम (g)',
          'ar': 'جرام (g)',
          'zh': '克 (g)',
          'ja': 'グラム (g)',
        });
      case MeasurementUnit.kg:
        return _localizedValue({
          'en': 'Kilograms (kg)',
          'bn': 'কেজি (kg)',
          'es': 'Kilogramos (kg)',
          'fr': 'Kilogrammes (kg)',
          'de': 'Kilogramm (kg)',
          'hi': 'किग्रा (kg)',
          'ar': 'كيلوجرام (kg)',
          'zh': '公斤 (kg)',
          'ja': 'キログラム (kg)',
        });
      case MeasurementUnit.oz:
        return _localizedValue({
          'en': 'Ounces (oz)',
          'bn': 'আউন্স (oz)',
          'es': 'Onzas (oz)',
          'fr': 'Onces (oz)',
          'de': 'Unzen (oz)',
          'hi': 'औंस (oz)',
          'ar': 'أونصة (oz)',
          'zh': '盎司 (oz)',
          'ja': 'オンス (oz)',
        });
      case MeasurementUnit.lb:
        return _localizedValue({
          'en': 'Pounds (lb)',
          'bn': 'পাউন্ড (lb)',
          'es': 'Libras (lb)',
          'fr': 'Livres (lb)',
          'de': 'Pfund (lb)',
          'hi': 'पाउंड (lb)',
          'ar': 'رطل (lb)',
          'zh': '磅 (lb)',
          'ja': 'ポンド (lb)',
        });
      case MeasurementUnit.ml:
        return _localizedValue({
          'en': 'Milliliters (ml)',
          'bn': 'মি.লি. (ml)',
          'es': 'Mililitros (ml)',
          'fr': 'Millilitres (ml)',
          'de': 'Milliliter (ml)',
          'hi': 'मिली (ml)',
          'ar': 'مليلتر (ml)',
          'zh': '毫升 (ml)',
          'ja': 'ミリリットル (ml)',
        });
      case MeasurementUnit.l:
        return _localizedValue({
          'en': 'Liters (L)',
          'bn': 'লিটার (L)',
          'es': 'Litros (L)',
          'fr': 'Litres (L)',
          'de': 'Liter (L)',
          'hi': 'लीटर (L)',
          'ar': 'لتر (L)',
          'zh': '升 (L)',
          'ja': 'リットル (L)',
        });
      case MeasurementUnit.flOz:
        return _localizedValue({
          'en': 'Fluid Oz (fl oz)',
          'bn': 'ফ্লুইড আউন্স (fl oz)',
          'es': 'Onzas Líq. (fl oz)',
          'fr': 'Onces Liq. (fl oz)',
          'de': 'Flüssigunzen (fl oz)',
          'hi': 'द्रव औंस (fl oz)',
          'ar': 'أونصة سائلة (fl oz)',
          'zh': '液体盎司 (fl oz)',
          'ja': '液量オンス (fl oz)',
        });
      case MeasurementUnit.gal:
        return _localizedValue({
          'en': 'Gallons (gal)',
          'bn': 'গ্যালন (gal)',
          'es': 'Galones (gal)',
          'fr': 'Gallons (gal)',
          'de': 'Gallonen (gal)',
          'hi': 'गैलन (gal)',
          'ar': 'جالون (gal)',
          'zh': '加仑 (gal)',
          'ja': 'ガロン (gal)',
        });
      case MeasurementUnit.pcs:
        return _localizedValue({
          'en': 'Pieces (pcs)',
          'bn': 'পিস (pcs)',
          'es': 'Piezas (pzas)',
          'fr': 'Pièces (pcs)',
          'de': 'Stück (Stk)',
          'hi': 'नग (pcs)',
          'ar': 'قطع (pcs)',
          'zh': '个/件 (pcs)',
          'ja': '個 (pcs)',
        });
      case MeasurementUnit.pack:
        return _localizedValue({
          'en': 'Pack (10 pcs)',
          'bn': 'প্যাক (১০টি)',
          'es': 'Paquete (10 pzas)',
          'fr': 'Lot (10 pcs)',
          'de': 'Packung (10 Stk)',
          'hi': 'पैक (10 नग)',
          'ar': 'حزمة (١٠ قطع)',
          'zh': '包 (10个装)',
          'ja': 'パック (10個入)',
        });
      case MeasurementUnit.dozen:
        return _localizedValue({
          'en': 'Dozen (12 pcs)',
          'bn': 'ডজন (১২টি)',
          'es': 'Docena (12 pzas)',
          'fr': 'Douzaine (12 pcs)',
          'de': 'Dutzend (12 Stk)',
          'hi': 'दर्जन (12 नग)',
          'ar': 'دزينة (١٢ قطعة)',
          'zh': '打 (12个装)',
          'ja': 'ダース (12個入)',
        });
    }
  }

  // -------------------------------------------------------------
  // 5. Pantry & Medicine Expiry
  // -------------------------------------------------------------
  String get pantryTitle => getModuleTitle('pantry_expiry');

  String get pantrySubtitle => _localizedValue({
        'en': 'Food & Medicine Freshness Tracker',
        'bn': 'খাবার ও ওষুধের মেয়াদ ট্র্যাকার',
        'es': 'Rastreador de Caducidad de Alimentos y Medicinas',
        'fr': 'Suivi de Fraîcheur des Aliments et Médicaments',
        'de': 'Lebensmittel- & Medikamenten-Frische',
        'hi': 'खाद्य व दवा ताजगी ट्रैकर',
        'ar': 'متتبع صلاحية الأطعمة والأدوية',
        'zh': '食品与常备药品保质期追踪',
        'ja': '食品＆医薬品の賞味期限管理',
      });

  String get editPantryItem => _localizedValue({
        'en': 'Edit Pantry Item',
        'bn': 'পণ্য সম্পাদনা',
        'es': 'Editar Producto',
        'fr': 'Modifier l\'article',
        'de': 'Artikel bearbeiten',
        'hi': 'सामग्री संपादित करें',
        'ar': 'تعديل الصنف',
        'zh': '编辑食品药品',
        'ja': 'アイテムを編集',
      });

  String get addItemMedicine => _localizedValue({
        'en': 'Add Item / Medicine',
        'bn': 'পণ্য বা ওষুধ যোগ করুন',
        'es': 'Agregar Producto o Medicina',
        'fr': 'Ajouter Article / Médicament',
        'de': 'Artikel / Medikament hinzufügen',
        'hi': 'सामान या दवा जोड़ें',
        'ar': 'إضافة صنف أو دواء',
        'zh': '添加食品或常备药',
        'ja': '食品・医薬品を追加',
      });

  String get quickPresets => _localizedValue({
        'en': 'Quick Presets:',
        'bn': 'দ্রুত প্রিসেট:',
        'es': 'Atajos rápidos:',
        'fr': 'Préréglages rapides :',
        'de': 'Schnell-Vorlagen:',
        'hi': 'त्वरित प्रीसेट:',
        'ar': 'نماذج سريعة:',
        'zh': '快捷预设：',
        'ja': 'クイックプリセット:',
      });

  String get productNameLabel => _localizedValue({
        'en': 'Product / Medicine Name',
        'bn': 'পণ্য বা ওষুধের নাম',
        'es': 'Nombre del Producto o Medicina',
        'fr': 'Nom du Produit / Médicament',
        'de': 'Produkt- / Medikamentenname',
        'hi': 'उत्पाद / दवा का नाम',
        'ar': 'اسم المنتج أو الدواء',
        'zh': '食品或药品名称',
        'ja': '商品・医薬品名',
      });

  String get productNameHint => _localizedValue({
        'en': 'e.g. Greek Yogurt, Ibuprofen',
        'bn': 'যেমন: টক দই, প্যারাসিটামল',
        'es': 'ej. Yogur griego, Ibuprofeno',
        'fr': 'ex. Yaourt grec, Ibuprofène',
        'de': 'z.B. Joghurt, Ibuprofen',
        'hi': 'जैसे: दही, पैरासिटामोल',
        'ar': 'مثل زبادي، إيبوبروفين',
        'zh': '如 酸奶, 布洛芬',
        'ja': '例: ヨーグルト, イブプロフェン',
      });

  String get enterItemName => _localizedValue({
        'en': 'Enter item name',
        'bn': 'পণ্যের নাম লিখুন',
        'es': 'Ingresa el nombre del producto',
        'fr': 'Entrez le nom de l\'article',
        'de': 'Artikelnamen eingeben',
        'hi': 'सामान का नाम दर्ज करें',
        'ar': 'أدخل اسم الصنف',
        'zh': '请输入名称',
        'ja': '商品名を入力してください',
      });

  String get storageZoneLabel => _localizedValue({
        'en': 'Storage Zone',
        'bn': 'সংরক্ষণ জোন',
        'es': 'Zona de Almacenamiento',
        'fr': 'Zone de Stockage',
        'de': 'Lagerort-Zone',
        'hi': 'भंडारण क्षेत्र',
        'ar': 'منطقة التخزين',
        'zh': '存储分区',
        'ja': '保管ゾーン',
      });

  String get expirationDateLabel => _localizedValue({
        'en': 'Expiration Date',
        'bn': 'মেয়াদোত্তীর্ণের তারিখ',
        'es': 'Fecha de Caducidad',
        'fr': 'Date d\'Expiration',
        'de': 'Verfallsdatum',
        'hi': 'समाप्ति तिथि',
        'ar': 'تاريخ انتهاء الصلاحية',
        'zh': '保质期截止日',
        'ja': '賞味・有効期限',
      });

  String get quantityLabel => _localizedValue({
        'en': 'Quantity',
        'bn': 'পরিমাণ',
        'es': 'Cantidad',
        'fr': 'Quantité',
        'de': 'Menge',
        'hi': 'मात्रा',
        'ar': 'الكمية',
        'zh': '数量',
        'ja': '数量',
      });

  String get unitLabel => _localizedValue({
        'en': 'Unit (pcs/g/pack)',
        'bn': 'একক (পিস/গ্রাম/প্যাক)',
        'es': 'Unidad (piezas/g/paquete)',
        'fr': 'Unité (pcs/g/pack)',
        'de': 'Einheit (Stk/g/Pack)',
        'hi': 'इकाई (नग/ग्राम/पैक)',
        'ar': 'الوحدة (قطعة/جرام/عبوة)',
        'zh': '单位 (个/克/袋)',
        'ja': '単位 (個/g/パック)',
      });

  String get saveChanges => _localizedValue({
        'en': 'Save Changes',
        'bn': 'পরিবর্তন সংরক্ষণ করুন',
        'es': 'Guardar Cambios',
        'fr': 'Enregistrer',
        'de': 'Änderungen speichern',
        'hi': 'परिवर्तन सहेजें',
        'ar': 'حفظ التعديلات',
        'zh': '保存修改',
        'ja': '変更を保存',
      });

  String get addItemToZone => _localizedValue({
        'en': 'Add Item to Zone',
        'bn': 'জোনে পণ্য যোগ করুন',
        'es': 'Agregar a la Zona',
        'fr': 'Ajouter à la Zone',
        'de': 'Artikel hinzufügen',
        'hi': 'ज़ोन में सामान जोड़ें',
        'ar': 'إضافة إلى المنطقة',
        'zh': '添加到该分区',
        'ja': 'ゾーンに追加',
      });

  String get consumed => _localizedValue({
        'en': 'CONSUMED',
        'bn': 'ব্যবহৃত/খাওয়া হয়েছে',
        'es': 'CONSUMIDO',
        'fr': 'CONSOMMÉ',
        'de': 'VERBRAUCHT',
        'hi': 'उपयोग किया गया',
        'ar': 'مستهلك',
        'zh': '已食用/已用完',
        'ja': '消費済',
      });

  String get expiresToday => _localizedValue({
        'en': 'EXPIRES TODAY',
        'bn': 'আজ মেয়াদ শেষ',
        'es': 'VENCE HOY',
        'fr': 'EXPIRE AUJOURD\'HUI',
        'de': 'LÄUFT HEUTE AB',
        'hi': 'आज समाप्त हो रहा है',
        'ar': 'ينتهي اليوم',
        'zh': '今日到期',
        'ja': '本日期限',
      });

  String get daysExpiringSoon => _localizedValue({
        'en': 'DAYS (SOON)',
        'bn': 'দিন বাকি (শীঘ্রই)',
        'es': 'DÍAS (PRONTO)',
        'fr': 'JOURS (BIENTÔT)',
        'de': 'TAGE (BALD)',
        'hi': 'दिन शेष (शीघ्र)',
        'ar': 'أيام (قريباً)',
        'zh': '天 (临期)',
        'ja': '日 (間もなく)',
      });

  String expiredDaysAgo(int days) {
    final numStr = formatNumber(days.toString());
    return _localizedValue({
      'en': 'EXPIRED (${numStr}d ago)',
      'bn': 'মেয়াদোত্তীর্ণ ($numStr দিন আগে)',
      'es': 'VENCIDO (hace ${numStr}d)',
      'fr': 'EXPIRÉ (il y a ${numStr}j)',
      'de': 'ABGELAUFEN (vor ${numStr}T)',
      'hi': 'समाप्त ($numStr दिन पहले)',
      'ar': 'منتهي (منذ $numStr أيام)',
      'zh': '已过期 ($numStr天前)',
      'ja': '期限切れ ($numStr日前)',
    });
  }

  String getStorageZoneName(StorageZone zone) {
    switch (zone) {
      case StorageZone.fridge:
        return zoneFridge;
      case StorageZone.freezer:
        return zoneFreezer;
      case StorageZone.pantry:
        return zonePantry;
      case StorageZone.medicine:
        return zoneMedicine;
      case StorageZone.all:
        return allTools;
    }
  }

  String get zoneFridge => _localizedValue({
        'en': 'Fridge',
        'bn': 'ফ্রিজ',
        'es': 'Refrigerador',
        'fr': 'Réfrigérateur',
        'de': 'Kühlschrank',
        'hi': 'फ्रिज',
        'ar': 'الثلاجة',
        'zh': '冷藏',
        'ja': '冷蔵庫',
      });

  String get zoneFreezer => _localizedValue({
        'en': 'Freezer',
        'bn': 'ডিপ ফ্রিজ',
        'es': 'Congelador',
        'fr': 'Congélateur',
        'de': 'Gefrierfach',
        'hi': 'फ्रीजर',
        'ar': 'المجمد',
        'zh': '冷冻',
        'ja': '冷凍庫',
      });

  String get zonePantry => _localizedValue({
        'en': 'Pantry',
        'bn': 'প্যান্ট্রি',
        'es': 'Despensa',
        'fr': 'Garde-manger',
        'de': 'Vorratskammer',
        'hi': 'पेंट्री',
        'ar': 'المؤن',
        'zh': '储藏柜',
        'ja': 'パントリー',
      });

  String get zoneMedicine => _localizedValue({
        'en': 'Medicine Cabinet',
        'bn': 'ওষুধের ক্যাবিনেট',
        'es': 'Botiquín',
        'fr': 'Pharmacie',
        'de': 'Hausapotheke',
        'hi': 'दवा की अलमारी',
        'ar': 'صيدلية المنزل',
        'zh': '药箱',
        'ja': '薬箱',
      });

  String get statusFresh => _localizedValue({
        'en': 'Fresh',
        'bn': 'তাজা ও নিরাপদ',
        'es': 'Fresco',
        'fr': 'Frais',
        'de': 'Frisch',
        'hi': 'ताज़ा',
        'ar': 'طازج',
        'zh': '保质期内',
        'ja': '新鮮',
      });

  String get statusWarning => _localizedValue({
        'en': 'Expiring Soon',
        'bn': 'দ্রুত মেয়াদোত্তীর্ণ হবে',
        'es': 'Por Vencer',
        'fr': 'Expire Bientôt',
        'de': 'Läuft Bald Ab',
        'hi': 'जल्द समाप्त होगा',
        'ar': 'ينتهي قريباً',
        'zh': '即将过期',
        'ja': '間もなく期限切',
      });

  String get statusExpired => _localizedValue({
        'en': 'Expired',
        'bn': 'মেয়াদোত্তীর্ণ',
        'es': 'Vencido',
        'fr': 'Expiré',
        'de': 'Abgelaufen',
        'hi': 'समाप्त हो चुका',
        'ar': 'منتهي الصلاحية',
        'zh': '已过期',
        'ja': '期限切れ',
      });

  // -------------------------------------------------------------
  // 6. Image & Document Compressor
  // -------------------------------------------------------------
  String get compressorTitle => getModuleTitle('image_compressor');

  String get compressorSubtitle => _localizedValue({
        'en': 'Batch Resizer & Document Compressor',
        'bn': 'ব্যাচ রিসাইজার ও ডকুমেন্ট কম্প্রেসর',
        'es': 'Redimensionador por Lotes y Compresor',
        'fr': 'Redimensionneur par Lots & Compresseur',
        'de': 'Stapel-Größenänderung & Dokumenten-Kompressor',
        'hi': 'बैच रिसाइज़र और दस्तावेज़ कंप्रेसर',
        'ar': 'تغيير حجم الصور وضغط المستندات',
        'zh': '批量图片压缩与PDF文档整合',
        'ja': '一括リサイズ＆ドキュメント圧縮',
      });

  String get selectImages => _localizedValue({
        'en': 'Compress Test Photo',
        'bn': 'ছবি কম্প্রেস করুন',
        'es': 'Comprimir Foto de Prueba',
        'fr': 'Compresser Photo Test',
        'de': 'Testfoto komprimieren',
        'hi': 'फोटो कंप्रेस करें',
        'ar': 'ضغط صورة تجريبية',
        'zh': '压缩示例图片',
        'ja': 'テスト写真を圧縮',
      });

  String get compilePdf => _localizedValue({
        'en': 'Compile into PDF Document',
        'bn': 'পিডিএফ ডকুমেন্ট তৈরি করুন',
        'es': 'Compilar en Documento PDF',
        'fr': 'Compiler en Document PDF',
        'de': 'Als PDF zusammenstellen',
        'hi': 'पीडीएफ डॉक्यूमेंट बनाएं',
        'ar': 'تجميع في مستند PDF',
        'zh': '编译为PDF文档',
        'ja': 'PDFドキュメントに変換',
      });

  String get exactTargetSizeLimit => _localizedValue({
        'en': 'Exact Target Size Limit',
        'bn': 'নির্দিষ্ট টার্গেট সাইজ সীমা',
        'es': 'Límite de Tamaño Objetivo',
        'fr': 'Taille Cible Exacte',
        'de': 'Genaue Zielgröße',
        'hi': 'सटीक लक्षित आकार सीमा',
        'ar': 'الحد الأقصى للحجم المستهدف',
        'zh': '目标压缩文件大小上限',
        'ja': '目標ファイルサイズ制限',
      });

  String get ultraTiny => _localizedValue({
        'en': '50 KB (Ultra tiny)',
        'bn': '৫০ KB (খুব ছোট)',
        'es': '50 KB (Muy pequeño)',
        'fr': '50 KB (Très petit)',
        'de': '50 KB (Sehr klein)',
        'hi': '50 KB (अति सूक्ष्म)',
        'ar': '50 KB (صغير جداً)',
        'zh': '50 KB (极小体积)',
        'ja': '50 KB (超軽量)',
      });

  String get highQuality => _localizedValue({
        'en': '1000 KB (High Quality)',
        'bn': '১০০০ KB (উচ্চ মান)',
        'es': '1000 KB (Alta Calidad)',
        'fr': '1000 KB (Haute Qualité)',
        'de': '1000 KB (Hohe Qualität)',
        'hi': '1000 KB (उच्च गुणवत्ता)',
        'ar': '1000 KB (جودة عالية)',
        'zh': '1000 KB (高清画质)',
        'ja': '1000 KB (高画質)',
      });

  String get compressing => _localizedValue({
        'en': 'Compressing...',
        'bn': 'কম্প্রেস হচ্ছে...',
        'es': 'Comprimiendo...',
        'fr': 'Compression en cours...',
        'de': 'Komprimiere...',
        'hi': 'कंप्रेस हो रहा है...',
        'ar': 'جارٍ الضغط...',
        'zh': '正在压缩...',
        'ja': '圧縮中...',
      });

  String get readyToCompress => _localizedValue({
        'en': 'Ready to Compress',
        'bn': 'কম্প্রেস করতে প্রস্তুত',
        'es': 'Listo para Comprimir',
        'fr': 'Prêt à Compresser',
        'de': 'Bereit zum Komprimieren',
        'hi': 'कंप्रेस करने के लिए तैयार',
        'ar': 'جاهز للضغط',
        'zh': '就绪，随时可压缩',
        'ja': '圧縮の準備完了',
      });

  String get readyToCompressDesc => _localizedValue({
        'en': 'Select a preset and tap to shrink image size in-memory with zero cloud uploads.',
        'bn': 'একটি প্রিসেট বেছে নিন এবং কোনো ক্লাউড আপলোড ছাড়াই সরাসরি ফোনে ছবি কম্প্রেস করুন।',
        'es': 'Elige un ajuste y comprime imágenes localmente sin subir nada a la nube.',
        'fr': 'Sélectionnez un préréglage pour compresser localement sans cloud.',
        'de': 'Vorlage wählen und lokal auf dem Gerät ohne Cloud-Uploads komprimieren.',
        'hi': 'प्रीसेट चुनें और बिना किसी क्लाउड अपलोड के सीधे फोन में फोटो कंप्रेस करें।',
        'ar': 'اختر قالباً واضغط لتقليل حجم الصورة محلياً بدون رفع سحابي.',
        'zh': '选择预设参数即可在本地极速压缩图像，全程无需上传云端。',
        'ja': 'プリセットを選択し、クラウドへのアップロードなしで端末内で即座に圧縮します。',
      });

  String get compressionResults => _localizedValue({
        'en': 'COMPRESSION RESULTS',
        'bn': 'কম্প্রেশন ফলাফল',
        'es': 'RESULTADOS DE COMPRESIÓN',
        'fr': 'RÉSULTATS DE COMPRESSION',
        'de': 'KOMPRESSIONSERGEBNISSE',
        'hi': 'कंप्रेशन परिणाम',
        'ar': 'نتائج الضغط',
        'zh': '压缩结果对比',
        'ja': '圧縮結果',
      });

  String get reduced => _localizedValue({
        'en': 'REDUCED',
        'bn': 'হ্রাস পেয়েছে',
        'es': 'REDUCIDO',
        'fr': 'RÉDUIT',
        'de': 'REDUZIERT',
        'hi': 'कम हुआ',
        'ar': 'تم تقليصه',
        'zh': '已减小',
        'ja': '削減',
      });

  String get originalSize => _localizedValue({
        'en': 'Original Size',
        'bn': 'মূল সাইজ',
        'es': 'Tamaño Original',
        'fr': 'Taille Initiale',
        'de': 'Originalgröße',
        'hi': 'मूल आकार',
        'ar': 'الحجم الأصلي',
        'zh': '原始大小',
        'ja': '元のサイズ',
      });

  String get compressedOutput => _localizedValue({
        'en': 'Compressed Output',
        'bn': 'কম্প্রেসড আউটপুট',
        'es': 'Resultado Comprimido',
        'fr': 'Résultat Comprimé',
        'de': 'Komprimierte Ausgabe',
        'hi': 'कंप्रेस किया हुआ आकार',
        'ar': 'الحجم بعد الضغط',
        'zh': '压缩后输出',
        'ja': '圧縮後サイズ',
      });

  String get compressionPresets => _localizedValue({
        'en': 'Compression & Crop Presets',
        'bn': 'কম্প্রেশন ও ক্রপ প্রিসেট',
        'es': 'Ajustes de Compresión y Recorte',
        'fr': 'Préréglages de Compression & Recadrage',
        'de': 'Kompressions- & Schnitt-Vorlagen',
        'hi': 'कंप्रेशन व क्रॉप प्रीसेट',
        'ar': 'نماذج الضغط والقص',
        'zh': '压缩与裁剪快捷预设',
        'ja': '圧縮・切り抜きプリセット',
      });

  // -------------------------------------------------------------
  // 7. Single-Goal Micro-Budgeter
  // -------------------------------------------------------------
  String get budgeterTitle => getModuleTitle('micro_budgeter');

  String get budgeterSubtitle => _localizedValue({
        'en': 'Single-Goal Runway & Envelopes',
        'bn': 'একক লক্ষ্য রানওয়ে ও বাজেট খাম',
        'es': 'Sobres de Presupuesto y Límite Diario',
        'fr': 'Enveloppes et Budget Quotidien',
        'de': 'Ausgabenrahmen & Budget-Umschläge',
        'hi': 'बजट लिफ़ाफ़े और दैनिक खर्च सीमा',
        'ar': 'أظرف الميزانية ومعدل الإنفاق اليومي',
        'zh': '单项目标预算信封与每日安全额度',
        'ja': '目的別封筒予算＆日別支出枠',
      });

  String get dailyRunway => _localizedValue({
        'en': 'DAILY SPENDING RUNWAY',
        'bn': 'দৈনিক খরচের রানওয়ে',
        'es': 'LIMITE DIARIO DISPONIBLE',
        'fr': 'BUDGET QUOTIDIEN DISPONIBLE',
        'de': 'TÄGLICHER AUSGABENRAHMEN',
        'hi': 'दैनिक खर्च सीमा',
        'ar': 'معدل الإنفاق اليومي الآمن',
        'zh': '每日安全支出额度',
        'ja': '1日の支出目安',
      });

  String get safeToSpend => _localizedValue({
        'en': '/ day safe to spend',
        'bn': '/ দিন নিরাপদ ব্যয়',
        'es': '/ día disponible para gastar',
        'fr': '/ jour disponible',
        'de': '/ Tag sicher auszugeben',
        'hi': '/ दिन खर्च करने के लिए सुरक्षित',
        'ar': '/ يوم آمن للإنفاق',
        'zh': '/ 每天安全花费',
        'ja': '/ 日 使用可能',
      });

  String get logSpend => _localizedValue({
        'en': 'Log Spend',
        'bn': 'খরচ যোগ করুন',
        'es': 'Registrar Gasto',
        'fr': 'Enregistrer Dépense',
        'de': 'Ausgabe eintragen',
        'hi': 'खर्च दर्ज करें',
        'ar': 'تسجيل الإنفاق',
        'zh': '记一笔支出',
        'ja': '支出を記録',
      });

  String get spent => _localizedValue({
        'en': 'Spent',
        'bn': 'খরচ হয়েছে',
        'es': 'Gastado',
        'fr': 'Dépensé',
        'de': 'Ausgegeben',
        'hi': 'खर्च हुआ',
        'ar': 'تم إنفاقه',
        'zh': '已支出',
        'ja': '使用済',
      });

  String get totalGoal => _localizedValue({
        'en': 'Total Goal',
        'bn': 'মোট লক্ষ্য',
        'es': 'Meta Total',
        'fr': 'Objectif Total',
        'de': 'Gesamtziel',
        'hi': 'कुल लक्ष्य',
        'ar': 'الهدف الإجمالي',
        'zh': '总目标',
        'ja': '目標総額',
      });

  String get daysLeft => _localizedValue({
        'en': 'Days Left',
        'bn': 'দিন বাকি',
        'es': 'Días Restantes',
        'fr': 'Jours Restants',
        'de': 'Tage übrig',
        'hi': 'दिन शेष',
        'ar': 'أيام متبقية',
        'zh': '剩余天数',
        'ja': '残り日数',
      });

  String get editGoalEnvelope => _localizedValue({
        'en': 'Edit Goal Envelope',
        'bn': 'বাজেট খাম সম্পাদনা',
        'es': 'Editar Sobre de Meta',
        'fr': 'Modifier l\'enveloppe',
        'de': 'Ziel-Umschlag bearbeiten',
        'hi': 'लक्ष्य लिफ़ाफ़ा संपादित करें',
        'ar': 'تعديل ظرف الهدف',
        'zh': '编辑目标预算信封',
        'ja': '目標封筒を編集',
      });

  String get newGoalEnvelope => _localizedValue({
        'en': 'New Goal Envelope',
        'bn': 'নতুন বাজেট খাম',
        'es': 'Nuevo Sobre de Meta',
        'fr': 'Nouvelle Enveloppe',
        'de': 'Neuer Ziel-Umschlag',
        'hi': 'नया लक्ष्य लिफ़ाफ़ा',
        'ar': 'ظرف هدف جديد',
        'zh': '新建目标预算信封',
        'ja': '新しい目標封筒',
      });

  String get goalNameLabel => _localizedValue({
        'en': 'Goal / Trip Name',
        'bn': 'লক্ষ্য বা ভ্রমণের নাম',
        'es': 'Nombre de Meta o Viaje',
        'fr': 'Nom de l\'Objectif / Voyage',
        'de': 'Ziel- / Reise-Name',
        'hi': 'लक्ष्य / यात्रा का नाम',
        'ar': 'اسم الهدف أو الرحلة',
        'zh': '目标或旅行名称',
        'ja': '目標・旅行名',
      });

  String get goalNameHint => _localizedValue({
        'en': 'e.g. Tokyo Holiday, Weekend Trip, Dining Out',
        'bn': 'যেমন: সিলেট ট্যুর, উইকেন্ড ডাইনিং',
        'es': 'ej. Vacaciones, Fin de semana',
        'fr': 'ex. Vacances, Sorties',
        'de': 'z.B. Urlaub, Wochenendausflug',
        'hi': 'जैसे: हॉलिडे ट्रिप, वीकेंड डाइनिंग',
        'ar': 'مثل عطلة نهاية الأسبوع، رحلة سفر',
        'zh': '如 日本度假、周末聚餐、日常餐饮',
        'ja': '例: 週末旅行、外食予算',
      });

  String get enterGoalName => _localizedValue({
        'en': 'Enter a goal name',
        'bn': 'একটি লক্ষ্যের নাম লিখুন',
        'es': 'Ingresa un nombre para la meta',
        'fr': 'Entrez un nom d\'objectif',
        'de': 'Zielnamen eingeben',
        'hi': 'लक्ष्य का नाम दर्ज करें',
        'ar': 'أدخل اسم الهدف',
        'zh': '请输入目标名称',
        'ja': '目標名を入力してください',
      });

  String get totalTargetBudget => _localizedValue({
        'en': 'Total Target Budget',
        'bn': 'মোট নির্ধারিত বাজেট',
        'es': 'Presupuesto Total Objetivo',
        'fr': 'Budget Total Ciblé',
        'de': 'Gesamtes Zielbudget',
        'hi': 'कुल लक्षित बजट',
        'ar': 'إجمالي الميزانية المستهدفة',
        'zh': '目标总预算金额',
        'ja': '目標予算総額',
      });

  String get enterBudgetAmount => _localizedValue({
        'en': 'Enter budget amount',
        'bn': 'বাজেটের পরিমাণ লিখুন',
        'es': 'Ingresa el monto del presupuesto',
        'fr': 'Entrez le montant du budget',
        'de': 'Budgetbetrag eingeben',
        'hi': 'बजट राशि दर्ज करें',
        'ar': 'أدخل مبلغ الميزانية',
        'zh': '请输入预算金额',
        'ja': '予算金額を入力してください',
      });

  String get mustBeGreaterThanZero => _localizedValue({
        'en': 'Must be > 0',
        'bn': '০ এর চেয়ে বেশি হতে হবে',
        'es': 'Debe ser mayor a 0',
        'fr': 'Doit être supérieur à 0',
        'de': 'Muss > 0 sein',
        'hi': '> 0 होना चाहिए',
        'ar': 'يجب أن يكون أكبر من 0',
        'zh': '金额必须大于0',
        'ja': '0より大きくしてください',
      });

  String get runwayDuration => _localizedValue({
        'en': 'Runway Duration',
        'bn': 'রানওয়ের সময়সীমা',
        'es': 'Duración del Presupuesto',
        'fr': 'Durée du Budget',
        'de': 'Laufzeit des Budgets',
        'hi': 'बजट समय सीमा',
        'ar': 'المدة الزمنية للميزانية',
        'zh': '预算有效期范围',
        'ja': '予算期間',
      });

  String get saveEnvelope => _localizedValue({
        'en': 'Save Envelope',
        'bn': 'খাম সংরক্ষণ করুন',
        'es': 'Guardar Sobre',
        'fr': 'Enregistrer l\'enveloppe',
        'de': 'Umschlag speichern',
        'hi': 'लिफ़ाफ़ा सहेजें',
        'ar': 'حفظ الظرف',
        'zh': '保存信封',
        'ja': '封筒を保存',
      });

  String get createBudgetEnvelope => _localizedValue({
        'en': 'Create Budget Envelope',
        'bn': 'বাজেট খাম তৈরি করুন',
        'es': 'Crear Sobre de Presupuesto',
        'fr': 'Créer une enveloppe',
        'de': 'Budget-Umschlag erstellen',
        'hi': 'बजट लिफ़ाफ़ा बनाएं',
        'ar': 'إنشاء ظرف ميزانية',
        'zh': '创建预算信封',
        'ja': '予算封筒を作成',
      });

  String get quickLogExpense => _localizedValue({
        'en': 'Quick Log Expense',
        'bn': 'দ্রুত খরচ যোগ করুন',
        'es': 'Registro Rápido de Gasto',
        'fr': 'Saisie Rapide de Dépense',
        'de': 'Ausgabe schnell erfassen',
        'hi': 'त्वरित खर्च दर्ज करें',
        'ar': 'تسجيل سريع للإنفاق',
        'zh': '秒级记录支出',
        'ja': '支出を素早く記録',
      });

  String get expenseNote => _localizedValue({
        'en': 'Expense Note',
        'bn': 'খরচের বিবরণ/নোট',
        'es': 'Nota del Gasto',
        'fr': 'Note sur la dépense',
        'de': 'Notiz zur Ausgabe',
        'hi': 'खर्च का विवरण',
        'ar': 'ملاحظة الإنفاق',
        'zh': '支出备注说明',
        'ja': '支出メモ',
      });

  String get expenseNoteHint => _localizedValue({
        'en': 'e.g. Dinner, Taxi, Museum ticket',
        'bn': 'যেমন: রাতের খাবার, ট্যাক্সি ভাড়া',
        'es': 'ej. Cena, Taxi, Boletos',
        'fr': 'ex. Dîner, Taxi, Billet',
        'de': 'z.B. Abendessen, Taxi, Eintritt',
        'hi': 'जैसे: डिनर, टैक्सी, टिकट',
        'ar': 'مثل عشاء، تاكسي، تذاكر',
        'zh': '如 晚餐、打车、门票',
        'ja': '例: ディナー, タクシー, チケット',
      });

  String get logTransaction => _localizedValue({
        'en': 'Log Transaction',
        'bn': 'লেনদেন যোগ করুন',
        'es': 'Registrar Transacción',
        'fr': 'Valider la Transaction',
        'de': 'Transaktion buchen',
        'hi': 'लेन-देन दर्ज करें',
        'ar': 'تسجيل المعاملة',
        'zh': '确认记账',
        'ja': '取引を登録',
      });

  String get recentLogs => _localizedValue({
        'en': 'Recent Logs',
        'bn': 'সাম্প্রতিক খরচের হিসাব',
        'es': 'Registros Recientes',
        'fr': 'Historique Récent',
        'de': 'Letzte Einträge',
        'hi': 'हाल के लॉग',
        'ar': 'السجلات الأخيرة',
        'zh': '近期支出明细',
        'ja': '最近の支出ログ',
      });

  String entriesCount(int count) {
    final c = formatNumber(count.toString());
    return _localizedValue({
      'en': '$c entries',
      'bn': '$c টি এন্ট্রি',
      'es': '$c registros',
      'fr': '$c entrées',
      'de': '$c Einträge',
      'hi': '$c प्रविष्टियां',
      'ar': '$c عمليات',
      'zh': '$c 条记录',
      'ja': '$c 件',
    });
  }

  // -------------------------------------------------------------
  // 8. Interval & Rest Timer
  // -------------------------------------------------------------
  String get timerTitle => getModuleTitle('interval_timer');

  String get timerSubtitle => _localizedValue({
        'en': 'Custom HIIT & Workout Rounds',
        'bn': 'কাস্টম এইচআইআইটি ও ওয়ার্কআউট রাউন্ড',
        'es': 'HIIT Personalizado y Rondas de Entrenamiento',
        'fr': 'HIIT Personnalisé et Séries d\'Entraînement',
        'de': 'Individuelles HIIT & Trainingsrunden',
        'hi': 'कस्टम HIIT और वर्कआउट राउंड',
        'ar': 'تمارين متواترة عالية الكثافة وجولات مخصصة',
        'zh': '自定义高强度间歇健身组与节奏节拍',
        'ja': 'カスタムHIIT＆インターバルトレーニング',
      });

  String get start => _localizedValue({
        'en': 'Start',
        'bn': 'শুরু করুন',
        'es': 'Iniciar',
        'fr': 'Démarrer',
        'de': 'Starten',
        'hi': 'शुरू करें',
        'ar': 'ابدأ',
        'zh': '开始',
        'ja': '開始',
      });

  String get pause => _localizedValue({
        'en': 'Pause',
        'bn': 'বিরতি',
        'es': 'Pausa',
        'fr': 'Pause',
        'de': 'Pause',
        'hi': 'रोकें',
        'ar': 'إيقاف مؤقت',
        'zh': '暂停',
        'ja': '一時停止',
      });

  String get reset => _localizedValue({
        'en': 'Reset',
        'bn': 'রিসেট',
        'es': 'Reiniciar',
        'fr': 'Réinitialiser',
        'de': 'Zurücksetzen',
        'hi': 'रीसेट करें',
        'ar': 'إعادة ضبط',
        'zh': '重置',
        'ja': 'リセット',
      });

  String get phaseGetReady => _localizedValue({
        'en': 'GET READY',
        'bn': 'প্রস্তুত হোন',
        'es': 'PREPÁRATE',
        'fr': 'PRÉPAREZ-VOUS',
        'de': 'BEREITMACHEN',
        'hi': 'तैयार हो जाइए',
        'ar': 'استعد',
        'zh': '准备',
        'ja': '準備',
      });

  String get phaseWorkHard => _localizedValue({
        'en': 'WORK HARD',
        'bn': 'অনুশীলন',
        'es': 'ENTRENA',
        'fr': 'EFFORT',
        'de': 'TRAINIEREN',
        'hi': 'मेहनत करें',
        'ar': 'تمرين',
        'zh': '全力训练',
        'ja': 'ワークアウト',
      });

  String get phaseRestAndBreathe => _localizedValue({
        'en': 'REST & BREATHE',
        'bn': 'বিশ্রাম ও শ্বাস নিন',
        'es': 'DESCANSA Y RESPIRA',
        'fr': 'REPOS & RESPIRATION',
        'de': 'PAUSE & DURCHATMEN',
        'hi': 'विश्राम व सांस लें',
        'ar': 'استراحة وتنفس',
        'zh': '休息调整',
        'ja': '休憩＆呼吸',
      });

  String get phaseCoolDown => _localizedValue({
        'en': 'COOL DOWN',
        'bn': 'কুল ডাউন',
        'es': 'ENFRIAMIENTO',
        'fr': 'RÉCUPÉRATION',
        'de': 'ABKÜHLEN',
        'hi': 'कूल डाउन',
        'ar': 'تهدئة',
        'zh': '放松整理',
        'ja': 'クールダウン',
      });

  String get phaseWorkoutCompleted => _localizedValue({
        'en': 'WORKOUT COMPLETED',
        'bn': 'অনুশীলন সম্পন্ন!',
        'es': 'ENTRENAMIENTO COMPLETADO',
        'fr': 'ENTRAÎNEMENT TERMINÉ',
        'de': 'TRAINING ABGESCHLOSSEN',
        'hi': 'वर्कआउट पूरा हुआ!',
        'ar': 'اكتمل التمرين!',
        'zh': '训练完成！',
        'ja': 'ワークアウト完了！',
      });

  String get phaseReady => _localizedValue({
        'en': 'READY',
        'bn': 'প্রস্তুত',
        'es': 'LISTO',
        'fr': 'PRÊT',
        'de': 'BEREIT',
        'hi': 'तैयार',
        'ar': 'جاهز',
        'zh': '就绪',
        'ja': 'スタンバイ',
      });

  String get customTimerRoutine => _localizedValue({
        'en': 'Custom Timer Routine',
        'bn': 'কাস্টম টাইমার রুটিন',
        'es': 'Rutina de Temporizador Personalizada',
        'fr': 'Minuteur Personnalisé',
        'de': 'Eigene Timer-Routine',
        'hi': 'कस्टम टाइमर रूटीन',
        'ar': 'روتين مؤقت مخصص',
        'zh': '自定义间歇训练组',
        'ja': 'カスタムタイマールーチン',
      });

  String get routineNameLabel => _localizedValue({
        'en': 'Routine Name',
        'bn': 'রুটিনের নাম',
        'es': 'Nombre de la Rutina',
        'fr': 'Nom de la Routine',
        'de': 'Name der Routine',
        'hi': 'रूटीन का नाम',
        'ar': 'اسم الروتين',
        'zh': '训练计划名称',
        'ja': 'ルーチン名',
      });

  String get routineNameHint => _localizedValue({
        'en': 'e.g. Abs Burn, EMOM, Kettlebell',
        'bn': 'যেমন: অ্যাবস বার্ন, কেটলবেল',
        'es': 'ej. Abdominales, EMOM',
        'fr': 'ex. Abdos, EMOM',
        'de': 'z.B. Bauchmuskeln, EMOM',
        'hi': 'जैसे: एब्स बर्न, केटलबेल',
        'ar': 'مثل عضلات البطن، كيتل بيل',
        'zh': '如 腹肌撕裂、壶铃燃脂',
        'ja': '例: 腹筋トレーニング, ケトルベル',
      });

  String get enterRoutineName => _localizedValue({
        'en': 'Enter a routine name',
        'bn': 'একটি রুটিনের নাম লিখুন',
        'es': 'Ingresa un nombre para la rutina',
        'fr': 'Entrez un nom de routine',
        'de': 'Namen der Routine eingeben',
        'hi': 'रूटीन का नाम दर्ज करें',
        'ar': 'أدخل اسم الروتين',
        'zh': '请输入训练计划名称',
        'ja': 'ルーチン名を入力してください',
      });

  String get workSec => _localizedValue({
        'en': 'Work (Sec)',
        'bn': 'অনুশীলন (সেকেন্ড)',
        'es': 'Trabajo (Seg)',
        'fr': 'Effort (Sec)',
        'de': 'Training (Sek)',
        'hi': 'व्यायाम (सेकंड)',
        'ar': 'التمرين (ثانية)',
        'zh': '运动 (秒)',
        'ja': 'ワーク (秒)',
      });

  String get restSec => _localizedValue({
        'en': 'Rest (Sec)',
        'bn': 'বিশ্রাম (সেকেন্ড)',
        'es': 'Descanso (Seg)',
        'fr': 'Repos (Sec)',
        'de': 'Pause (Sek)',
        'hi': 'विश्राम (सेकंड)',
        'ar': 'الراحة (ثانية)',
        'zh': '休息 (秒)',
        'ja': 'レスト (秒)',
      });

  String get totalSetsRounds => _localizedValue({
        'en': 'Total Sets / Rounds',
        'bn': 'মোট সেট বা রাউন্ড',
        'es': 'Total de Series / Rondas',
        'fr': 'Total Séries / Tours',
        'de': 'Gesamte Sätze / Runden',
        'hi': 'कुल सेट / राउंड',
        'ar': 'إجمالي الجولات',
        'zh': '总组数 / 循环轮数',
        'ja': '合計セット / ラウンド数',
      });

  String get prepCountdownSec => _localizedValue({
        'en': 'Prep Countdown (Sec)',
        'bn': 'প্রস্তুতি কাউন্টডাউন (সেকেন্ড)',
        'es': 'Cuenta Regresiva Previa (Seg)',
        'fr': 'Préparation (Sec)',
        'de': 'Vorbereitung (Sek)',
        'hi': 'तैयारी उलटी गिनती (सेकंड)',
        'ar': 'الاستعداد (ثانية)',
        'zh': '准备倒计时 (秒)',
        'ja': '準備カウントダウン (秒)',
      });

  String get saveRoutine => _localizedValue({
        'en': 'Save Routine',
        'bn': 'রুটিন সংরক্ষণ করুন',
        'es': 'Guardar Rutina',
        'fr': 'Enregistrer Routine',
        'de': 'Routine speichern',
        'hi': 'रूटीन सहेजें',
        'ar': 'حفظ الروتين',
        'zh': '保存训练计划',
        'ja': 'ルーチンを保存',
      });

  String get workoutRoutinePresets => _localizedValue({
        'en': 'Workout Routine Presets',
        'bn': 'ওয়ার্কআউট রুটিন প্রিসেট',
        'es': 'Rutinas Predefinidas',
        'fr': 'Préréglages d\'Entraînement',
        'de': 'Workout-Vorlagen',
        'hi': 'वर्कआउट रूटीन प्रीसेट',
        'ar': 'قوالب التمارين الجاهزة',
        'zh': '经典健身方案预设',
        'ja': 'ワークアウトルーチン一覧',
      });

  String get customInterval => _localizedValue({
        'en': 'Custom Interval',
        'bn': 'কাস্টম ইন্টারভাল',
        'es': 'Intervalo Personalizado',
        'fr': 'Personnalisé',
        'de': 'Benutzerdefiniert',
        'hi': 'कस्टम इंटरवल',
        'ar': 'فترة مخصصة',
        'zh': '自定义间歇',
        'ja': 'カスタム間隔',
      });

  String setOfTotal(int current, int total) {
    final c = formatNumber(current.toString());
    final t = formatNumber(total.toString());
    return _localizedValue({
      'en': 'SET $c OF $t',
      'bn': 'সেট $c / $t',
      'es': 'SERIE $c DE $t',
      'fr': 'SÉRIE $c SUR $t',
      'de': 'SATZ $c VON $t',
      'hi': 'सेट $c / $t',
      'ar': 'الجولة $c من $t',
      'zh': '第 $c 组 (共 $t 组)',
      'ja': 'セット $c / $t',
    });
  }

  String totalElapsed(String elapsed) {
    final e = formatNumber(elapsed);
    return _localizedValue({
      'en': 'Total Elapsed: $e',
      'bn': 'মোট অতিবাহিত: $e',
      'es': 'Total Transcurrido: $e',
      'fr': 'Temps Écoulé: $e',
      'de': 'Gesamtzeit: $e',
      'hi': 'कुल बीता समय: $e',
      'ar': 'الوقت المستغرق: $e',
      'zh': '总耗时: $e',
      'ja': '総経過時間: $e',
    });
  }

  String get allZones => _localizedValue({
        'en': 'All Zones',
        'bn': 'সকল জোন',
        'es': 'Todas las Zonas',
        'fr': 'Toutes les Zones',
        'de': 'Alle Zonen',
        'hi': 'सभी ज़ोन',
        'ar': 'جميع المناطق',
        'zh': '全部区域',
        'ja': '全ゾーン',
      });

  String get searchPantryHint => _localizedValue({
        'en': 'Search items in fridge or pantry...',
        'bn': 'ফ্রিজ বা প্যান্ট্রির পণ্য খুঁজুন...',
        'es': 'Buscar en refrigerador o despensa...',
        'fr': 'Rechercher dans le réfrigérateur...',
        'de': 'Im Vorrat oder Kühlschrank suchen...',
        'hi': 'फ्रिज या पेंट्री में सामान खोजें...',
        'ar': 'ابحث في الثلاجة أو المؤن...',
        'zh': '搜索冰箱或储物柜中的物品...',
        'ja': '冷蔵庫やパントリーを検索...',
      });

  String get noPantryItemsTitle => _localizedValue({
        'en': 'No Items in this Zone',
        'bn': 'এই জোনে কোনো পণ্য নেই',
        'es': 'No Hay Artículos en esta Zona',
        'fr': 'Aucun Article dans cette Zone',
        'de': 'Keine Artikel in dieser Zone',
        'hi': 'इस ज़ोन में कोई सामान नहीं है',
        'ar': 'لا توجد عناصر في هذه المنطقة',
        'zh': '该分区暂无存放物品',
        'ja': 'このゾーンにはアイテムがありません',
      });

  String get noPantryItemsDesc => _localizedValue({
        'en': 'Add groceries or medicine to start receiving smart freshness alerts.',
        'bn': 'স্মার্ট ফ্রেশনেস ও মেয়াদ অ্যালার্ট পেতে মুদিপণ্য বা ওষুধ যোগ করুন।',
        'es': 'Agrega alimentos o medicinas para recibir alertas de frescura.',
        'fr': 'Ajoutez des aliments ou médicaments pour activer les alertes.',
        'de': 'Lebensmittel oder Medikamente hinzufügen für Frischewarnungen.',
        'hi': 'स्मार्ट ताज़गी अलर्ट पाने के लिए किराना या दवाएं जोड़ें।',
        'ar': 'أضف أطعمة أو أدوية لبدء تلقي تنبيهات الصلاحية الذكية.',
        'zh': '添加食品或药品即可开启智能保质期与临期预警提醒。',
        'ja': '食料品や薬を追加して、スマートな鮮度・賞味期限通知を受け取りましょう。',
      });

  String get markAvailable => _localizedValue({
        'en': 'Mark Available',
        'bn': 'মজুদ হিসেবে চিহ্নিত করুন',
        'es': 'Marcar Disponible',
        'fr': 'Marquer Disponible',
        'de': 'Als verfügbar markieren',
        'hi': 'उपलब्ध चिह्नित करें',
        'ar': 'تحديد كمتوفر',
        'zh': '标记为未食用',
        'ja': '利用可能にする',
      });

  String get markConsumed => _localizedValue({
        'en': 'Mark Consumed',
        'bn': 'ব্যবহৃত/খাওয়া হয়েছে',
        'es': 'Marcar Consumido',
        'fr': 'Marquer Consommé',
        'de': 'Als verbraucht markieren',
        'hi': 'उपयोग हुआ चिह्नित करें',
        'ar': 'تحديد كمستهلك',
        'zh': '标记为已食用',
        'ja': '消費済みにする',
      });

  String get expiryLabel => _localizedValue({
        'en': 'Expiry',
        'bn': 'মেয়াদ',
        'es': 'Vencimiento',
        'fr': 'Expiration',
        'de': 'Ablauf',
        'hi': 'समाप्ति',
        'ar': 'الصلاحية',
        'zh': '到期',
        'ja': '期限',
      });

  String get qtyLabel => _localizedValue({
        'en': 'Qty',
        'bn': 'পরিমাণ',
        'es': 'Cant.',
        'fr': 'Qté',
        'de': 'Menge',
        'hi': 'मात्रा',
        'ar': 'الكمية',
        'zh': '数量',
        'ja': '数量',
      });

  String getLocalizedPantryItemName(String name) {
    if (languageCode == 'en') return name;
    final trimmed = name.trim();
    if (trimmed == 'Milk') {
      return _localizedValue({
        'bn': 'দুধ', 'es': 'Leche', 'fr': 'Lait', 'de': 'Milch', 'hi': 'दूध', 'ar': 'حليب', 'zh': '牛奶', 'ja': '牛乳',
      });
    } else if (trimmed == 'Eggs') {
      return _localizedValue({
        'bn': 'ডিম', 'es': 'Huevos', 'fr': 'Œufs', 'de': 'Eier', 'hi': 'अंडे', 'ar': 'بيض', 'zh': '鸡蛋', 'ja': '卵',
      });
    } else if (trimmed == 'Bread') {
      return _localizedValue({
        'bn': 'পাউরুটি', 'es': 'Pan', 'fr': 'Pain', 'de': 'Brot', 'hi': 'ब्रेड', 'ar': 'خبز', 'zh': '面包', 'ja': 'パン',
      });
    } else if (trimmed == 'Yogurt') {
      return _localizedValue({
        'bn': 'দই', 'es': 'Yogur', 'fr': 'Yaourt', 'de': 'Joghurt', 'hi': 'दही', 'ar': 'زبادي', 'zh': '酸奶', 'ja': 'ヨーグルト',
      });
    } else if (trimmed == 'Medicine') {
      return _localizedValue({
        'bn': 'ওষুধ', 'es': 'Medicina', 'fr': 'Médicament', 'de': 'Medikamente', 'hi': 'दवा', 'ar': 'دواء', 'zh': '药品', 'ja': '薬',
      });
    }
    return name;
  }

  String getLocalizedPantryUnit(String unit) {
    if (languageCode == 'en') return unit;
    final trimmed = unit.trim().toLowerCase();
    if (trimmed == 'pcs' || trimmed == 'pc') {
      return _localizedValue({
        'bn': 'টি', 'es': 'pzs', 'fr': 'pcs', 'de': 'Stk', 'hi': 'नग', 'ar': 'قطع', 'zh': '个', 'ja': '個',
      });
    } else if (trimmed == 'kg') {
      return _localizedValue({
        'bn': 'কেজি', 'es': 'kg', 'fr': 'kg', 'de': 'kg', 'hi': 'किग्रा', 'ar': 'كجم', 'zh': '公斤', 'ja': 'kg',
      });
    } else if (trimmed == 'g') {
      return _localizedValue({
        'bn': 'গ্রাম', 'es': 'g', 'fr': 'g', 'de': 'g', 'hi': 'ग्राम', 'ar': 'جم', 'zh': '克', 'ja': 'g',
      });
    } else if (trimmed == 'l') {
      return _localizedValue({
        'bn': 'লিটার', 'es': 'L', 'fr': 'L', 'de': 'L', 'hi': 'लीटर', 'ar': 'لتر', 'zh': '升', 'ja': 'L',
      });
    } else if (trimmed == 'ml') {
      return _localizedValue({
        'bn': 'মি.লি.', 'es': 'ml', 'fr': 'ml', 'de': 'ml', 'hi': 'मिली', 'ar': 'مل', 'zh': '毫升', 'ja': 'ml',
      });
    }
    return unit;
  }

  String get noBudgetEnvelopesDesc => _localizedValue({
        'en': 'Create a micro-budget envelope for your trip, weekend, or daily allowance.',
        'bn': 'আপনার ভ্রমণ, উইকেন্ড বা নির্দিষ্ট খরচের জন্য একটি বাজেট খাম তৈরি করুন।',
        'es': 'Crea un sobre de presupuesto para tu viaje o gastos diarios.',
        'fr': 'Créez une enveloppe budgétaire pour un voyage ou vos dépenses quotidiennes.',
        'de': 'Erstellen Sie einen Budget-Umschlag für Ihre Reise oder das Wochenende.',
        'hi': 'अपनी यात्रा, सप्ताहांत या दैनिक खर्च के लिए एक बजट लिफ़ाफ़ा बनाएं।',
        'ar': 'أنشئ ظرف ميزانية لرحلتك أو نفقات عطلة نهاية الأسبوع.',
        'zh': '为短途旅行、周末聚会或特定支出创建独立预算信封。',
        'ja': '旅行や週末、特定イベントのための目的別封筒予算を作成しましょう。',
      });

  String get noSpendLogged => _localizedValue({
        'en': 'No spend logged for this envelope yet.',
        'bn': 'এই খামে এখনো কোনো খরচ যোগ করা হয়নি।',
        'es': 'Aún no se han registrado gastos en este sobre.',
        'fr': 'Aucune dépense enregistrée pour cette enveloppe.',
        'de': 'Noch keine Ausgaben für diesen Umschlag gebucht.',
        'hi': 'इस लिफ़ाफ़े में अभी तक कोई खर्च दर्ज नहीं हुआ है।',
        'ar': 'لم يتم تسجيل أي إنفاق لهذا الظرف بعد.',
        'zh': '该信封尚未记录任何支出明细。',
        'ja': 'この封筒にはまだ支出が記録されていません。',
      });

  String get quickSpendDefaultTitle => _localizedValue({
        'en': 'Quick Spend',
        'bn': 'দ্রুত খরচ',
        'es': 'Gasto Rápido',
        'fr': 'Dépense Rapide',
        'de': 'Schnellausgabe',
        'hi': 'त्वरित खर्च',
        'ar': 'إنفاق سريع',
        'zh': '快捷支出',
        'ja': 'クイック支出',
      });

  String getLocalizedEnvelopeName(String name) {
    if (languageCode == 'en') return name;
    final trimmed = name.trim();
    if (trimmed == 'Weekend Trip') {
      return _localizedValue({
        'bn': 'উইকেন্ড ট্রিপ / ছুটি', 'es': 'Viaje de Fin de Semana', 'fr': 'Escapade Weekend', 'de': 'Wochenendausflug', 'hi': 'वीकेंड ट्रिप', 'ar': 'رحلة نهاية الأسبوع', 'zh': '周末短途游', 'ja': '週末旅行',
      });
    } else if (trimmed == 'Dining Out') {
      return _localizedValue({
        'bn': 'বাইরে ডাইনিং ও রেস্তোরাঁ', 'es': 'Restaurantes y Cenas', 'fr': 'Sorties & Restaurants', 'de': 'Restaurant & Ausgehen', 'hi': 'बाहर खाना', 'ar': 'المطاعم والمأكولات', 'zh': '外出就餐', 'ja': '外食・カフェ',
      });
    } else if (trimmed == 'Grocery & Daily Food') {
      return _localizedValue({
        'bn': 'মুদি ও দৈনন্দিন খাবার', 'es': 'Supermercado y Alimentos', 'fr': 'Courses & Alimentation', 'de': 'Lebensmitteleinkauf', 'hi': 'किराना व भोजन', 'ar': 'البقالة والمؤن', 'zh': '生鲜果蔬', 'ja': '食料品買い出し',
      });
    }
    return name;
  }

  String getLocalizedCategoryTag(String tag) {
    if (languageCode == 'en') return tag;
    final trimmed = tag.trim();
    if (trimmed == 'Food & Drinks') {
      return _localizedValue({
        'bn': 'খাবার ও পানীয়', 'es': 'Comida y Bebidas', 'fr': 'Nourriture & Boissons', 'de': 'Essen & Trinken', 'hi': 'खाना व पेय', 'ar': 'طعام ومشروبات', 'zh': '餐饮美食', 'ja': '飲食・ドリンク',
      });
    } else if (trimmed == 'Shopping') {
      return _localizedValue({
        'bn': 'কেনাকাটা', 'es': 'Compras', 'fr': 'Achats', 'de': 'Einkaufen', 'hi': 'खरीदारी', 'ar': 'تسوق', 'zh': '购物消费', 'ja': 'ショッピング',
      });
    } else if (trimmed == 'Transport') {
      return _localizedValue({
        'bn': 'যাতায়াত ও ভাড়া', 'es': 'Transporte', 'fr': 'Transports', 'de': 'Transport', 'hi': 'परिवहन', 'ar': 'المواصلات', 'zh': '交通出行', 'ja': '交通費',
      });
    } else if (trimmed == 'Entertainment') {
      return _localizedValue({
        'bn': 'বিনোদন', 'es': 'Entretenimiento', 'fr': 'Divertissement', 'de': 'Unterhaltung', 'hi': 'मनोरंजन', 'ar': 'ترفيه', 'zh': '休闲娱乐', 'ja': 'エンタメ',
      });
    } else if (trimmed == 'Activities') {
      return _localizedValue({
        'bn': 'অ্যাক্টিভিটি', 'es': 'Actividades', 'fr': 'Activités', 'de': 'Aktivitäten', 'hi': 'गतिविधियाँ', 'ar': 'أنشطة', 'zh': '项目体验', 'ja': 'アクティビティ',
      });
    } else if (trimmed == 'General') {
      return _localizedValue({
        'bn': 'সাধারণ', 'es': 'General', 'fr': 'Général', 'de': 'Allgemein', 'hi': 'सामान्य', 'ar': 'عام', 'zh': '日常杂项', 'ja': '一般',
      });
    }
    return tag;
  }

  String get setsLabel => _localizedValue({
        'en': 'Sets', 'bn': 'সেট', 'es': 'Series', 'fr': 'Séries', 'de': 'Sätze', 'hi': 'सेट', 'ar': 'جولات', 'zh': '组', 'ja': 'セット',
      });

  String get totalLabel => _localizedValue({
        'en': 'Total', 'bn': 'মোট', 'es': 'Total', 'fr': 'Total', 'de': 'Gesamt', 'hi': 'कुल', 'ar': 'الإجمالي', 'zh': '总计', 'ja': '合計',
      });

  String get phaseWork => _localizedValue({
        'en': 'Work', 'bn': 'অনুশীলন', 'es': 'Trabajo', 'fr': 'Effort', 'de': 'Training', 'hi': 'व्यायाम', 'ar': 'تمرين', 'zh': '运动', 'ja': 'ワーク',
      });

  String get phaseRest => _localizedValue({
        'en': 'Rest', 'bn': 'বিশ্রাম', 'es': 'Descanso', 'fr': 'Repos', 'de': 'Pause', 'hi': 'विश्राम', 'ar': 'راحة', 'zh': '休息', 'ja': 'レスト',
      });

  String getLocalizedPresetName(String name) {
    if (languageCode == 'en') return name;
    final trimmed = name.trim();
    if (trimmed == 'Tabata Protocol') {
      return _localizedValue({
        'bn': 'তাবাতা প্রোটোকল', 'es': 'Protocolo Tabata', 'fr': 'Protocole Tabata', 'de': 'Tabata-Protokoll', 'hi': 'तबाता प्रोटोकॉल', 'ar': 'نظام تاباتا', 'zh': 'Tabata高强度间歇', 'ja': 'タバタプロトコル',
      });
    } else if (trimmed == 'HIIT Cardio Blast') {
      return _localizedValue({
        'bn': 'এইচআইআইটি কার্ডিও', 'es': 'HIIT Cardio Intenso', 'fr': 'HIIT Cardio Explosif', 'de': 'HIIT Cardio Power', 'hi': 'HIIT कार्डियो', 'ar': 'تمارين حرق الكارديو', 'zh': 'HIIT燃脂心肺', 'ja': 'HIIT有酸素',
      });
    } else if (trimmed == 'Boxing Sparring') {
      return _localizedValue({
        'bn': 'বক্সিং স্প্যারিং', 'es': 'Sparring de Boxeo', 'fr': 'Sparring Boxe', 'de': 'Box-Sparring', 'hi': 'बॉक्सिंग स्पैरिंग', 'ar': 'جولات الملاكمة', 'zh': '拳击对战回合', 'ja': 'ボクシングスパーリング',
      });
    } else if (trimmed == 'Stretch & Rest') {
      return _localizedValue({
        'bn': 'স্ট্রেচ ও বিশ্রাম', 'es': 'Estiramiento y Descanso', 'fr': 'Étirement & Repos', 'de': 'Dehnen & Entspannen', 'hi': 'स्ट्रेच व आराम', 'ar': 'تمدد واسترخاء', 'zh': '拉伸舒展', 'ja': 'ストレッチ＆休息',
      });
    }
    return name;
  }

  String getLocalizedCompressionPresetTitle(CompressionPresetType type) {
    switch (type) {
      case CompressionPresetType.targetKb200:
        return _localizedValue({
          'en': 'Portal Standard (<200KB)',
          'bn': 'পোর্টাল স্ট্যান্ডার্ড (<২০০KB)',
          'es': 'Estándar Portal (<200KB)',
          'fr': 'Standard Portail (<200KB)',
          'de': 'Web-Standard (<200KB)',
          'hi': 'पोर्टल मानक (<200KB)',
          'ar': 'معيار البوابات (<200KB)',
          'zh': '通用网申标准 (<200KB)',
          'ja': 'ポータル標準 (<200KB)',
        });
      case CompressionPresetType.targetKb100:
        return _localizedValue({
          'en': 'Ultra Compact (<100KB)',
          'bn': 'আল্ট্রা কমপ্যাক্ট (<১০০KB)',
          'es': 'Ultra Compacto (<100KB)',
          'fr': 'Ultra Compact (<100KB)',
          'de': 'Ultra-Kompakt (<100KB)',
          'hi': 'अल्ट्रा कॉम्पैक्ट (<100KB)',
          'ar': 'حجم مضغوط جداً (<100KB)',
          'zh': '极简极限压缩 (<100KB)',
          'ja': '超コンパクト (<100KB)',
        });
      case CompressionPresetType.passportPhoto:
        return _localizedValue({
          'en': 'Passport 2x2 (600x600)',
          'bn': 'পাসপোর্ট ২x২ (৬০০x৬০০)',
          'es': 'Pasaporte 2x2 (600x600)',
          'fr': 'Passeport 2x2 (600x600)',
          'de': 'Passbild 2x2 (600x600)',
          'hi': 'पासपोर्ट 2x2 (600x600)',
          'ar': 'صورة جواز السفر (600x600)',
          'zh': '标准证件照 (600x600)',
          'ja': 'パスポート 2x2 (600x600)',
        });
      case CompressionPresetType.signatureStrip:
        return _localizedValue({
          'en': 'Signature Strip',
          'bn': 'স্বাক্ষর / সিগনেচার',
          'es': 'Firma Digital',
          'fr': 'Bande de Signature',
          'de': 'Unterschriften-Streifen',
          'hi': 'हस्ताक्षर पट्टी',
          'ar': 'شريط التوقيع',
          'zh': '电子签名栏',
          'ja': '署名・サイン用',
        });
      case CompressionPresetType.a4Document:
        return _localizedValue({
          'en': 'A4 Document Scan',
          'bn': 'এ৪ ডকুমেন্ট স্ক্যান',
          'es': 'Escaneo de Documento A4',
          'fr': 'Document A4 Numérisé',
          'de': 'A4 Dokumenten-Scan',
          'hi': 'A4 दस्तावेज़ स्कैन',
          'ar': 'مسح ضوئي لمستند A4',
          'zh': 'A4文档高清扫描',
          'ja': 'A4文書スキャン',
        });
      case CompressionPresetType.custom:
        return _localizedValue({
          'en': 'Custom Target',
          'bn': 'কাস্টম সাইজ',
          'es': 'Personalizado',
          'fr': 'Personnalisé',
          'de': 'Benutzerdefiniert',
          'hi': 'कस्टम आकार',
          'ar': 'حجم مخصص',
          'zh': '自定义大小',
          'ja': 'カスタム',
        });
    }
  }

  // Internal helper for localized map lookup with English fallback
  String _localizedValue(Map<String, String> values) {
    return values[locale.languageCode] ?? values['en'] ?? '';
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'bn', 'es', 'fr', 'de', 'hi', 'ar', 'zh', 'ja']
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
