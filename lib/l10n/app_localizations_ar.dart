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
  String get chatbot => 'اسأل مساعد AI ';

  @override
  String get chatSubtitle => 'مُساعدك الجيني';

  @override
  String get expert => 'خبير';

  @override
  String get expertSubtitle => 'استشر مختصاً';

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
  String get ok => 'حسنًا';

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
  String get savedReport => 'حفظ التقرير ';

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

  @override
  String get myConsultations => 'استشاراتي';

  @override
  String get consultationDesc => 'تابع استشاراتك\nوتحدث مع خبرائنا. ';

  @override
  String get active => 'نشط';

  @override
  String get completed => 'مكتمل';

  @override
  String get consultationInfo => 'افتح الاستشارة لبدء أو متابعة المحادثة مع الخبير. ';

  @override
  String get newRequests => 'الطلبات الجديدة';

  @override
  String get activeConsultations => 'الاستشارات النشطة';

  @override
  String get completedConsultations => 'الاستشارات المكتملة';

  @override
  String get reviewRequests => 'راجع طلبات الاستشارة الجديدة.';

  @override
  String get continueConsultations => 'تابع الاستشارات النشطة.';

  @override
  String get viewCompletedConsultations => 'عرض الاستشارات المكتملة.';

  @override
  String get caseNumber => 'حالة';

  @override
  String get crossAnalysisReport => 'تقرير تحليل مشترك';

  @override
  String get noQuestionProvided => 'لا يوجد سؤال مرفق';

  @override
  String get expertMyConsultations => 'استشاراتي';

  @override
  String get expertTrackConsultations => 'تابع استشاراتك وتحدث مع خبرائنا.';

  @override
  String get openConsultationChat => 'افتح الاستشارة لبدء أو متابعة المحادثة مع الخبير.';

  @override
  String get individualAnalysisOnly => 'تحليل فردي';

  @override
  String get expertHomeTitle => 'طلبات جديدة';

  @override
  String get expertHomeSubtitle => 'راجع طلبات الاستشارات القادمة.';

  @override
  String get expertActiveTitle => 'استشارات نشطة';

  @override
  String get expertActiveSubtitle => 'تابع الاستشارات الحالية.';

  @override
  String get expertCompletedTitle => 'استشارات مكتملة';

  @override
  String get expertCompletedSubtitle => 'عرض الاستشارات المكتملة.';

  @override
  String get trackConsultations => 'تابع استشاراتك وتحدث مع الخبراء.';

  @override
  String get viewReport => 'عرض التقرير';

  @override
  String get userQuestion => 'سؤال المستخدم';

  @override
  String get notes => 'ملاحظات';

  @override
  String get chat => 'محادثة';

  @override
  String get complete => 'إنهاء';

  @override
  String get acceptRequest => 'قبول الطلب';

  @override
  String get requestDetails => 'تفاصيل الطلب';

  @override
  String get report => 'التقرير';

  @override
  String get noQuestion => 'لا يوجد سؤال';

  @override
  String get missingReport => 'بيانات التقرير مفقودة';

  @override
  String get about => 'حول';

  @override
  String get manageAdminAccount => 'إدارة حساب المشرف والتفضيلات';

  @override
  String get administrator => 'المشرف';

  @override
  String get role => 'الدور';

  @override
  String get admin => 'مشرف';

  @override
  String get adminPanelDescription => 'تتيح لوحة تحكم مودرك للمشرفين مراقبة المنصة وإدارة عمليات النظام بأمان.';

  @override
  String get adminDashboard => 'لوحة تحكم المسؤول';

  @override
  String get overview => 'نظرة عامة';

  @override
  String get individualAnalyses => 'التحاليل الفردية';

  @override
  String get allUsers => 'جميع المستخدمين';

  @override
  String get crossAnalyses => 'التحاليل المشتركة';

  @override
  String get analysisOutcomes => 'نتائج التحليل';

  @override
  String get successAnalyses => 'التحاليل الناجحة';

  @override
  String get failedAnalyses => 'التحاليل الفاشلة';

  @override
  String get apiStatus => 'حالة الـ API';

  @override
  String get opencravatApi => 'واجهة OpenCRAVAT';

  @override
  String get panelappApi => 'واجهة PanelApp';

  @override
  String get geminiApi => 'واجهة Gemini';

  @override
  String get total => 'الإجمالي';

  @override
  String get stable => 'مستقر';

  @override
  String get unstable => 'غير مستقر';

  @override
  String get offline => 'متوقف';

  @override
  String get waiting => 'قيد الانتظار';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get analyzingDna => 'جاري تحليل الحمض النووي...';

  @override
  String get pleaseWait => 'يرجى الانتظار لحظة';

  @override
  String get supportedFormatVc => 'الصيغة المدعومة: .vcf';

  @override
  String get chooseFile => 'اختيار ملف';

  @override
  String get details => 'التفاصيل';

  @override
  String get caseText => 'حالة';

  @override
  String get myQuestion => 'سؤالي';

  @override
  String get waitingNote => 'يمكنك قبول هذا الطلب لبدء المحادثة مع المستخدم.';

  @override
  String get activeNote => 'الاستشارة نشطة. يمكنك المحادثة مع المستخدم أو إنهائها عند الانتهاء.';

  @override
  String get completedNote => 'تم إنهاء هذه الاستشارة.';

  @override
  String get viewChat => 'عرض المحادثة';

  @override
  String get openChat => 'فتح المحادثة';

  @override
  String get consultationCompleted => 'تم إنهاء الاستشارة';

  @override
  String get consultationFailed => 'فشل إنهاء الاستشارة';

  @override
  String get typeMessage => 'اكتب رسالة...';

  @override
  String get individual => 'فردي';

  @override
  String get cross => 'مشترك';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get openCravatApi => 'واجهة OpenCRAVAT';

  @override
  String get panelAppApi => 'واجهة PanelApp';

  @override
  String get consultations => 'الاستشارات';

  @override
  String get consultants => 'المستشارون';

  @override
  String get doctorName => 'اسم الدكتور';

  @override
  String get consultantName => 'اسم المستشار';

  @override
  String get doctorAhmad => 'د. أحمد';

  @override
  String get gene => 'الجين';

  @override
  String get disease => 'المرض';

  @override
  String get inheritance => 'نمط التوارث';

  @override
  String get clinicalSignificance => 'الأهمية السريرية';

  @override
  String get confidenceLevel => 'مستوى الثقة';

  @override
  String get variantDetails => 'تفاصيل الطفرة';

  @override
  String get chromosome => 'الكروموسوم';

  @override
  String get position => 'الموقع';

  @override
  String get reference => 'المرجع';

  @override
  String get alternative => 'البديل';

  @override
  String get zygosity => 'الزيجوتية';

  @override
  String get showDetails => 'عرض التفاصيل';

  @override
  String get hideDetails => 'إخفاء التفاصيل';

  @override
  String get childRisk => 'احتمالية إصابة الطفل';

  @override
  String get affected => 'مصاب';

  @override
  String get carrier => 'حامل';

  @override
  String get healthy => 'سليم';

  @override
  String get geneticCondition => 'الحالة الجينية';

  @override
  String get explain => 'شرح';

  @override
  String get explainRisk => 'شرح هذا الخطر';

  @override
  String get autosomalDominant => 'وراثة جسمية سائدة';

  @override
  String get autosomalRecessive => 'وراثة جسمية متنحية';

  @override
  String get xLinkedDominant => 'وراثة سائدة مرتبطة بالكروموسوم X';

  @override
  String get xLinkedRecessive => 'وراثة متنحية مرتبطة بالكروموسوم X';

  @override
  String get xLinked => 'وراثة مرتبطة بالكروموسوم X';

  @override
  String get bothDominantRecessive => 'سائدة ومتنحية معًا';

  @override
  String get pathogenic => 'مُمرض';

  @override
  String get likelyPathogenic => 'غالبًا مُمرض';

  @override
  String get benign => 'حميد';

  @override
  String get uncertainSignificance => 'دلالة غير مؤكدة';

  @override
  String get heterozygous => 'متغاير الزيجوت';

  @override
  String get homozygous => 'متماثل الزيجوت';

  @override
  String get noneValue => 'غير موجود';

  @override
  String get dominantRiskExplanation => 'هذا الجين يتبع نمط الوراثة الجسمية السائدة. تم حساب احتمالية إصابة الطفل اعتمادًا على الحالة الجينية للأب والأم.';

  @override
  String get recessiveRiskExplanation => 'هذا الجين يتبع نمط الوراثة الجسمية المتنحية. تم حساب احتمالية إصابة الطفل اعتمادًا على الحالة الجينية للأب والأم.';

  @override
  String get xLinkedDominantRiskExplanation => 'هذا الجين يتبع نمط الوراثة السائدة المرتبطة بالكروموسوم X. قد تختلف احتمالية الإصابة بين الذكور والإناث.';

  @override
  String get xLinkedRecessiveRiskExplanation => 'هذا الجين يتبع نمط الوراثة المتنحية المرتبطة بالكروموسوم X. قد تختلف احتمالية الإصابة بين الذكور والإناث.';

  @override
  String get bothRiskExplanation => 'قد يتبع هذا الجين أكثر من نمط وراثي. لذلك يُنصح بمراجعة مختص وراثي لتفسير النتيجة بدقة.';

  @override
  String get consultExpert => 'استشر خبير';

  @override
  String get askTheExpert => 'اسأل الخبير';

  @override
  String get writeQuestionHere => 'اكتب سؤالك هنا...';

  @override
  String get send => 'إرسال';

  @override
  String get cancel => 'إلغاء';

  @override
  String get askAiAboutReport => 'اسأل الذكاء عن التقرير';

  @override
  String get consultationDisclaimer => 'أوافق على مشاركة تقريري الجيني مؤقتًا مع الخبير لغرض الاستشارة فقط، وسيتم حذف البيانات بعد انتهاء الاستشارة.';
}
