import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @manageAccount.
  ///
  /// In en, this message translates to:
  /// **'Manage your account and preferences'**
  String get manageAccount;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @privacyText.
  ///
  /// In en, this message translates to:
  /// **'Your genetic data is processed only for analysis and is not stored on our servers.\nWe do not share your data with any third parties.\nAll analysis is handled securely and privately.'**
  String get privacyText;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @contactText.
  ///
  /// In en, this message translates to:
  /// **'Email: supportmodrik@gmail.com\nWe are here to help you anytime.'**
  String get contactText;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @aboutText.
  ///
  /// In en, this message translates to:
  /// **'Modrik helps you understand your genetic data in a simple and clear way.\nWe analyze your DNA file and provide easy-to-read insights using AI.\nYour data remains private and is not stored after analysis.'**
  String get aboutText;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @noUsername.
  ///
  /// In en, this message translates to:
  /// **'No Username'**
  String get noUsername;

  /// No description provided for @noEmail.
  ///
  /// In en, this message translates to:
  /// **'No Email'**
  String get noEmail;

  /// No description provided for @welcomeTo.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get welcomeTo;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Modrik'**
  String get appName;

  /// No description provided for @understandDNA.
  ///
  /// In en, this message translates to:
  /// **'Understand your DNA better'**
  String get understandDNA;

  /// No description provided for @analyzeDNA.
  ///
  /// In en, this message translates to:
  /// **'Analyze Your DNA'**
  String get analyzeDNA;

  /// No description provided for @uploadVCF.
  ///
  /// In en, this message translates to:
  /// **'Upload your VCF file and get clear insights.'**
  String get uploadVCF;

  /// No description provided for @startAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Start Analysis'**
  String get startAnalysis;

  /// No description provided for @exploreMore.
  ///
  /// In en, this message translates to:
  /// **'Explore more'**
  String get exploreMore;

  /// No description provided for @chooseChatType.
  ///
  /// In en, this message translates to:
  /// **'Choose chat type'**
  String get chooseChatType;

  /// No description provided for @askAboutReport.
  ///
  /// In en, this message translates to:
  /// **'Ask about a report'**
  String get askAboutReport;

  /// No description provided for @selectSavedReports.
  ///
  /// In en, this message translates to:
  /// **'Select from saved reports'**
  String get selectSavedReports;

  /// No description provided for @generalGeneticQuestion.
  ///
  /// In en, this message translates to:
  /// **'General genetic question'**
  String get generalGeneticQuestion;

  /// No description provided for @askAnythingGenetics.
  ///
  /// In en, this message translates to:
  /// **'Ask anything about genetics'**
  String get askAnythingGenetics;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @chatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask AI about your genetics'**
  String get chatSubtitle;

  /// No description provided for @expert.
  ///
  /// In en, this message translates to:
  /// **'Contact Expert'**
  String get expert;

  /// No description provided for @expertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Consult with our experts'**
  String get expertSubtitle;

  /// No description provided for @yourDataPrivate.
  ///
  /// In en, this message translates to:
  /// **'Your data is private'**
  String get yourDataPrivate;

  /// No description provided for @yourDataPrivateText.
  ///
  /// In en, this message translates to:
  /// **'Your data is processed only for analysis and not stored.'**
  String get yourDataPrivateText;

  /// No description provided for @selectAnalysisType.
  ///
  /// In en, this message translates to:
  /// **'Select how you want to analyze your genetic data.'**
  String get selectAnalysisType;

  /// No description provided for @individualAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Individual Analysis'**
  String get individualAnalysis;

  /// No description provided for @individualAnalysisText.
  ///
  /// In en, this message translates to:
  /// **'Analyze one VCF file for a single individual.'**
  String get individualAnalysisText;

  /// No description provided for @crossAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Cross Analysis'**
  String get crossAnalysis;

  /// No description provided for @crossAnalysisText.
  ///
  /// In en, this message translates to:
  /// **'Analyze two VCF files to compare shared or inherited variants.'**
  String get crossAnalysisText;

  /// No description provided for @crossUpload.
  ///
  /// In en, this message translates to:
  /// **'Cross Upload'**
  String get crossUpload;

  /// No description provided for @crossUploadDesc.
  ///
  /// In en, this message translates to:
  /// **'Upload two VCF files to compare shared or inherited variants.'**
  String get crossUploadDesc;

  /// No description provided for @selectFiles.
  ///
  /// In en, this message translates to:
  /// **'Select your VCF files'**
  String get selectFiles;

  /// No description provided for @selectSingleFile.
  ///
  /// In en, this message translates to:
  /// **'Select VCF file'**
  String get selectSingleFile;

  /// No description provided for @noFileSelected.
  ///
  /// In en, this message translates to:
  /// **'No file selected'**
  String get noFileSelected;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get uploadFailed;

  /// No description provided for @chooseFatherFile.
  ///
  /// In en, this message translates to:
  /// **'Choose Father File'**
  String get chooseFatherFile;

  /// No description provided for @chooseMotherFile.
  ///
  /// In en, this message translates to:
  /// **'Choose Mother File'**
  String get chooseMotherFile;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @failedToAnalyze.
  ///
  /// In en, this message translates to:
  /// **'Failed to analyze files'**
  String get failedToAnalyze;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @noSavedReports.
  ///
  /// In en, this message translates to:
  /// **'No saved reports yet'**
  String get noSavedReports;

  /// No description provided for @savedReportsDesc.
  ///
  /// In en, this message translates to:
  /// **'Your analyzed reports will appear here.'**
  String get savedReportsDesc;

  /// No description provided for @savedReports.
  ///
  /// In en, this message translates to:
  /// **'Saved Reports'**
  String get savedReports;

  /// No description provided for @savedReport.
  ///
  /// In en, this message translates to:
  /// **'Saved Report'**
  String get savedReport;

  /// No description provided for @genesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} genes'**
  String genesCount(Object count);

  /// No description provided for @conditionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} conditions'**
  String conditionsCount(Object count);

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @noExplanation.
  ///
  /// In en, this message translates to:
  /// **'No explanation available'**
  String get noExplanation;

  /// No description provided for @chatTitleReport.
  ///
  /// In en, this message translates to:
  /// **'Report Chat'**
  String get chatTitleReport;

  /// No description provided for @chatTitleGeneral.
  ///
  /// In en, this message translates to:
  /// **'General Chat'**
  String get chatTitleGeneral;

  /// No description provided for @reportModeBanner.
  ///
  /// In en, this message translates to:
  /// **'You are asking about a report'**
  String get reportModeBanner;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get messageHint;

  /// No description provided for @typing.
  ///
  /// In en, this message translates to:
  /// **'Typing...'**
  String get typing;

  /// No description provided for @welcomeBot.
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'m Modrik 👋\nAsk me about your report or general genetics.'**
  String get welcomeBot;

  /// No description provided for @reportReceived.
  ///
  /// In en, this message translates to:
  /// **'I have received your report. You can now ask about it.'**
  String get reportReceived;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get serverError;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection error'**
  String get connectionError;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterName;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @leaveEmpty.
  ///
  /// In en, this message translates to:
  /// **'Leave empty if you don\'t want to change it'**
  String get leaveEmpty;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @requiredPassword.
  ///
  /// In en, this message translates to:
  /// **'Required to change email or password'**
  String get requiredPassword;

  /// No description provided for @securityNotice.
  ///
  /// In en, this message translates to:
  /// **'For your security, please enter your current password to save any changes.'**
  String get securityNotice;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully ✅'**
  String get profileUpdated;

  /// No description provided for @noChanges.
  ///
  /// In en, this message translates to:
  /// **'No changes detected'**
  String get noChanges;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password is incorrect'**
  String get wrongPassword;

  /// No description provided for @errorUpdate.
  ///
  /// In en, this message translates to:
  /// **'Error updating profile'**
  String get errorUpdate;

  /// No description provided for @confirmEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your new email to confirm 📩'**
  String get confirmEmail;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter current password to change email or password'**
  String get enterCurrentPassword;

  /// No description provided for @deletePassword.
  ///
  /// In en, this message translates to:
  /// **'Enter current password to delete account'**
  String get deletePassword;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
