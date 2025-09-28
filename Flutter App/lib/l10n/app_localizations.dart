import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('pa'),
    Locale('ta'),
    Locale('te'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Krishi Sakhi'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @voice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voice;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @telugu.
  ///
  /// In en, this message translates to:
  /// **'తెలుగు'**
  String get telugu;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'हिंदी'**
  String get hindi;

  /// No description provided for @bengali.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get bengali;

  /// No description provided for @malayalam.
  ///
  /// In en, this message translates to:
  /// **'മലയാളം'**
  String get malayalam;

  /// No description provided for @kannada.
  ///
  /// In en, this message translates to:
  /// **'ಕನ್ನಡ'**
  String get kannada;

  /// No description provided for @tamil.
  ///
  /// In en, this message translates to:
  /// **'தமிழ்'**
  String get tamil;

  /// No description provided for @punjabi.
  ///
  /// In en, this message translates to:
  /// **'ਪੰਜਾਬੀ'**
  String get punjabi;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Krishi Sakhi'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'Your agricultural companion for farming solutions'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Voice Recognition'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Speak in your preferred language to get instant help'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Chat Support'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'Get expert advice through our intelligent chat system'**
  String get onboardingSubtitle3;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @setupProfile.
  ///
  /// In en, this message translates to:
  /// **'Setup Profile'**
  String get setupProfile;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter mobile number'**
  String get enterMobileNumber;

  /// No description provided for @invalidMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid mobile number'**
  String get invalidMobileNumber;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @progressOf.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get progressOf;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @setupCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Setup Complete!'**
  String get setupCompleteTitle;

  /// No description provided for @profileCreatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your profile has been created successfully.'**
  String get profileCreatedMessage;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @saveFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile. Please try again.'**
  String get saveFailedMessage;

  /// No description provided for @questionName.
  ///
  /// In en, this message translates to:
  /// **'What is your name?'**
  String get questionName;

  /// No description provided for @questionLocality.
  ///
  /// In en, this message translates to:
  /// **'What is your locality?'**
  String get questionLocality;

  /// No description provided for @questionLandArea.
  ///
  /// In en, this message translates to:
  /// **'What is your land area?'**
  String get questionLandArea;

  /// No description provided for @questionTypesOfCrops.
  ///
  /// In en, this message translates to:
  /// **'What types of crops do you grow?'**
  String get questionTypesOfCrops;

  /// No description provided for @questionFertilizersAndChemicals.
  ///
  /// In en, this message translates to:
  /// **'What fertilizers and chemicals do you use?'**
  String get questionFertilizersAndChemicals;

  /// No description provided for @questionSourceOfIrrigation.
  ///
  /// In en, this message translates to:
  /// **'What is your source of irrigation?'**
  String get questionSourceOfIrrigation;

  /// No description provided for @questionNumberOfCrops.
  ///
  /// In en, this message translates to:
  /// **'How many crops do you grow per year?'**
  String get questionNumberOfCrops;

  /// No description provided for @questionEmail.
  ///
  /// In en, this message translates to:
  /// **'What is your email address?'**
  String get questionEmail;

  /// No description provided for @questionPhone.
  ///
  /// In en, this message translates to:
  /// **'What is your phone number?'**
  String get questionPhone;

  /// No description provided for @questionPreference.
  ///
  /// In en, this message translates to:
  /// **'What is your preference?'**
  String get questionPreference;

  /// No description provided for @questionLanguage.
  ///
  /// In en, this message translates to:
  /// **'What is your preferred language?'**
  String get questionLanguage;

  /// No description provided for @optionText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get optionText;

  /// No description provided for @optionVoice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get optionVoice;

  /// No description provided for @optionEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get optionEnglish;

  /// No description provided for @optionMalayalam.
  ///
  /// In en, this message translates to:
  /// **'Malayalam'**
  String get optionMalayalam;

  /// No description provided for @placeholderName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get placeholderName;

  /// No description provided for @placeholderLocality.
  ///
  /// In en, this message translates to:
  /// **'Enter your locality'**
  String get placeholderLocality;

  /// No description provided for @placeholderLandArea.
  ///
  /// In en, this message translates to:
  /// **'Enter land area (in acres)'**
  String get placeholderLandArea;

  /// No description provided for @placeholderTypesOfCrops.
  ///
  /// In en, this message translates to:
  /// **'Enter types of crops'**
  String get placeholderTypesOfCrops;

  /// No description provided for @placeholderFertilizersAndChemicals.
  ///
  /// In en, this message translates to:
  /// **'Enter fertilizers and chemicals used'**
  String get placeholderFertilizersAndChemicals;

  /// No description provided for @placeholderSourceOfIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Enter source of irrigation'**
  String get placeholderSourceOfIrrigation;

  /// No description provided for @placeholderNumberOfCrops.
  ///
  /// In en, this message translates to:
  /// **'Enter number of crops per year'**
  String get placeholderNumberOfCrops;

  /// No description provided for @placeholderEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get placeholderEmail;

  /// No description provided for @placeholderPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get placeholderPhone;

  /// No description provided for @voiceStartListening.
  ///
  /// In en, this message translates to:
  /// **'Start Listening'**
  String get voiceStartListening;

  /// No description provided for @voiceStopListening.
  ///
  /// In en, this message translates to:
  /// **'Stop Listening'**
  String get voiceStopListening;

  /// No description provided for @voiceListening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get voiceListening;

  /// No description provided for @voiceNoSpeechDetected.
  ///
  /// In en, this message translates to:
  /// **'No speech detected'**
  String get voiceNoSpeechDetected;

  /// No description provided for @voiceConfidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence: {confidence}%'**
  String voiceConfidence(int confidence);

  /// No description provided for @voiceSpeakToBegin.
  ///
  /// In en, this message translates to:
  /// **'Tap the microphone to speak'**
  String get voiceSpeakToBegin;

  /// No description provided for @voiceTranscription.
  ///
  /// In en, this message translates to:
  /// **'Transcription'**
  String get voiceTranscription;

  /// No description provided for @voiceClearTranscription.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get voiceClearTranscription;

  /// No description provided for @voicePlayTranscription.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get voicePlayTranscription;

  /// No description provided for @chatTypeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get chatTypeMessage;

  /// No description provided for @chatSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get chatSend;

  /// No description provided for @chatLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get chatLoading;

  /// No description provided for @chatError.
  ///
  /// In en, this message translates to:
  /// **'Error sending message'**
  String get chatError;

  /// No description provided for @chatRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get chatRetry;

  /// No description provided for @chatNoMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get chatNoMessages;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingsTermsOfService;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get commonError;

  /// No description provided for @commonSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get commonSuccess;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @errorNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get errorNetworkError;

  /// No description provided for @errorPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get errorPermissionDenied;

  /// No description provided for @errorMicrophoneNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Microphone not available'**
  String get errorMicrophoneNotAvailable;

  /// No description provided for @errorSpeechRecognitionNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition not available'**
  String get errorSpeechRecognitionNotAvailable;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get errorInvalidCredentials;

  /// No description provided for @errorUnknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get errorUnknownError;

  /// No description provided for @communicationPreference.
  ///
  /// In en, this message translates to:
  /// **'Communication Preference'**
  String get communicationPreference;

  /// No description provided for @textChat.
  ///
  /// In en, this message translates to:
  /// **'Text Chat'**
  String get textChat;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessful;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get loginFailed;

  /// No description provided for @termsAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our terms and privacy policy'**
  String get termsAndPrivacy;

  /// No description provided for @pleaseFillField.
  ///
  /// In en, this message translates to:
  /// **'Please fill this field.'**
  String get pleaseFillField;

  /// No description provided for @setupComplete.
  ///
  /// In en, this message translates to:
  /// **'Setup complete!'**
  String get setupComplete;

  /// No description provided for @yourSmartFarmingAssistant.
  ///
  /// In en, this message translates to:
  /// **'Your Smart Farming Assistant'**
  String get yourSmartFarmingAssistant;

  /// No description provided for @mainFeatures.
  ///
  /// In en, this message translates to:
  /// **'Main Features'**
  String get mainFeatures;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @voiceAssistant.
  ///
  /// In en, this message translates to:
  /// **'Voice Assistant'**
  String get voiceAssistant;

  /// No description provided for @chatSupport.
  ///
  /// In en, this message translates to:
  /// **'Chat Support'**
  String get chatSupport;

  /// No description provided for @cropRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Crop Recommendation'**
  String get cropRecommendation;

  /// No description provided for @yieldPrediction.
  ///
  /// In en, this message translates to:
  /// **'Yield Prediction'**
  String get yieldPrediction;

  /// No description provided for @diseaseDetection.
  ///
  /// In en, this message translates to:
  /// **'Disease Detection'**
  String get diseaseDetection;

  /// No description provided for @moreTools.
  ///
  /// In en, this message translates to:
  /// **'More Tools'**
  String get moreTools;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @cropAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Crop Analysis'**
  String get cropAnalysis;

  /// No description provided for @plantHealth.
  ///
  /// In en, this message translates to:
  /// **'Plant Health'**
  String get plantHealth;

  /// No description provided for @soilAndFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Soil & Fertilizer'**
  String get soilAndFertilizer;

  /// No description provided for @toolCategories.
  ///
  /// In en, this message translates to:
  /// **'Tool Categories'**
  String get toolCategories;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @voiceQuery.
  ///
  /// In en, this message translates to:
  /// **'Voice Query'**
  String get voiceQuery;

  /// No description provided for @weatherDataUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Weather data unavailable'**
  String get weatherDataUnavailable;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @areYouSureClearHistory.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all conversation history?'**
  String get areYouSureClearHistory;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @fertilizer.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer'**
  String get fertilizer;

  /// No description provided for @fertilizerRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer Recommendation'**
  String get fertilizerRecommendation;

  /// No description provided for @tools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get tools;

  /// No description provided for @cropName.
  ///
  /// In en, this message translates to:
  /// **'Crop Name'**
  String get cropName;

  /// No description provided for @soilType.
  ///
  /// In en, this message translates to:
  /// **'Soil Type'**
  String get soilType;

  /// No description provided for @nitrogenContent.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen Content'**
  String get nitrogenContent;

  /// No description provided for @phosphorousContent.
  ///
  /// In en, this message translates to:
  /// **'Phosphorous Content'**
  String get phosphorousContent;

  /// No description provided for @potassiumContent.
  ///
  /// In en, this message translates to:
  /// **'Potassium Content'**
  String get potassiumContent;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @ph.
  ///
  /// In en, this message translates to:
  /// **'pH'**
  String get ph;

  /// No description provided for @rainfall.
  ///
  /// In en, this message translates to:
  /// **'Rainfall'**
  String get rainfall;

  /// No description provided for @getRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Get Recommendation'**
  String get getRecommendation;

  /// No description provided for @enterCropName.
  ///
  /// In en, this message translates to:
  /// **'Enter crop name'**
  String get enterCropName;

  /// No description provided for @enterSoilType.
  ///
  /// In en, this message translates to:
  /// **'Enter soil type'**
  String get enterSoilType;

  /// No description provided for @enterNitrogenContent.
  ///
  /// In en, this message translates to:
  /// **'Enter nitrogen content'**
  String get enterNitrogenContent;

  /// No description provided for @enterPhosphorousContent.
  ///
  /// In en, this message translates to:
  /// **'Enter phosphorous content'**
  String get enterPhosphorousContent;

  /// No description provided for @enterPotassiumContent.
  ///
  /// In en, this message translates to:
  /// **'Enter potassium content'**
  String get enterPotassiumContent;

  /// No description provided for @enterTemperature.
  ///
  /// In en, this message translates to:
  /// **'Enter temperature (°C)'**
  String get enterTemperature;

  /// No description provided for @enterHumidity.
  ///
  /// In en, this message translates to:
  /// **'Enter humidity (%)'**
  String get enterHumidity;

  /// No description provided for @enterPh.
  ///
  /// In en, this message translates to:
  /// **'Enter pH value'**
  String get enterPh;

  /// No description provided for @enterRainfall.
  ///
  /// In en, this message translates to:
  /// **'Enter rainfall (mm)'**
  String get enterRainfall;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get pleaseFillAllFields;

  /// No description provided for @invalidInput.
  ///
  /// In en, this message translates to:
  /// **'Invalid input'**
  String get invalidInput;

  /// No description provided for @errorGettingRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Error getting recommendation'**
  String get errorGettingRecommendation;

  /// No description provided for @uploadOrTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload or Take Photo'**
  String get uploadOrTakePhoto;

  /// No description provided for @selectImage.
  ///
  /// In en, this message translates to:
  /// **'Select Image'**
  String get selectImage;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @analyzeImage.
  ///
  /// In en, this message translates to:
  /// **'Analyze Image'**
  String get analyzeImage;

  /// No description provided for @analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get analyzing;

  /// No description provided for @analysisComplete.
  ///
  /// In en, this message translates to:
  /// **'Analysis Complete'**
  String get analysisComplete;

  /// No description provided for @noImageSelected.
  ///
  /// In en, this message translates to:
  /// **'No image selected'**
  String get noImageSelected;

  /// No description provided for @imageAnalysisFailed.
  ///
  /// In en, this message translates to:
  /// **'Image analysis failed'**
  String get imageAnalysisFailed;

  /// No description provided for @selectImageFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select an image first'**
  String get selectImageFirst;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @enterArea.
  ///
  /// In en, this message translates to:
  /// **'Enter area (hectares)'**
  String get enterArea;

  /// No description provided for @getPrediction.
  ///
  /// In en, this message translates to:
  /// **'Get Prediction'**
  String get getPrediction;

  /// No description provided for @enterAreaValue.
  ///
  /// In en, this message translates to:
  /// **'Enter area value'**
  String get enterAreaValue;

  /// No description provided for @predicting.
  ///
  /// In en, this message translates to:
  /// **'Predicting...'**
  String get predicting;

  /// No description provided for @predictionComplete.
  ///
  /// In en, this message translates to:
  /// **'Prediction Complete'**
  String get predictionComplete;

  /// No description provided for @errorGettingPrediction.
  ///
  /// In en, this message translates to:
  /// **'Error getting prediction'**
  String get errorGettingPrediction;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get locationPermissionDenied;

  /// No description provided for @enableLocationServices.
  ///
  /// In en, this message translates to:
  /// **'Please enable location services'**
  String get enableLocationServices;

  /// No description provided for @fetchingWeatherData.
  ///
  /// In en, this message translates to:
  /// **'Fetching weather data...'**
  String get fetchingWeatherData;

  /// No description provided for @weatherError.
  ///
  /// In en, this message translates to:
  /// **'Error fetching weather data'**
  String get weatherError;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System Theme'**
  String get systemTheme;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @smsNotifications.
  ///
  /// In en, this message translates to:
  /// **'SMS Notifications'**
  String get smsNotifications;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @buildNumber.
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get buildNumber;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @reportBug.
  ///
  /// In en, this message translates to:
  /// **'Report Bug'**
  String get reportBug;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @tutorial.
  ///
  /// In en, this message translates to:
  /// **'Tutorial'**
  String get tutorial;

  /// No description provided for @guide.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get guide;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @updates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get updates;

  /// No description provided for @whatsNew.
  ///
  /// In en, this message translates to:
  /// **'What\'s New'**
  String get whatsNew;

  /// No description provided for @changelog.
  ///
  /// In en, this message translates to:
  /// **'Changelog'**
  String get changelog;

  /// No description provided for @grantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get grantPermission;

  /// No description provided for @wind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get wind;

  /// No description provided for @rainToday.
  ///
  /// In en, this message translates to:
  /// **'Rain Today'**
  String get rainToday;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @sevenDayRainForecast.
  ///
  /// In en, this message translates to:
  /// **'7-Day Rain Forecast'**
  String get sevenDayRainForecast;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sunday;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening'**
  String get listening;

  /// No description provided for @readyToTalk.
  ///
  /// In en, this message translates to:
  /// **'Ready to talk'**
  String get readyToTalk;

  /// No description provided for @tapMicToStartTalking.
  ///
  /// In en, this message translates to:
  /// **'Tap the mic to start talking with Krishi Sakhi'**
  String get tapMicToStartTalking;

  /// No description provided for @thinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking...'**
  String get thinking;

  /// No description provided for @speakingInterrupt.
  ///
  /// In en, this message translates to:
  /// **'Speaking (Tap mic to interrupt)'**
  String get speakingInterrupt;

  /// No description provided for @speakNow.
  ///
  /// In en, this message translates to:
  /// **'Speak now...'**
  String get speakNow;

  /// No description provided for @gettingAnswer.
  ///
  /// In en, this message translates to:
  /// **'Getting your answer...'**
  String get gettingAnswer;

  /// No description provided for @speaking.
  ///
  /// In en, this message translates to:
  /// **'Speaking...'**
  String get speaking;

  /// No description provided for @loadingWeather.
  ///
  /// In en, this message translates to:
  /// **'Loading weather...'**
  String get loadingWeather;

  /// No description provided for @loggedIn.
  ///
  /// In en, this message translates to:
  /// **'Logged in'**
  String get loggedIn;

  /// No description provided for @loggedInAs.
  ///
  /// In en, this message translates to:
  /// **'Logged in as {phone}'**
  String loggedInAs(String phone);

  /// No description provided for @profileInformation.
  ///
  /// In en, this message translates to:
  /// **'Profile Information'**
  String get profileInformation;

  /// No description provided for @farmInformation.
  ///
  /// In en, this message translates to:
  /// **'Farm Information'**
  String get farmInformation;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @locality.
  ///
  /// In en, this message translates to:
  /// **'Locality'**
  String get locality;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @enterYourLocality.
  ///
  /// In en, this message translates to:
  /// **'Enter your locality'**
  String get enterYourLocality;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @enterYourPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone'**
  String get enterYourPhone;

  /// No description provided for @landArea.
  ///
  /// In en, this message translates to:
  /// **'Land Area'**
  String get landArea;

  /// No description provided for @enterLandArea.
  ///
  /// In en, this message translates to:
  /// **'Enter land area'**
  String get enterLandArea;

  /// No description provided for @typesOfCrops.
  ///
  /// In en, this message translates to:
  /// **'Types of Crops'**
  String get typesOfCrops;

  /// No description provided for @enterTypesOfCrops.
  ///
  /// In en, this message translates to:
  /// **'Enter types of crops'**
  String get enterTypesOfCrops;

  /// No description provided for @fertilizersAndChemicals.
  ///
  /// In en, this message translates to:
  /// **'Fertilizers and Chemicals'**
  String get fertilizersAndChemicals;

  /// No description provided for @enterFertilizersAndChemicals.
  ///
  /// In en, this message translates to:
  /// **'Enter fertilizers/chemicals'**
  String get enterFertilizersAndChemicals;

  /// No description provided for @sourceOfIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Source of Irrigation'**
  String get sourceOfIrrigation;

  /// No description provided for @enterSourceOfIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Enter source of irrigation'**
  String get enterSourceOfIrrigation;

  /// No description provided for @numberOfCrops.
  ///
  /// In en, this message translates to:
  /// **'Number of Crops'**
  String get numberOfCrops;

  /// No description provided for @enterNumberOfCrops.
  ///
  /// In en, this message translates to:
  /// **'Enter number of crops'**
  String get enterNumberOfCrops;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @areYouSureYouWantToLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSureYouWantToLogout;

  /// No description provided for @areYouSureYouWantToClearAllConversationHistory.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all conversation history?'**
  String get areYouSureYouWantToClearAllConversationHistory;

  /// No description provided for @typeYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get typeYourMessage;

  /// No description provided for @talk.
  ///
  /// In en, this message translates to:
  /// **'Talk'**
  String get talk;

  /// No description provided for @soilParameters.
  ///
  /// In en, this message translates to:
  /// **'Soil Parameters'**
  String get soilParameters;

  /// No description provided for @environmentalParameters.
  ///
  /// In en, this message translates to:
  /// **'Environmental Parameters'**
  String get environmentalParameters;

  /// No description provided for @nitrogen.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen'**
  String get nitrogen;

  /// No description provided for @phosphorus.
  ///
  /// In en, this message translates to:
  /// **'Phosphorus'**
  String get phosphorus;

  /// No description provided for @potassium.
  ///
  /// In en, this message translates to:
  /// **'Potassium'**
  String get potassium;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumber;

  /// No description provided for @weatherDataError.
  ///
  /// In en, this message translates to:
  /// **'Weather Data Error'**
  String get weatherDataError;

  /// No description provided for @weatherDataNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Weather data not available'**
  String get weatherDataNotAvailable;

  /// No description provided for @recommendedCrop.
  ///
  /// In en, this message translates to:
  /// **'Recommended Crop'**
  String get recommendedCrop;

  /// No description provided for @aiAnalysisAndJustification.
  ///
  /// In en, this message translates to:
  /// **'AI Analysis & Justification'**
  String get aiAnalysisAndJustification;

  /// No description provided for @usingLocalRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Using local recommendation (Service temporarily unavailable)'**
  String get usingLocalRecommendation;

  /// No description provided for @soilSuitability.
  ///
  /// In en, this message translates to:
  /// **'Soil Suitability'**
  String get soilSuitability;

  /// No description provided for @weatherDataRequired.
  ///
  /// In en, this message translates to:
  /// **'Weather data is required for crop recommendation. Please ensure location permission is granted.'**
  String get weatherDataRequired;

  /// No description provided for @usingCurrentWeatherData.
  ///
  /// In en, this message translates to:
  /// **'Using current weather data as monthly forecast is not available.'**
  String get usingCurrentWeatherData;

  /// No description provided for @aiTools.
  ///
  /// In en, this message translates to:
  /// **'AI Tools'**
  String get aiTools;

  /// No description provided for @aiToolsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose an AI-powered tool to help with your farming needs:'**
  String get aiToolsSubtitle;

  /// No description provided for @cropRecommendationDesc.
  ///
  /// In en, this message translates to:
  /// **'Get AI recommendations for the best crops based on soil and weather conditions.'**
  String get cropRecommendationDesc;

  /// No description provided for @yieldPredictionDesc.
  ///
  /// In en, this message translates to:
  /// **'Predict crop yield based on historical data and current conditions.'**
  String get yieldPredictionDesc;

  /// No description provided for @diseaseDetectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Upload leaf images to detect plant diseases using AI vision.'**
  String get diseaseDetectionDesc;

  /// No description provided for @pestDetection.
  ///
  /// In en, this message translates to:
  /// **'Pest Detection'**
  String get pestDetection;

  /// No description provided for @pestDetectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Upload crop images to detect pests using AI vision.'**
  String get pestDetectionDesc;

  /// No description provided for @fertilizerRecommendationDesc.
  ///
  /// In en, this message translates to:
  /// **'Get AI recommendations for the best fertilizers based on soil type, crop, and environmental conditions.'**
  String get fertilizerRecommendationDesc;

  /// No description provided for @environmentalFactors.
  ///
  /// In en, this message translates to:
  /// **'Environmental Factors'**
  String get environmentalFactors;

  /// No description provided for @keyBenefits.
  ///
  /// In en, this message translates to:
  /// **'Key Benefits'**
  String get keyBenefits;

  /// No description provided for @riskConsiderations.
  ///
  /// In en, this message translates to:
  /// **'Risk Considerations'**
  String get riskConsiderations;

  /// No description provided for @farmingRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Farming Recommendations'**
  String get farmingRecommendations;

  /// No description provided for @generatingAiAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Generating AI Analysis...'**
  String get generatingAiAnalysis;

  /// No description provided for @cropDetails.
  ///
  /// In en, this message translates to:
  /// **'Crop Details'**
  String get cropDetails;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @season.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get season;

  /// No description provided for @areaAndYear.
  ///
  /// In en, this message translates to:
  /// **'Area & Year'**
  String get areaAndYear;

  /// No description provided for @areaHectares.
  ///
  /// In en, this message translates to:
  /// **'Area (hectares)'**
  String get areaHectares;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @predictYield.
  ///
  /// In en, this message translates to:
  /// **'Predict Yield'**
  String get predictYield;

  /// No description provided for @predictedYield.
  ///
  /// In en, this message translates to:
  /// **'Predicted Yield'**
  String get predictedYield;

  /// No description provided for @tonsPerHectare.
  ///
  /// In en, this message translates to:
  /// **'tons/hectare'**
  String get tonsPerHectare;

  /// No description provided for @marketPriceAndProfitAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Market Price & Profit Analysis'**
  String get marketPriceAndProfitAnalysis;

  /// No description provided for @currentMarketPrice.
  ///
  /// In en, this message translates to:
  /// **'Current Market Price:'**
  String get currentMarketPrice;

  /// No description provided for @perKg.
  ///
  /// In en, this message translates to:
  /// **'per kg'**
  String get perKg;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range:'**
  String get priceRange;

  /// No description provided for @profitAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Profit Analysis:'**
  String get profitAnalysis;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue:'**
  String get totalRevenue;

  /// No description provided for @estimatedCosts.
  ///
  /// In en, this message translates to:
  /// **'Estimated Costs:'**
  String get estimatedCosts;

  /// No description provided for @netProfit.
  ///
  /// In en, this message translates to:
  /// **'Net Profit:'**
  String get netProfit;

  /// No description provided for @profitPerHectare.
  ///
  /// In en, this message translates to:
  /// **'Profit per Hectare:'**
  String get profitPerHectare;

  /// No description provided for @marketTrends.
  ///
  /// In en, this message translates to:
  /// **'Market Trends'**
  String get marketTrends;

  /// No description provided for @sellingStrategies.
  ///
  /// In en, this message translates to:
  /// **'Selling Strategies'**
  String get sellingStrategies;

  /// No description provided for @riskFactors.
  ///
  /// In en, this message translates to:
  /// **'Risk Factors'**
  String get riskFactors;

  /// No description provided for @governmentSupport.
  ///
  /// In en, this message translates to:
  /// **'Government Support'**
  String get governmentSupport;

  /// No description provided for @invalidYear.
  ///
  /// In en, this message translates to:
  /// **'Invalid year'**
  String get invalidYear;

  /// No description provided for @analyzeDisease.
  ///
  /// In en, this message translates to:
  /// **'Analyze Disease'**
  String get analyzeDisease;

  /// No description provided for @analyzePest.
  ///
  /// In en, this message translates to:
  /// **'Analyze Pest'**
  String get analyzePest;

  /// No description provided for @detectionResults.
  ///
  /// In en, this message translates to:
  /// **'Detection Results'**
  String get detectionResults;

  /// No description provided for @diseaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Disease:'**
  String get diseaseLabel;

  /// No description provided for @pestLabel.
  ///
  /// In en, this message translates to:
  /// **'Pest:'**
  String get pestLabel;

  /// No description provided for @confidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Confidence:'**
  String get confidenceLabel;

  /// No description provided for @clearImage.
  ///
  /// In en, this message translates to:
  /// **'Clear Image'**
  String get clearImage;

  /// No description provided for @diseaseDetectionInstructions.
  ///
  /// In en, this message translates to:
  /// **'Take a clear photo of the plant leaf showing any symptoms or discoloration. The AI will analyze the image to detect potential diseases.'**
  String get diseaseDetectionInstructions;

  /// No description provided for @pestDetectionInstructions.
  ///
  /// In en, this message translates to:
  /// **'Take a clear photo of the crop showing any pest damage or insects. The AI will analyze the image to detect potential pests.'**
  String get pestDetectionInstructions;

  /// No description provided for @soilAndCropInformation.
  ///
  /// In en, this message translates to:
  /// **'Soil & Crop Information'**
  String get soilAndCropInformation;

  /// No description provided for @soilHealthCardInfo.
  ///
  /// In en, this message translates to:
  /// **'Refer to your soil health card or apply for one at https://soilhealth.dac.gov.in/soilhealthcard'**
  String get soilHealthCardInfo;

  /// No description provided for @cropType.
  ///
  /// In en, this message translates to:
  /// **'Crop Type'**
  String get cropType;

  /// No description provided for @moisture.
  ///
  /// In en, this message translates to:
  /// **'Moisture (%)'**
  String get moisture;

  /// No description provided for @soilNutrientLevels.
  ///
  /// In en, this message translates to:
  /// **'Soil Nutrient Levels'**
  String get soilNutrientLevels;

  /// No description provided for @phosphorous.
  ///
  /// In en, this message translates to:
  /// **'Phosphorous'**
  String get phosphorous;

  /// No description provided for @recommendedFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Recommended Fertilizer'**
  String get recommendedFertilizer;

  /// No description provided for @pleaseSelectSoilType.
  ///
  /// In en, this message translates to:
  /// **'Please select soil type'**
  String get pleaseSelectSoilType;

  /// No description provided for @pleaseSelectCropType.
  ///
  /// In en, this message translates to:
  /// **'Please select crop type'**
  String get pleaseSelectCropType;

  /// No description provided for @weatherDataRequiredFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Weather data is required for fertilizer recommendation. Please ensure location permission is granted.'**
  String get weatherDataRequiredFertilizer;

  /// No description provided for @financialAssistance.
  ///
  /// In en, this message translates to:
  /// **'Financial Assistance'**
  String get financialAssistance;

  /// No description provided for @governmentSchemesAndLoans.
  ///
  /// In en, this message translates to:
  /// **'Government Schemes & Loans'**
  String get governmentSchemesAndLoans;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'bn',
    'en',
    'hi',
    'kn',
    'ml',
    'pa',
    'ta',
    'te',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ml':
      return AppLocalizationsMl();
    case 'pa':
      return AppLocalizationsPa();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
