// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get account => 'الحساب';

  @override
  String get manageAccount => 'إدارة حسابك وتفضيلاتك';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get general => 'عام';

  @override
  String get language => 'اللغة';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get privacyText => 'يتم معالجة بياناتك الجينية فقط للتحليل ولا يتم تخزينها على خوادمنا.\nلا نقوم بمشاركة بياناتك مع أي طرف ثالث.\nجميع التحليلات تتم بشكل آمن وسري.';

  @override
  String get support => 'الدعم';

  @override
  String get contactUs => 'تواصل معنا';

  @override
  String get contactText => 'البريد: supportmodrik@gmail.com\nنحن هنا لمساعدتك في أي وقت.';

  @override
  String get aboutApp => 'عن التطبيق';

  @override
  String get aboutText => 'Modrik يساعدك على فهم بياناتك الجينية بطريقة بسيطة وواضحة.\nنقوم بتحليل ملف DNA الخاص بك وتقديم نتائج سهلة الفهم باستخدام الذكاء الاصطناعي.\nبياناتك تبقى خاصة ولا يتم تخزينها بعد التحليل.';

  @override
  String get logout => 'تسجيل خروج';

  @override
  String get noUsername => 'لا يوجد اسم';

  @override
  String get noEmail => 'لا يوجد بريد';

  @override
  String get welcomeTo => 'مرحبًا بك في';

  @override
  String get appName => 'مدرك';

  @override
  String get understandDNA => 'افهم حمضك النووي بشكل أفضل';

  @override
  String get analyzeDNA => 'تحليل الحمض النووي';

  @override
  String get uploadVCF => 'ارفع ملف VCF واحصل على نتائج واضحة.';

  @override
  String get startAnalysis => 'ابدأ التحليل';

  @override
  String get exploreMore => 'استكشف المزيد';

  @override
  String get chooseChatType => 'اختر نوع المحادثة';

  @override
  String get askAboutReport => 'اسأل عن تقرير';

  @override
  String get selectSavedReports => 'اختر من التقارير المحفوظة';

  @override
  String get generalGeneticQuestion => 'سؤال جيني عام';

  @override
  String get askAnythingGenetics => 'اسأل أي شيء عن الجينات';

  @override
  String get chat => 'الدردشة';

  @override
  String get chatSubtitle => 'اسأل الذكاء الاصطناعي عن جيناتك';

  @override
  String get expert => 'تواصل مع الخبير';

  @override
  String get expertSubtitle => 'استشر خبراءنا';

  @override
  String get yourDataPrivate => 'بياناتك خاصة';

  @override
  String get yourDataPrivateText => 'تتم معالجة بياناتك للتحليل فقط ولا يتم حفظها.';

  @override
  String get selectAnalysisType => 'اختر طريقة تحليل بياناتك الجينية';

  @override
  String get individualAnalysis => 'تحليل فردي';

  @override
  String get individualAnalysisText => 'قم بتحليل ملف VCF لشخص واحد.';

  @override
  String get crossAnalysis => 'تحليل مشترك';

  @override
  String get crossAnalysisText => 'قم بتحليل ملفين VCF لمقارنة المتغيرات المشتركة أو الوراثية.';

  @override
  String get crossUpload => 'الرفع المشترك';

  @override
  String get crossUploadDesc => 'ارفع ملفين VCF لمقارنة المتغيرات المشتركة أو الوراثية.';

  @override
  String get selectFiles => 'اختر ملفات VCF';

  @override
  String get selectSingleFile => 'اختر ملف VCF';

  @override
  String get noFileSelected => 'لم يتم اختيار ملف';

  @override
  String get uploadFailed => 'فشل الرفع';

  @override
  String get chooseFatherFile => 'اختر ملف الأب';

  @override
  String get chooseMotherFile => 'اختر ملف الأم';

  @override
  String get continueBtn => 'متابعة';

  @override
  String get error => 'خطأ';

  @override
  String get ok => 'حسناً';

  @override
  String get failedToAnalyze => 'فشل في تحليل الملفات';

  @override
  String get somethingWentWrong => 'حدث خطأ غير متوقع';

  @override
  String get noSavedReports => 'لا توجد تقارير محفوظة بعد';

  @override
  String get savedReportsDesc => 'ستظهر التقارير التي تم تحليلها هنا.';

  @override
  String get savedReports => 'التقارير المحفوظة';

  @override
  String get savedReport => 'تقرير محفوظ';

  @override
  String genesCount(Object count) {
    return '$count جينات';
  }

  @override
  String conditionsCount(Object count) {
    return '$count حالات';
  }

  @override
  String get notAvailable => 'غير متوفر';

  @override
  String get unknown => 'غير معروف';

  @override
  String get noExplanation => 'لا يوجد شرح متوفر';

  @override
  String get chatTitleReport => 'محادثة التقرير';

  @override
  String get chatTitleGeneral => 'المحادثة العامة';

  @override
  String get reportModeBanner => 'أنت تسأل عن تقرير';

  @override
  String get messageHint => 'اكتب رسالتك...';

  @override
  String get typing => 'جاري الكتابة...';

  @override
  String get welcomeBot => 'مرحبًا! أنا مودرك 👋\nاسألني عن تقريرك أو أي شيء في الجينات.';

  @override
  String get reportReceived => 'تم استلام التقرير، يمكنك البدء بالسؤال.';

  @override
  String get serverError => 'خطأ في السيرفر';

  @override
  String get connectionError => 'خطأ في الاتصال';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get enterName => 'أدخل اسمك';

  @override
  String get enterEmail => 'الرجاء إدخال البريد الإلكتروني';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get leaveEmpty => 'اتركه فارغًا إذا لم ترد التغيير';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get requiredPassword => 'مطلوبة لتغيير البريد أو كلمة المرور';

  @override
  String get securityNotice => 'لأمان حسابك، يرجى إدخال كلمة المرور الحالية لحفظ أي تغييرات.';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي بنجاح ✅';

  @override
  String get noChanges => 'لا توجد تغييرات';

  @override
  String get wrongPassword => 'كلمة المرور خاطئة';

  @override
  String get errorUpdate => 'حدث خطأ أثناء تحديث الملف الشخصي';

  @override
  String get confirmEmail => 'تحقق من بريدك الإلكتروني الجديد للتأكيد 📩';

  @override
  String get enterCurrentPassword => 'أدخل كلمة المرور الحالية لتغيير البريد أو كلمة المرور';

  @override
  String get deletePassword => 'أدخل كلمة المرور الحالية لحذف الحساب';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get welcomeBack => 'مرحبًا بعودتك\nلقد افتقدناك!';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور';

  @override
  String get logIn => 'دخول';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ إنشاء حساب';

  @override
  String get pleaseFillFields => 'يرجى تعبئة جميع الحقول';

  @override
  String get userNull => 'المستخدم غير موجود';

  @override
  String get tokenVerificationFailed => 'فشل التحقق من التوكن';

  @override
  String get loginFailed => 'فشل تسجيل الدخول';

  @override
  String get noUserFound => 'لا يوجد مستخدم بهذا البريد';

  @override
  String get invalidEmail => 'صيغة البريد الإلكتروني غير صحيحة';

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع';

  @override
  String get noAccount => 'ليس لديك حساب؟ إنشاء حساب';

  @override
  String get fillAllFields => 'يرجى تعبئة جميع الحقول';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get createAccountSubtitle => 'أنشئ حسابك\nوابدأ الآن!';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get signUp => 'تسجيل';

  @override
  String get alreadyHaveAccount => 'لديك حساب؟ تسجيل الدخول';

  @override
  String get weakPassword => 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';

  @override
  String get passwordsDontMatch => 'كلمات المرور غير متطابقة';

  @override
  String get accountCreated => 'تم إنشاء الحساب بنجاح';

  @override
  String get userCreationFailed => 'فشل إنشاء الحساب';

  @override
  String get emailInUse => 'البريد مستخدم مسبقًا';

  @override
  String get forgotPasswordDesc => 'أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة التعيين';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get resetLinkSent => 'تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني';

  @override
  String get noAccountFound => 'لا يوجد حساب بهذا البريد الإلكتروني';
}
