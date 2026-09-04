import 'package:equatable/equatable.dart';

class AppCurrency extends Equatable {
  final String code;
  final String symbol;
  final String name;
  final String country;

  const AppCurrency({
    required this.code,
    required this.symbol,
    required this.name,
    this.country = '',
  });

  String get displayTitle => '$code ($symbol)';
  String get displaySubtitle => name.isNotEmpty ? name : code;
  String get fullSearchText => '$code $symbol $name $country'.toLowerCase();

  @override
  List<Object?> get props => [code, symbol, name, country];
}

/// Comprehensive curated registry of world currencies
const List<AppCurrency> kSupportedCurrencies = [
  AppCurrency(code: 'USD', symbol: '\$', name: 'United States Dollar', country: 'United States'),
  AppCurrency(code: 'EUR', symbol: '€', name: 'Euro', country: 'European Union'),
  AppCurrency(code: 'GBP', symbol: '£', name: 'British Pound Sterling', country: 'United Kingdom'),
  AppCurrency(code: 'BDT', symbol: '৳', name: 'Bangladeshi Taka', country: 'Bangladesh'),
  AppCurrency(code: 'INR', symbol: '₹', name: 'Indian Rupee', country: 'India'),
  AppCurrency(code: 'CAD', symbol: 'CA\$', name: 'Canadian Dollar', country: 'Canada'),
  AppCurrency(code: 'AUD', symbol: 'AU\$', name: 'Australian Dollar', country: 'Australia'),
  AppCurrency(code: 'JPY', symbol: '¥', name: 'Japanese Yen', country: 'Japan'),
  AppCurrency(code: 'CNY', symbol: '¥', name: 'Chinese Yuan', country: 'China'),
  AppCurrency(code: 'CHF', symbol: 'CHF', name: 'Swiss Franc', country: 'Switzerland'),
  AppCurrency(code: 'SGD', symbol: 'SG\$', name: 'Singapore Dollar', country: 'Singapore'),
  AppCurrency(code: 'AED', symbol: 'AED', name: 'United Arab Emirates Dirham', country: 'United Arab Emirates'),
  AppCurrency(code: 'SAR', symbol: 'SAR', name: 'Saudi Riyal', country: 'Saudi Arabia'),
  AppCurrency(code: 'PKR', symbol: '₨', name: 'Pakistani Rupee', country: 'Pakistan'),
  AppCurrency(code: 'MYR', symbol: 'RM', name: 'Malaysian Ringgit', country: 'Malaysia'),
  AppCurrency(code: 'BRL', symbol: 'R\$', name: 'Brazilian Real', country: 'Brazil'),
  AppCurrency(code: 'TRY', symbol: '₺', name: 'Turkish Lira', country: 'Turkey'),
  AppCurrency(code: 'KRW', symbol: '₩', name: 'South Korean Won', country: 'South Korea'),
  AppCurrency(code: 'IDR', symbol: 'Rp', name: 'Indonesian Rupiah', country: 'Indonesia'),
  AppCurrency(code: 'PHP', symbol: '₱', name: 'Philippine Peso', country: 'Philippines'),
  AppCurrency(code: 'VND', symbol: '₫', name: 'Vietnamese Dong', country: 'Vietnam'),
  AppCurrency(code: 'THB', symbol: '฿', name: 'Thai Baht', country: 'Thailand'),
  AppCurrency(code: 'NZD', symbol: 'NZ\$', name: 'New Zealand Dollar', country: 'New Zealand'),
  AppCurrency(code: 'MXN', symbol: 'MX\$', name: 'Mexican Peso', country: 'Mexico'),
  AppCurrency(code: 'ZAR', symbol: 'R', name: 'South African Rand', country: 'South Africa'),
  AppCurrency(code: 'NGN', symbol: '₦', name: 'Nigerian Naira', country: 'Nigeria'),
  AppCurrency(code: 'EGP', symbol: 'E£', name: 'Egyptian Pound', country: 'Egypt'),
  AppCurrency(code: 'KWD', symbol: 'KD', name: 'Kuwaiti Dinar', country: 'Kuwait'),
  AppCurrency(code: 'QAR', symbol: 'QR', name: 'Qatari Riyal', country: 'Qatar'),
  AppCurrency(code: 'OMR', symbol: 'OMR', name: 'Omani Rial', country: 'Oman'),
  AppCurrency(code: 'BHD', symbol: 'BD', name: 'Bahraini Dinar', country: 'Bahrain'),
  AppCurrency(code: 'SEK', symbol: 'kr', name: 'Swedish Krona', country: 'Sweden'),
  AppCurrency(code: 'NOK', symbol: 'kr', name: 'Norwegian Krone', country: 'Norway'),
  AppCurrency(code: 'DKK', symbol: 'kr', name: 'Danish Krone', country: 'Denmark'),
  AppCurrency(code: 'PLN', symbol: 'zł', name: 'Polish Złoty', country: 'Poland'),
  AppCurrency(code: 'CZK', symbol: 'Kč', name: 'Czech Koruna', country: 'Czech Republic'),
  AppCurrency(code: 'HUF', symbol: 'Ft', name: 'Hungarian Forint', country: 'Hungary'),
  AppCurrency(code: 'ILS', symbol: '₪', name: 'Israeli New Shekel', country: 'Israel'),
  AppCurrency(code: 'CLP', symbol: 'CLP\$', name: 'Chilean Peso', country: 'Chile'),
  AppCurrency(code: 'COP', symbol: 'COL\$', name: 'Colombian Peso', country: 'Colombia'),
  AppCurrency(code: 'PEN', symbol: 'S/', name: 'Peruvian Sol', country: 'Peru'),
  AppCurrency(code: 'ARS', symbol: 'AR\$', name: 'Argentine Peso', country: 'Argentina'),
  AppCurrency(code: 'RUB', symbol: '₽', name: 'Russian Ruble', country: 'Russia'),
  AppCurrency(code: 'LKR', symbol: 'Rs', name: 'Sri Lankan Rupee', country: 'Sri Lanka'),
  AppCurrency(code: 'NPR', symbol: 'NRs', name: 'Nepalese Rupee', country: 'Nepal'),
  AppCurrency(code: 'KES', symbol: 'KSh', name: 'Kenyan Shilling', country: 'Kenya'),
  AppCurrency(code: 'GHS', symbol: 'GH₵', name: 'Ghanaian Cedi', country: 'Ghana'),
  AppCurrency(code: 'MAD', symbol: 'MAD', name: 'Moroccan Dirham', country: 'Morocco'),
  AppCurrency(code: 'HKD', symbol: 'HK\$', name: 'Hong Kong Dollar', country: 'Hong Kong'),
  AppCurrency(code: 'TWD', symbol: 'NT\$', name: 'New Taiwan Dollar', country: 'Taiwan'),
];

/// Helper to lookup a currency by code, symbol, or fallback to USD
AppCurrency findCurrency(String query) {
  final clean = query.trim().toUpperCase();
  for (final c in kSupportedCurrencies) {
    if (c.code == clean || c.symbol == query.trim()) {
      return c;
    }
  }
  return kSupportedCurrencies.first; // USD default
}
