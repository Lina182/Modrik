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

  /// No description provided for @chatbot.
  ///
  /// In en, this message translates to:
  /// **'Genetic Assistant'**
  String get chatbot;

  /// No description provided for @chatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask AI about your genetics'**
  String get chatSubtitle;

  /// No description provided for @expertinhome.
  ///
  /// In en, this message translates to:
  /// **'Consult Expert'**
  String get expertinhome;

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
  /// **'Save Report'**
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
  /// **'Please enter your email'**
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
  /// **'Wrong password'**
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

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back you\'ve\nbeen missed!'**
  String get welcomeBack;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account ? Sign Up'**
  String get dontHaveAccount;

  /// No description provided for @pleaseFillFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get pleaseFillFields;

  /// No description provided for @userNull.
  ///
  /// In en, this message translates to:
  /// **'User is null'**
  String get userNull;

  /// No description provided for @tokenVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Token verification failed'**
  String get tokenVerificationFailed;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @noUserFound.
  ///
  /// In en, this message translates to:
  /// **'No user found with this email'**
  String get noUserFound;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmail;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error occurred'**
  String get unexpectedError;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account ? Sign Up'**
  String get noAccount;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get fillAllFields;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account\nand get started!'**
  String get createAccountSubtitle;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log in'**
  String get alreadyHaveAccount;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get weakPassword;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get passwordsDontMatch;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get accountCreated;

  /// No description provided for @userCreationFailed.
  ///
  /// In en, this message translates to:
  /// **'User creation failed'**
  String get userCreationFailed;

  /// No description provided for @emailInUse.
  ///
  /// In en, this message translates to:
  /// **'Email already in use. Try logging in.'**
  String get emailInUse;

  /// No description provided for @forgotPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we will send you a reset link.'**
  String get forgotPasswordDesc;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Reset link sent to your email'**
  String get resetLinkSent;

  /// No description provided for @noAccountFound.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email'**
  String get noAccountFound;

  /// No description provided for @myConsultations.
  ///
  /// In en, this message translates to:
  /// **'My Consultations'**
  String get myConsultations;

  /// No description provided for @consultationDesc.
  ///
  /// In en, this message translates to:
  /// **'Track your consultations and\nchat with our experts.'**
  String get consultationDesc;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @consultationInfo.
  ///
  /// In en, this message translates to:
  /// **'Open a consultation to start or continue chatting with the expert.'**
  String get consultationInfo;

  /// No description provided for @newRequests.
  ///
  /// In en, this message translates to:
  /// **'New Requests'**
  String get newRequests;

  /// No description provided for @activeConsultations.
  ///
  /// In en, this message translates to:
  /// **'Active Consultations'**
  String get activeConsultations;

  /// No description provided for @completedConsultations.
  ///
  /// In en, this message translates to:
  /// **'Completed Consultations'**
  String get completedConsultations;

  /// No description provided for @reviewRequests.
  ///
  /// In en, this message translates to:
  /// **'Review incoming consultation requests.'**
  String get reviewRequests;

  /// No description provided for @continueConsultations.
  ///
  /// In en, this message translates to:
  /// **'Continue active consultations.'**
  String get continueConsultations;

  /// No description provided for @viewCompletedConsultations.
  ///
  /// In en, this message translates to:
  /// **'View completed consultations.'**
  String get viewCompletedConsultations;

  /// No description provided for @caseNumber.
  ///
  /// In en, this message translates to:
  /// **'Case'**
  String get caseNumber;

  /// No description provided for @crossAnalysisReport.
  ///
  /// In en, this message translates to:
  /// **'Cross Analysis Report'**
  String get crossAnalysisReport;

  /// No description provided for @noQuestionProvided.
  ///
  /// In en, this message translates to:
  /// **'No question provided'**
  String get noQuestionProvided;

  /// No description provided for @expertMyConsultations.
  ///
  /// In en, this message translates to:
  /// **'My Consultations'**
  String get expertMyConsultations;

  /// No description provided for @expertTrackConsultations.
  ///
  /// In en, this message translates to:
  /// **'Track your consultations and chat with our experts.'**
  String get expertTrackConsultations;

  /// No description provided for @openConsultationChat.
  ///
  /// In en, this message translates to:
  /// **'Open a consultation to start or continue chatting with the expert.'**
  String get openConsultationChat;

  /// No description provided for @individualAnalysisOnly.
  ///
  /// In en, this message translates to:
  /// **'Individual Analysis'**
  String get individualAnalysisOnly;

  /// No description provided for @expertHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'New Requests'**
  String get expertHomeTitle;

  /// No description provided for @expertHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review incoming consultation requests.'**
  String get expertHomeSubtitle;

  /// No description provided for @expertActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Consultations'**
  String get expertActiveTitle;

  /// No description provided for @expertActiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Continue active consultations.'**
  String get expertActiveSubtitle;

  /// No description provided for @expertCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Completed Consultations'**
  String get expertCompletedTitle;

  /// No description provided for @expertCompletedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View completed consultations.'**
  String get expertCompletedSubtitle;

  /// No description provided for @trackConsultations.
  ///
  /// In en, this message translates to:
  /// **'Track your consultations and chat with experts.'**
  String get trackConsultations;

  /// No description provided for @viewReport.
  ///
  /// In en, this message translates to:
  /// **'View Report'**
  String get viewReport;

  /// No description provided for @userQuestion.
  ///
  /// In en, this message translates to:
  /// **'User Question'**
  String get userQuestion;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @acceptRequest.
  ///
  /// In en, this message translates to:
  /// **'Accept Request'**
  String get acceptRequest;

  /// No description provided for @requestDetails.
  ///
  /// In en, this message translates to:
  /// **'Request Details'**
  String get requestDetails;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @noQuestion.
  ///
  /// In en, this message translates to:
  /// **'No Question Provided'**
  String get noQuestion;

  /// No description provided for @missingReport.
  ///
  /// In en, this message translates to:
  /// **'Report data is missing'**
  String get missingReport;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @manageAdminAccount.
  ///
  /// In en, this message translates to:
  /// **'Manage admin account and preferences'**
  String get manageAdminAccount;

  /// No description provided for @administrator.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administrator;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @adminPanelDescription.
  ///
  /// In en, this message translates to:
  /// **'Modrik Admin Panel allows administrators to monitor the platform and manage system operations securely.'**
  String get adminPanelDescription;

  /// No description provided for @adminDashboard.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboard;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @individualAnalyses.
  ///
  /// In en, this message translates to:
  /// **'Individual Analyses'**
  String get individualAnalyses;

  /// No description provided for @allUsers.
  ///
  /// In en, this message translates to:
  /// **'All Users'**
  String get allUsers;

  /// No description provided for @crossAnalyses.
  ///
  /// In en, this message translates to:
  /// **'Cross Analyses'**
  String get crossAnalyses;

  /// No description provided for @analysisOutcomes.
  ///
  /// In en, this message translates to:
  /// **'Analysis Outcomes'**
  String get analysisOutcomes;

  /// No description provided for @successAnalyses.
  ///
  /// In en, this message translates to:
  /// **'Successful Analyses'**
  String get successAnalyses;

  /// No description provided for @failedAnalyses.
  ///
  /// In en, this message translates to:
  /// **'Failed Analyses'**
  String get failedAnalyses;

  /// No description provided for @apiStatus.
  ///
  /// In en, this message translates to:
  /// **'External integration & API Status'**
  String get apiStatus;

  /// No description provided for @opencravatApi.
  ///
  /// In en, this message translates to:
  /// **'OpenCRAVAT API'**
  String get opencravatApi;

  /// No description provided for @panelappApi.
  ///
  /// In en, this message translates to:
  /// **'PanelApp API'**
  String get panelappApi;

  /// No description provided for @geminiApi.
  ///
  /// In en, this message translates to:
  /// **'Gemini API'**
  String get geminiApi;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @stable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get stable;

  /// No description provided for @unstable.
  ///
  /// In en, this message translates to:
  /// **'Unstable'**
  String get unstable;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get waiting;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @analyzingDna.
  ///
  /// In en, this message translates to:
  /// **'Analyzing your DNA...'**
  String get analyzingDna;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait a moment'**
  String get pleaseWait;

  /// No description provided for @supportedFormatVc.
  ///
  /// In en, this message translates to:
  /// **'Supported format: .vcf'**
  String get supportedFormatVc;

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose File'**
  String get chooseFile;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @caseText.
  ///
  /// In en, this message translates to:
  /// **'Case'**
  String get caseText;

  /// No description provided for @myQuestion.
  ///
  /// In en, this message translates to:
  /// **'My Question'**
  String get myQuestion;

  /// No description provided for @waitingNote.
  ///
  /// In en, this message translates to:
  /// **'You can accept this request to start chatting with the user.'**
  String get waitingNote;

  /// No description provided for @activeNote.
  ///
  /// In en, this message translates to:
  /// **'This consultation is active. You can chat or mark it as complete.'**
  String get activeNote;

  /// No description provided for @completedNote.
  ///
  /// In en, this message translates to:
  /// **'This consultation has been completed.'**
  String get completedNote;

  /// No description provided for @viewChat.
  ///
  /// In en, this message translates to:
  /// **'View Chat'**
  String get viewChat;

  /// No description provided for @openChat.
  ///
  /// In en, this message translates to:
  /// **'Open Chat'**
  String get openChat;

  /// No description provided for @consultationCompleted.
  ///
  /// In en, this message translates to:
  /// **'Consultation completed'**
  String get consultationCompleted;

  /// No description provided for @consultationFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to complete consultation'**
  String get consultationFailed;

  /// No description provided for @expert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get expert;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// No description provided for @individualtype.
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get individualtype;

  /// No description provided for @crosstype.
  ///
  /// In en, this message translates to:
  /// **'cross'**
  String get crosstype;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @openCravatApi.
  ///
  /// In en, this message translates to:
  /// **'OpenCRAVAT API'**
  String get openCravatApi;

  /// No description provided for @panelAppApi.
  ///
  /// In en, this message translates to:
  /// **'PanelApp API'**
  String get panelAppApi;

  /// No description provided for @consultations.
  ///
  /// In en, this message translates to:
  /// **'Consultations'**
  String get consultations;

  /// No description provided for @consultants.
  ///
  /// In en, this message translates to:
  /// **'Consultants'**
  String get consultants;

  /// No description provided for @doctorName.
  ///
  /// In en, this message translates to:
  /// **'Doctor Name'**
  String get doctorName;

  /// No description provided for @consultantName.
  ///
  /// In en, this message translates to:
  /// **'Consultant Name'**
  String get consultantName;

  /// No description provided for @doctorAhmad.
  ///
  /// In en, this message translates to:
  /// **'Dr. Ahmad'**
  String get doctorAhmad;

  /// No description provided for @gene.
  ///
  /// In en, this message translates to:
  /// **'Gene'**
  String get gene;

  /// No description provided for @disease.
  ///
  /// In en, this message translates to:
  /// **'Disease'**
  String get disease;

  /// No description provided for @inheritance.
  ///
  /// In en, this message translates to:
  /// **'Inheritance'**
  String get inheritance;

  /// No description provided for @clinicalSignificance.
  ///
  /// In en, this message translates to:
  /// **'Clinical Significance'**
  String get clinicalSignificance;

  /// No description provided for @confidenceLevel.
  ///
  /// In en, this message translates to:
  /// **'Confidence Level'**
  String get confidenceLevel;

  /// No description provided for @variantDetails.
  ///
  /// In en, this message translates to:
  /// **'Variant Details'**
  String get variantDetails;

  /// No description provided for @chromosome.
  ///
  /// In en, this message translates to:
  /// **'Chromosome'**
  String get chromosome;

  /// No description provided for @position.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get position;

  /// No description provided for @reference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get reference;

  /// No description provided for @alternative.
  ///
  /// In en, this message translates to:
  /// **'Alternative'**
  String get alternative;

  /// No description provided for @zygosity.
  ///
  /// In en, this message translates to:
  /// **'Zygosity'**
  String get zygosity;

  /// No description provided for @showDetails.
  ///
  /// In en, this message translates to:
  /// **'Show Details'**
  String get showDetails;

  /// No description provided for @hideDetails.
  ///
  /// In en, this message translates to:
  /// **'Hide Details'**
  String get hideDetails;

  /// No description provided for @childRisk.
  ///
  /// In en, this message translates to:
  /// **'Child Risk'**
  String get childRisk;

  /// No description provided for @affected.
  ///
  /// In en, this message translates to:
  /// **'Affected'**
  String get affected;

  /// No description provided for @carrier.
  ///
  /// In en, this message translates to:
  /// **'Carrier'**
  String get carrier;

  /// No description provided for @healthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get healthy;

  /// No description provided for @geneticCondition.
  ///
  /// In en, this message translates to:
  /// **'Genetic Condition'**
  String get geneticCondition;

  /// No description provided for @explain.
  ///
  /// In en, this message translates to:
  /// **'Explain'**
  String get explain;

  /// No description provided for @explainRisk.
  ///
  /// In en, this message translates to:
  /// **'Explain this risk'**
  String get explainRisk;

  /// No description provided for @autosomalDominant.
  ///
  /// In en, this message translates to:
  /// **'Autosomal Dominant'**
  String get autosomalDominant;

  /// No description provided for @autosomalRecessive.
  ///
  /// In en, this message translates to:
  /// **'Autosomal Recessive'**
  String get autosomalRecessive;

  /// No description provided for @xLinkedDominant.
  ///
  /// In en, this message translates to:
  /// **'X-Linked Dominant'**
  String get xLinkedDominant;

  /// No description provided for @xLinkedRecessive.
  ///
  /// In en, this message translates to:
  /// **'X-Linked Recessive'**
  String get xLinkedRecessive;

  /// No description provided for @xLinked.
  ///
  /// In en, this message translates to:
  /// **'X-Linked'**
  String get xLinked;

  /// No description provided for @bothDominantRecessive.
  ///
  /// In en, this message translates to:
  /// **'Both Dominant and Recessive'**
  String get bothDominantRecessive;

  /// No description provided for @pathogenic.
  ///
  /// In en, this message translates to:
  /// **'Pathogenic'**
  String get pathogenic;

  /// No description provided for @likelyPathogenic.
  ///
  /// In en, this message translates to:
  /// **'Likely Pathogenic'**
  String get likelyPathogenic;

  /// No description provided for @benign.
  ///
  /// In en, this message translates to:
  /// **'Benign'**
  String get benign;

  /// No description provided for @uncertainSignificance.
  ///
  /// In en, this message translates to:
  /// **'Uncertain Significance'**
  String get uncertainSignificance;

  /// No description provided for @heterozygous.
  ///
  /// In en, this message translates to:
  /// **'Heterozygous'**
  String get heterozygous;

  /// No description provided for @homozygous.
  ///
  /// In en, this message translates to:
  /// **'Homozygous'**
  String get homozygous;

  /// No description provided for @noneValue.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get noneValue;

  /// No description provided for @dominantRiskExplanation.
  ///
  /// In en, this message translates to:
  /// **'This gene follows Autosomal Dominant inheritance. The child risk is calculated based on the genetic states of both parents.'**
  String get dominantRiskExplanation;

  /// No description provided for @recessiveRiskExplanation.
  ///
  /// In en, this message translates to:
  /// **'This gene follows Autosomal Recessive inheritance. The child risk is calculated based on the genetic states of both parents.'**
  String get recessiveRiskExplanation;

  /// No description provided for @xLinkedDominantRiskExplanation.
  ///
  /// In en, this message translates to:
  /// **'This gene follows X-Linked Dominant inheritance. Male and female children may have different risk percentages.'**
  String get xLinkedDominantRiskExplanation;

  /// No description provided for @xLinkedRecessiveRiskExplanation.
  ///
  /// In en, this message translates to:
  /// **'This gene follows X-Linked Recessive inheritance. Male and female children may have different risk percentages.'**
  String get xLinkedRecessiveRiskExplanation;

  /// No description provided for @bothRiskExplanation.
  ///
  /// In en, this message translates to:
  /// **'This gene may follow both dominant and recessive inheritance patterns. Expert interpretation is recommended.'**
  String get bothRiskExplanation;

  /// No description provided for @consultExpert.
  ///
  /// In en, this message translates to:
  /// **'Consult Expert'**
  String get consultExpert;

  /// No description provided for @askTheExpert.
  ///
  /// In en, this message translates to:
  /// **'Ask the Expert'**
  String get askTheExpert;

  /// No description provided for @writeQuestionHere.
  ///
  /// In en, this message translates to:
  /// **'Write your question here...'**
  String get writeQuestionHere;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @askAiAboutReport.
  ///
  /// In en, this message translates to:
  /// **'Ask AI About Report'**
  String get askAiAboutReport;

  /// No description provided for @consultationDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'I agree to share my genetic report temporarily with the expert for consultation purposes only.The data will be deleted after the consultation ends.'**
  String get consultationDisclaimer;
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
