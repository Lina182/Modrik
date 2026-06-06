// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get account => 'Account';

  @override
  String get manageAccount => 'Manage your account and preferences';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get general => 'General';

  @override
  String get language => 'Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyText => 'Your genetic data is processed only for analysis and is not stored on our servers.\nWe do not share your data with any third parties.\nAll analysis is handled securely and privately.';

  @override
  String get support => 'Support';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get contactText => 'Email: supportmodrik@gmail.com\nWe are here to help you anytime.';

  @override
  String get aboutApp => 'About App';

  @override
  String get aboutText => 'Modrik helps you understand your genetic data in a simple and clear way.\nWe analyze your DNA file and provide easy-to-read insights using AI.\nYour data remains private and is not stored after analysis.';

  @override
  String get logout => 'Log out';

  @override
  String get noUsername => 'No Username';

  @override
  String get noEmail => 'No Email';

  @override
  String get welcomeTo => 'Welcome to';

  @override
  String get appName => 'Modrik';

  @override
  String get understandDNA => 'Understand your DNA better';

  @override
  String get analyzeDNA => 'Analyze Your DNA';

  @override
  String get uploadVCF => 'Upload your VCF file and get clear insights.';

  @override
  String get startAnalysis => 'Start Analysis';

  @override
  String get exploreMore => 'Explore more';

  @override
  String get chooseChatType => 'Choose chat type';

  @override
  String get askAboutReport => 'Ask about a report';

  @override
  String get selectSavedReports => 'Select from saved reports';

  @override
  String get generalGeneticQuestion => 'General genetic question';

  @override
  String get askAnythingGenetics => 'Ask anything about genetics';

  @override
  String get chatbot => 'Genetic Assistant';

  @override
  String get chatSubtitle => 'Ask AI about your genetics';

  @override
  String get expertinhome => 'Consult Expert';

  @override
  String get expertSubtitle => 'Consult with our experts';

  @override
  String get yourDataPrivate => 'Your data is private';

  @override
  String get yourDataPrivateText => 'Your data is processed only for analysis and not stored.';

  @override
  String get selectAnalysisType => 'Select how you want to analyze your genetic data.';

  @override
  String get individualAnalysis => 'Individual Analysis';

  @override
  String get individualAnalysisText => 'Analyze one VCF file for a single individual.';

  @override
  String get crossAnalysis => 'Cross Analysis';

  @override
  String get crossAnalysisText => 'Analyze two VCF files to compare shared or inherited variants.';

  @override
  String get crossUpload => 'Cross Upload';

  @override
  String get crossUploadDesc => 'Upload two VCF files to compare shared or inherited variants.';

  @override
  String get selectFiles => 'Select your VCF files';

  @override
  String get selectSingleFile => 'Select VCF file';

  @override
  String get noFileSelected => 'No file selected';

  @override
  String get uploadFailed => 'Upload failed';

  @override
  String get chooseFatherFile => 'Choose Father File';

  @override
  String get chooseMotherFile => 'Choose Mother File';

  @override
  String get continueBtn => 'Continue';

  @override
  String get error => 'Error';

  @override
  String get ok => 'OK';

  @override
  String get failedToAnalyze => 'Failed to analyze files';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get noSavedReports => 'No saved reports yet';

  @override
  String get savedReportsDesc => 'Your analyzed reports will appear here.';

  @override
  String get savedReports => 'Saved Reports';

  @override
  String get savedReport => 'Save Report';

  @override
  String genesCount(Object count) {
    return '$count genes';
  }

  @override
  String conditionsCount(Object count) {
    return '$count conditions';
  }

  @override
  String get notAvailable => 'Not available';

  @override
  String get unknown => 'Unknown';

  @override
  String get noExplanation => 'No explanation available';

  @override
  String get chatTitleReport => 'Report Chat';

  @override
  String get chatTitleGeneral => 'General Chat';

  @override
  String get reportModeBanner => 'You are asking about a report';

  @override
  String get messageHint => 'Type your message...';

  @override
  String get typing => 'Typing...';

  @override
  String get welcomeBot => 'Hi! I\'m Modrik 👋\nI\'m here to help you understand genetics in a simple and friendly way. Just tell me what you want to know.';

  @override
  String get reportReceived => 'I have received your report. You can now ask about it.';

  @override
  String get serverError => 'Server error';

  @override
  String get connectionError => 'Connection error';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterName => 'Enter your name';

  @override
  String get enterEmail => 'Please enter your email';

  @override
  String get newPassword => 'New Password';

  @override
  String get leaveEmpty => 'Leave empty if you don\'t want to change it';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get requiredPassword => 'Required to change password';

  @override
  String get securityNotice => 'For your security, please enter your current password to save any changes.';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get profileUpdated => 'Profile updated successfully ✅';

  @override
  String get noChanges => 'No changes detected';

  @override
  String get wrongPassword => 'Wrong password';

  @override
  String get errorUpdate => 'Error updating profile';

  @override
  String get confirmEmail => 'Check your new email to confirm 📩';

  @override
  String get enterCurrentPassword => 'Enter current password to change email or password';

  @override
  String get deletePassword => 'Enter current password to delete account';

  @override
  String get email => 'Email';

  @override
  String get login => 'Login';

  @override
  String get welcomeBack => 'Welcome back you\'ve\nbeen missed!';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get logIn => 'Log in';

  @override
  String get dontHaveAccount => 'Don’t have an account ? Sign Up';

  @override
  String get pleaseFillFields => 'Please fill all fields';

  @override
  String get userNull => 'User is null';

  @override
  String get tokenVerificationFailed => 'Token verification failed';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get noUserFound => 'No user found with this email';

  @override
  String get invalidEmail => 'Invalid email format';

  @override
  String get unexpectedError => 'Unexpected error occurred';

  @override
  String get noAccount => 'Don’t have an account ? Sign Up';

  @override
  String get fillAllFields => 'Please fill all fields';

  @override
  String get createAccount => 'Create Account';

  @override
  String get createAccountSubtitle => 'Create your account\nand get started!';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get signUp => 'Sign Up';

  @override
  String get alreadyHaveAccount => 'Already have an account? Log in';

  @override
  String get weakPassword => 'Password must be at least 6 characters';

  @override
  String get passwordsDontMatch => 'Passwords don\'t match';

  @override
  String get accountCreated => 'Account created successfully';

  @override
  String get userCreationFailed => 'User creation failed';

  @override
  String get emailInUse => 'Email already in use. Try logging in.';

  @override
  String get forgotPasswordDesc => 'Enter your email and we will send you a reset link.';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetLinkSent => 'Reset link sent to your email';

  @override
  String get noAccountFound => 'No account found with this email';

  @override
  String get myConsultations => 'My Consultations';

  @override
  String get consultationDesc => 'Track your consultations and\nchat with our experts.';

  @override
  String get active => 'Active';

  @override
  String get completed => 'Completed';

  @override
  String get consultationInfo => 'Open a consultation to start or continue chatting with the expert.';

  @override
  String get newRequests => 'New Requests';

  @override
  String get activeConsultations => 'Active Consultations';

  @override
  String get completedConsultations => 'Completed Consultations';

  @override
  String get reviewRequests => 'Review incoming consultation requests.';

  @override
  String get continueConsultations => 'Continue active consultations.';

  @override
  String get viewCompletedConsultations => 'View completed consultations.';

  @override
  String get caseNumber => 'Case';

  @override
  String get crossAnalysisReport => 'Cross Analysis Report';

  @override
  String get noQuestionProvided => 'No question provided';

  @override
  String get expertMyConsultations => 'My Consultations';

  @override
  String get expertTrackConsultations => 'Track your consultations and chat with our experts.';

  @override
  String get openConsultationChat => 'Open a consultation to start or continue chatting with the expert.';

  @override
  String get individualAnalysisOnly => 'Individual Analysis';

  @override
  String get expertHomeTitle => 'New Requests';

  @override
  String get expertHomeSubtitle => 'Review incoming consultation requests.';

  @override
  String get expertActiveTitle => 'Active Consultations';

  @override
  String get expertActiveSubtitle => 'Continue active consultations.';

  @override
  String get expertCompletedTitle => 'Completed Consultations';

  @override
  String get expertCompletedSubtitle => 'View completed consultations.';

  @override
  String get trackConsultations => 'Track your consultations and chat with experts.';

  @override
  String get viewReport => 'View Report';

  @override
  String get userQuestion => 'User Question';

  @override
  String get notes => 'Notes';

  @override
  String get chat => 'Chat';

  @override
  String get complete => 'Complete';

  @override
  String get acceptRequest => 'Accept Request';

  @override
  String get requestDetails => 'Request Details';

  @override
  String get report => 'Report';

  @override
  String get noQuestion => 'No Question Provided';

  @override
  String get missingReport => 'Report data is missing';

  @override
  String get about => 'About';

  @override
  String get manageAdminAccount => 'Manage admin account and preferences';

  @override
  String get administrator => 'Administrator';

  @override
  String get role => 'Role';

  @override
  String get admin => 'Admin';

  @override
  String get adminPanelDescription => 'Modrik Admin Panel allows administrators to monitor the platform and manage system operations securely.';

  @override
  String get adminDashboard => 'Admin Dashboard';

  @override
  String get overview => 'Overview';

  @override
  String get individualAnalyses => 'Individual Analyses';

  @override
  String get allUsers => 'All Users';

  @override
  String get crossAnalyses => 'Cross Analyses';

  @override
  String get analysisOutcomes => 'Analysis Outcomes';

  @override
  String get successAnalyses => 'Successful Analyses';

  @override
  String get failedAnalyses => 'Failed Analyses';

  @override
  String get apiStatus => 'API Status';

  @override
  String get opencravatApi => 'OpenCRAVAT API';

  @override
  String get panelappApi => 'PanelApp API';

  @override
  String get geminiApi => 'Gemini API';

  @override
  String get total => 'Total';

  @override
  String get stable => 'Stable';

  @override
  String get unstable => 'Unstable';

  @override
  String get offline => 'Offline';

  @override
  String get waiting => 'Waiting';

  @override
  String get profile => 'Profile';

  @override
  String get analyzingDna => 'Analyzing your DNA...';

  @override
  String get pleaseWait => 'Please wait a moment';

  @override
  String get supportedFormatVc => 'Supported format: .vcf';

  @override
  String get chooseFile => 'Choose File';

  @override
  String get details => 'Details';

  @override
  String get caseText => 'Case';

  @override
  String get myQuestion => 'My Question';

  @override
  String get waitingNote => 'You can accept this request to start chatting with the user.';

  @override
  String get activeNote => 'This consultation is active. You can chat or mark it as complete.';

  @override
  String get completedNote => 'This consultation has been completed.';

  @override
  String get viewChat => 'View Chat';

  @override
  String get openChat => 'Open Chat';

  @override
  String get consultationCompleted => 'Consultation completed';

  @override
  String get consultationFailed => 'Failed to complete consultation';

  @override
  String get expert => 'Expert';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get individualtype => 'Individual';

  @override
  String get crosstype => 'cross';

  @override
  String get apiStatusdash => 'External integration & API Status';

  @override
  String get loading => 'Loading...';

  @override
  String get openCravatApi => 'OpenCRAVAT API';

  @override
  String get panelAppApi => 'PanelApp API';

  @override
  String get consultations => 'Completed Consultations';

  @override
  String get doctorName => 'Doctor Name';

  @override
  String get consultantName => 'Consultant Name';

  @override
  String get consultants => 'Genetic Experts Performance';

  @override
  String get gene => 'Gene';

  @override
  String get disease => 'Disease';

  @override
  String get inheritance => 'Inheritance';

  @override
  String get clinicalSignificance => 'Clinical Significance';

  @override
  String get confidenceLevel => 'Confidence Level';

  @override
  String get variantDetails => 'Variant Details';

  @override
  String get chromosome => 'Chromosome';

  @override
  String get position => 'Position';

  @override
  String get reference => 'Reference';

  @override
  String get alternative => 'Alternative';

  @override
  String get zygosity => 'Zygosity';

  @override
  String get showDetails => 'Show Details';

  @override
  String get hideDetails => 'Hide Details';

  @override
  String get childRisk => 'Child Risk';

  @override
  String get affected => 'Affected';

  @override
  String get carrier => 'Carrier';

  @override
  String get healthy => 'Healthy';

  @override
  String get geneticCondition => 'Genetic Condition';

  @override
  String get explain => 'Explain';

  @override
  String get explainRisk => 'Explain this risk';

  @override
  String get autosomalDominant => 'Autosomal Dominant';

  @override
  String get autosomalRecessive => 'Autosomal Recessive';

  @override
  String get xLinkedDominant => 'X-Linked Dominant';

  @override
  String get xLinkedRecessive => 'X-Linked Recessive';

  @override
  String get xLinked => 'X-Linked';

  @override
  String get bothDominantRecessive => 'Both Dominant and Recessive';

  @override
  String get pathogenic => 'Pathogenic';

  @override
  String get likelyPathogenic => 'Likely Pathogenic';

  @override
  String get benign => 'Benign';

  @override
  String get uncertainSignificance => 'Uncertain Significance';

  @override
  String get heterozygous => 'Heterozygous';

  @override
  String get homozygous => 'Homozygous';

  @override
  String get noneValue => 'None';

  @override
  String get dominantRiskExplanation => 'This gene follows Autosomal Dominant inheritance. The child risk is calculated based on the genetic states of both parents.';

  @override
  String get recessiveRiskExplanation => 'This gene follows Autosomal Recessive inheritance. The child risk is calculated based on the genetic states of both parents.';

  @override
  String get xLinkedDominantRiskExplanation => 'This gene follows X-Linked Dominant inheritance. Male and female children may have different risk percentages.';

  @override
  String get xLinkedRecessiveRiskExplanation => 'This gene follows X-Linked Recessive inheritance. Male and female children may have different risk percentages.';

  @override
  String get bothRiskExplanation => 'This gene may follow both dominant and recessive inheritance patterns. Expert interpretation is recommended.';

  @override
  String get consultExpert => 'Consult Expert';

  @override
  String get askTheExpert => 'Ask the Expert';

  @override
  String get writeQuestionHere => 'Write your question here...';

  @override
  String get send => 'Send';

  @override
  String get cancel => 'Cancel';

  @override
  String get askAiAboutReport => 'Ask AI About Report';

  @override
  String get consultationDisclaimer => 'I agree to share my genetic report temporarily with the expert for consultation purposes only.The data will be deleted after the consultation ends.';
}
