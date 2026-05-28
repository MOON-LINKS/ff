import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @language_title.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language_title;

  /// No description provided for @no_news.
  ///
  /// In en, this message translates to:
  /// **'No news available right now'**
  String get no_news;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'SERVICES'**
  String get services;

  /// No description provided for @best_services_for_you.
  ///
  /// In en, this message translates to:
  /// **'BEST SERVICES FOR YOU'**
  String get best_services_for_you;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'MENU'**
  String get menu;

  /// No description provided for @generator.
  ///
  /// In en, this message translates to:
  /// **'GENERATOR'**
  String get generator;

  /// No description provided for @biopage.
  ///
  /// In en, this message translates to:
  /// **'BIOPAGE'**
  String get biopage;

  /// No description provided for @free_generator.
  ///
  /// In en, this message translates to:
  /// **'FREE GENERATOR'**
  String get free_generator;

  /// No description provided for @qr_code.
  ///
  /// In en, this message translates to:
  /// **'QR CODE'**
  String get qr_code;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'BARCODE'**
  String get barcode;

  /// No description provided for @secure_payments_supported_by.
  ///
  /// In en, this message translates to:
  /// **'Secure Payments Supported By'**
  String get secure_payments_supported_by;

  /// No description provided for @workspace.
  ///
  /// In en, this message translates to:
  /// **'WORKSPACE'**
  String get workspace;

  /// No description provided for @upgrade_plan.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Plan'**
  String get upgrade_plan;

  /// No description provided for @less_info.
  ///
  /// In en, this message translates to:
  /// **'Less Info'**
  String get less_info;

  /// No description provided for @more_info.
  ///
  /// In en, this message translates to:
  /// **'More Info'**
  String get more_info;

  /// No description provided for @auto_renew.
  ///
  /// In en, this message translates to:
  /// **'Auto-Renew'**
  String get auto_renew;

  /// No description provided for @you_are_not_subscribed_yet.
  ///
  /// In en, this message translates to:
  /// **'You Are Not Subscribed Yet'**
  String get you_are_not_subscribed_yet;

  /// No description provided for @must_be_logged_in_to_access_services.
  ///
  /// In en, this message translates to:
  /// **'You must be Logged in to access your services'**
  String get must_be_logged_in_to_access_services;

  /// No description provided for @infinite_access.
  ///
  /// In en, this message translates to:
  /// **'INFINITE ACCESS'**
  String get infinite_access;

  /// No description provided for @what_we_offer_and_whats_new.
  ///
  /// In en, this message translates to:
  /// **'WHAT WE OFFER & WHAT\'S NEW'**
  String get what_we_offer_and_whats_new;

  /// No description provided for @this_plan_is_in_cart.
  ///
  /// In en, this message translates to:
  /// **'This Plan Is In Cart'**
  String get this_plan_is_in_cart;

  /// No description provided for @you_are_subscribed_to_this_plan.
  ///
  /// In en, this message translates to:
  /// **'You Are Subscribed To This Plan'**
  String get you_are_subscribed_to_this_plan;

  /// No description provided for @menu_title.
  ///
  /// In en, this message translates to:
  /// **'MENU'**
  String get menu_title;

  /// No description provided for @menu_description.
  ///
  /// In en, this message translates to:
  /// **'Whether you run a small café, a busy restaurant, or a fully online food service, our Menu Generator Tool is made for you. It is simple, flexible, and easy to use, giving you the freedom to create menus that truly reflect your brand. With built-in online hosting, your customers can always see your latest menu wherever they are. Explore our plans and choose the one that fits your business best, because every restaurant deserves a menu as unique as its food.'**
  String get menu_description;

  /// No description provided for @plans.
  ///
  /// In en, this message translates to:
  /// **'PLANS'**
  String get plans;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'MONTHLY'**
  String get monthly;

  /// No description provided for @six_months.
  ///
  /// In en, this message translates to:
  /// **'6 MONTHS'**
  String get six_months;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'YEARLY'**
  String get yearly;

  /// No description provided for @learn_how_to_build_your_menu.
  ///
  /// In en, this message translates to:
  /// **'LEARN HOW TO BUILD YOUR MENU'**
  String get learn_how_to_build_your_menu;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'PROFILE'**
  String get profile;

  /// No description provided for @information_about_you.
  ///
  /// In en, this message translates to:
  /// **'INFORMATIONS ABOUT YOU'**
  String get information_about_you;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'REGISTER'**
  String get register;

  /// No description provided for @sign_up_for_new_acc.
  ///
  /// In en, this message translates to:
  /// **'SIGN UP FOR A NEW ACCOUNT'**
  String get sign_up_for_new_acc;

  /// No description provided for @accept_term_and_conditions.
  ///
  /// In en, this message translates to:
  /// **'You must accept terms and conditions'**
  String get accept_term_and_conditions;

  /// No description provided for @registering.
  ///
  /// In en, this message translates to:
  /// **'Registering...'**
  String get registering;

  /// No description provided for @reset_your_password.
  ///
  /// In en, this message translates to:
  /// **'RESET YOUR PASSWORD'**
  String get reset_your_password;

  /// No description provided for @enter_your_new_password.
  ///
  /// In en, this message translates to:
  /// **'Enter Your New Password'**
  String get enter_your_new_password;

  /// No description provided for @re_enter_your_password.
  ///
  /// In en, this message translates to:
  /// **'Re-Enter Your Password'**
  String get re_enter_your_password;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'RESET'**
  String get reset;

  /// No description provided for @enter_your_otp.
  ///
  /// In en, this message translates to:
  /// **'Enter Your OTP'**
  String get enter_your_otp;

  /// No description provided for @enter_your_mail.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Email'**
  String get enter_your_mail;

  /// No description provided for @reset_your_password_title.
  ///
  /// In en, this message translates to:
  /// **'RESET YOUR PASSWORD IF YOU FORGOT IT'**
  String get reset_your_password_title;

  /// No description provided for @otp_title.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otp_title;

  /// No description provided for @enter_the_6_digit_code_you_received.
  ///
  /// In en, this message translates to:
  /// **'Enter The 6-Digit Code You Received'**
  String get enter_the_6_digit_code_you_received;

  /// No description provided for @registration_successful.
  ///
  /// In en, this message translates to:
  /// **'Registration Successful!'**
  String get registration_successful;

  /// No description provided for @wrong_otp_try_again_later.
  ///
  /// In en, this message translates to:
  /// **'Wrong OTP, Try Again Later'**
  String get wrong_otp_try_again_later;

  /// No description provided for @logout_from_all.
  ///
  /// In en, this message translates to:
  /// **'LOGOUT FROM ALL'**
  String get logout_from_all;

  /// No description provided for @logout_from_all_opened_sessions.
  ///
  /// In en, this message translates to:
  /// **'LOGOUT FROM ALL OPENED SESSIONS'**
  String get logout_from_all_opened_sessions;

  /// No description provided for @enter_your_password.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Password'**
  String get enter_your_password;

  /// No description provided for @log_in.
  ///
  /// In en, this message translates to:
  /// **'LOG IN'**
  String get log_in;

  /// No description provided for @log_into_account.
  ///
  /// In en, this message translates to:
  /// **'LOG INTO YOUR ACCOUNT'**
  String get log_into_account;

  /// No description provided for @login_failed.
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get login_failed;

  /// No description provided for @checking_inputs.
  ///
  /// In en, this message translates to:
  /// **'Checking inputs...'**
  String get checking_inputs;

  /// No description provided for @login_successful.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get login_successful;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'SIGN UP'**
  String get sign_up;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @you_have_to_pay_more.
  ///
  /// In en, this message translates to:
  /// **'You Have To Pay More'**
  String get you_have_to_pay_more;

  /// No description provided for @i_accept_terms_and_conditions.
  ///
  /// In en, this message translates to:
  /// **'I accept all terms and conditions'**
  String get i_accept_terms_and_conditions;

  /// No description provided for @add_to_cart.
  ///
  /// In en, this message translates to:
  /// **'ADD TO CART'**
  String get add_to_cart;

  /// No description provided for @view_plan_description.
  ///
  /// In en, this message translates to:
  /// **'View Plan Description'**
  String get view_plan_description;

  /// No description provided for @feature_30_images.
  ///
  /// In en, this message translates to:
  /// **'• 30 Images'**
  String get feature_30_images;

  /// No description provided for @feature_order_method.
  ///
  /// In en, this message translates to:
  /// **'• Order Method'**
  String get feature_order_method;

  /// No description provided for @feature_color_patterns.
  ///
  /// In en, this message translates to:
  /// **'• Color Patterns'**
  String get feature_color_patterns;

  /// No description provided for @feature_logo.
  ///
  /// In en, this message translates to:
  /// **'• Logo'**
  String get feature_logo;

  /// No description provided for @feature_banner.
  ///
  /// In en, this message translates to:
  /// **'• Banner'**
  String get feature_banner;

  /// No description provided for @feature_offer.
  ///
  /// In en, this message translates to:
  /// **'• Offer'**
  String get feature_offer;

  /// No description provided for @feature_unlimited_categories_items.
  ///
  /// In en, this message translates to:
  /// **'• Unlimited Categories & Items'**
  String get feature_unlimited_categories_items;

  /// No description provided for @feature_fonts.
  ///
  /// In en, this message translates to:
  /// **'• Fonts'**
  String get feature_fonts;

  /// No description provided for @feature_qr_code_generated.
  ///
  /// In en, this message translates to:
  /// **'• QR-code Generated'**
  String get feature_qr_code_generated;

  /// No description provided for @feature_moon_links_hosting.
  ///
  /// In en, this message translates to:
  /// **'• MOON LINKS Hosting'**
  String get feature_moon_links_hosting;

  /// No description provided for @feature_150_images.
  ///
  /// In en, this message translates to:
  /// **'• 150 Images'**
  String get feature_150_images;

  /// No description provided for @feature_open_close_timers.
  ///
  /// In en, this message translates to:
  /// **'• Open / Close Timers'**
  String get feature_open_close_timers;

  /// No description provided for @feature_feedback.
  ///
  /// In en, this message translates to:
  /// **'• Feedback'**
  String get feature_feedback;

  /// No description provided for @feature_3_social_media_links.
  ///
  /// In en, this message translates to:
  /// **'• 3 Social Media Links'**
  String get feature_3_social_media_links;

  /// No description provided for @feature_300_images.
  ///
  /// In en, this message translates to:
  /// **'• 300 images'**
  String get feature_300_images;

  /// No description provided for @feature_category_images_upload.
  ///
  /// In en, this message translates to:
  /// **'• Category Iimages Upload'**
  String get feature_category_images_upload;

  /// No description provided for @feature_unlimited_social_media_links.
  ///
  /// In en, this message translates to:
  /// **'• Unlimited Social Media Links'**
  String get feature_unlimited_social_media_links;

  /// No description provided for @feature_country_branch_locations.
  ///
  /// In en, this message translates to:
  /// **'• Country/Branch Locations'**
  String get feature_country_branch_locations;

  /// No description provided for @feature_real_time_animations.
  ///
  /// In en, this message translates to:
  /// **'• Real-Time Animations'**
  String get feature_real_time_animations;

  /// No description provided for @feature_analytics.
  ///
  /// In en, this message translates to:
  /// **'• Analytics'**
  String get feature_analytics;

  /// No description provided for @feature_translate_up_to_6_languages.
  ///
  /// In en, this message translates to:
  /// **'• Translate Up To 6 languages'**
  String get feature_translate_up_to_6_languages;

  /// No description provided for @feature_unlimited_images_add_ons.
  ///
  /// In en, this message translates to:
  /// **'• Unlimited Images Add Ons'**
  String get feature_unlimited_images_add_ons;

  /// No description provided for @feature_enhanced_seo_digital_marketing.
  ///
  /// In en, this message translates to:
  /// **'• Enhanced SEO & Digital Marketing'**
  String get feature_enhanced_seo_digital_marketing;

  /// No description provided for @feature_24_7_priority_support.
  ///
  /// In en, this message translates to:
  /// **'• 24/7 priority support'**
  String get feature_24_7_priority_support;

  /// No description provided for @home_nav.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home_nav;

  /// No description provided for @services_nav.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services_nav;

  /// No description provided for @my_services_nav.
  ///
  /// In en, this message translates to:
  /// **'My Services'**
  String get my_services_nav;

  /// No description provided for @profile_nav.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_nav;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get selected;

  /// No description provided for @confirm_add_on.
  ///
  /// In en, this message translates to:
  /// **'Confirm Add-On'**
  String get confirm_add_on;

  /// No description provided for @confirm_add_on_message.
  ///
  /// In en, this message translates to:
  /// **'This will immediately update your add-on and charge your account. Do you want to continue?'**
  String get confirm_add_on_message;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @continue_action.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_action;

  /// No description provided for @addon_price_rule.
  ///
  /// In en, this message translates to:
  /// **'2 \$ for every 100 added images'**
  String get addon_price_rule;

  /// No description provided for @total_add_on_is.
  ///
  /// In en, this message translates to:
  /// **'Total Add-On is'**
  String get total_add_on_is;

  /// No description provided for @update_add.
  ///
  /// In en, this message translates to:
  /// **'Update Add'**
  String get update_add;

  /// No description provided for @add_on.
  ///
  /// In en, this message translates to:
  /// **'Add On'**
  String get add_on;

  /// No description provided for @total_price.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get total_price;

  /// No description provided for @field_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get field_required;

  /// No description provided for @invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get invalid_email;

  /// No description provided for @password_min_length.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get password_min_length;

  /// No description provided for @no_addon_data_available.
  ///
  /// In en, this message translates to:
  /// **'No add-on data available'**
  String get no_addon_data_available;

  /// No description provided for @images_added.
  ///
  /// In en, this message translates to:
  /// **'Images Added'**
  String get images_added;

  /// No description provided for @till.
  ///
  /// In en, this message translates to:
  /// **'Till'**
  String get till;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @must_be_signed_in_to_pay.
  ///
  /// In en, this message translates to:
  /// **'You must be signed in to Pay'**
  String get must_be_signed_in_to_pay;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get sign_in;

  /// No description provided for @account_not_verified.
  ///
  /// In en, this message translates to:
  /// **'Your account is not verified'**
  String get account_not_verified;

  /// No description provided for @no_added_service.
  ///
  /// In en, this message translates to:
  /// **'You dont have any added service'**
  String get no_added_service;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @pay_now.
  ///
  /// In en, this message translates to:
  /// **'PAY NOW'**
  String get pay_now;

  /// No description provided for @past_due.
  ///
  /// In en, this message translates to:
  /// **'Recharge required: your plan is past due and has insufficient credits or auto-renew is off.'**
  String get past_due;

  /// No description provided for @recharge.
  ///
  /// In en, this message translates to:
  /// **'Recharge'**
  String get recharge;

  /// No description provided for @resubscribe.
  ///
  /// In en, this message translates to:
  /// **'Resubscribe'**
  String get resubscribe;

  /// No description provided for @apple_pay_disabled.
  ///
  /// In en, this message translates to:
  /// **'Apple Pay support is currently under development. Please use the web payment method.'**
  String get apple_pay_disabled;

  /// No description provided for @upgrade_now_title.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Now?'**
  String get upgrade_now_title;

  /// No description provided for @upgrade_now_description.
  ///
  /// In en, this message translates to:
  /// **'This will use your current card on file to directly upgrade your plan.'**
  String get upgrade_now_description;

  /// No description provided for @choose_language.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get choose_language;

  /// No description provided for @delete_account_button.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account_button;

  /// No description provided for @delete_account_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get delete_account_title;

  /// No description provided for @delete_account_warning.
  ///
  /// In en, this message translates to:
  /// **'This action is irreversible. All your subscriptions will be cancelled and your account will be permanently deactivated.'**
  String get delete_account_warning;

  /// No description provided for @delete_account_confirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, Delete'**
  String get delete_account_confirm;

  /// No description provided for @delete_account_error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get delete_account_error;

  /// No description provided for @recharge_plan.
  ///
  /// In en, this message translates to:
  /// **'Recharge Plan'**
  String get recharge_plan;

  /// No description provided for @already_have_active_plan.
  ///
  /// In en, this message translates to:
  /// **'You already have an active plan.'**
  String get already_have_active_plan;

  /// No description provided for @recharge_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Recharge Plan?'**
  String get recharge_confirm_title;

  /// No description provided for @recharge_confirm_description.
  ///
  /// In en, this message translates to:
  /// **'This will charge your card on file immediately to reactivate your plan.'**
  String get recharge_confirm_description;

  /// No description provided for @recharge_confirm_button.
  ///
  /// In en, this message translates to:
  /// **'Yes, Recharge'**
  String get recharge_confirm_button;

  /// No description provided for @manage_payment_methods.
  ///
  /// In en, this message translates to:
  /// **'Manage Payment Methods'**
  String get manage_payment_methods;

  /// No description provided for @add_on_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Add-on updated successfully.'**
  String get add_on_updated_successfully;

  /// No description provided for @subscribe_via_web.
  ///
  /// In en, this message translates to:
  /// **'To subscribe or manage your plan, please visit app.moonlinks.me from your browser.'**
  String get subscribe_via_web;

  /// No description provided for @no_plans_to_upgrade.
  ///
  /// In en, this message translates to:
  /// **'No upgrade plans available for this subscription.'**
  String get no_plans_to_upgrade;

  /// No description provided for @menu_delete_subcategory.
  ///
  /// In en, this message translates to:
  /// **'Delete Subcategory?'**
  String get menu_delete_subcategory;

  /// No description provided for @menu_delete_subcategory_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this subcategory? All items inside it will also be deleted.'**
  String get menu_delete_subcategory_message;

  /// No description provided for @menu_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get menu_delete;

  /// No description provided for @menu_update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get menu_update;

  /// No description provided for @menu_delete_image.
  ///
  /// In en, this message translates to:
  /// **'Delete Image'**
  String get menu_delete_image;

  /// No description provided for @menu_subcategories_for.
  ///
  /// In en, this message translates to:
  /// **'Subcategories for'**
  String get menu_subcategories_for;

  /// No description provided for @menu_no_subcategories_found.
  ///
  /// In en, this message translates to:
  /// **'No Subcategories Found'**
  String get menu_no_subcategories_found;

  /// No description provided for @menu_add_subcategory.
  ///
  /// In en, this message translates to:
  /// **'ADD SUBCATEGORY'**
  String get menu_add_subcategory;

  /// No description provided for @menu_checking_inputs.
  ///
  /// In en, this message translates to:
  /// **'Checking inputs...'**
  String get menu_checking_inputs;

  /// No description provided for @menu_unsaved_changes.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get menu_unsaved_changes;

  /// No description provided for @menu_unsaved_changes_message.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. What would you like to do?'**
  String get menu_unsaved_changes_message;

  /// No description provided for @menu_leave_anyway.
  ///
  /// In en, this message translates to:
  /// **'Leave Anyway'**
  String get menu_leave_anyway;

  /// No description provided for @menu_publish_exit.
  ///
  /// In en, this message translates to:
  /// **'Publish & Exit'**
  String get menu_publish_exit;

  /// No description provided for @menu_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get menu_name;

  /// No description provided for @menu_name_unique_hint.
  ///
  /// In en, this message translates to:
  /// **'Name must be unique.\nIf the name changes, the QR code must also be updated.'**
  String get menu_name_unique_hint;

  /// No description provided for @menu_resto_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your restaurant name'**
  String get menu_resto_name_hint;

  /// No description provided for @menu_name_validation.
  ///
  /// In en, this message translates to:
  /// **'Name must only contain letters, numbers, and -'**
  String get menu_name_validation;

  /// No description provided for @menu_set_name.
  ///
  /// In en, this message translates to:
  /// **'Set Name'**
  String get menu_set_name;

  /// No description provided for @menu_domain.
  ///
  /// In en, this message translates to:
  /// **'Domain'**
  String get menu_domain;

  /// No description provided for @menu_domain_hint.
  ///
  /// In en, this message translates to:
  /// **'Add your own custom domain'**
  String get menu_domain_hint;

  /// No description provided for @menu_your_domain.
  ///
  /// In en, this message translates to:
  /// **'Your Domain'**
  String get menu_your_domain;

  /// No description provided for @menu_logo.
  ///
  /// In en, this message translates to:
  /// **'Logo'**
  String get menu_logo;

  /// No description provided for @menu_logo_hint.
  ///
  /// In en, this message translates to:
  /// **'Upload your logo'**
  String get menu_logo_hint;

  /// No description provided for @menu_bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get menu_bio;

  /// No description provided for @menu_bio_hint.
  ///
  /// In en, this message translates to:
  /// **'Add a short description about your business'**
  String get menu_bio_hint;

  /// No description provided for @menu_banner.
  ///
  /// In en, this message translates to:
  /// **'Banner'**
  String get menu_banner;

  /// No description provided for @menu_banner_hint.
  ///
  /// In en, this message translates to:
  /// **'Upload your restaurant banner'**
  String get menu_banner_hint;

  /// No description provided for @menu_inner_banner.
  ///
  /// In en, this message translates to:
  /// **'Inner Banner'**
  String get menu_inner_banner;

  /// No description provided for @menu_inner_banner_hint.
  ///
  /// In en, this message translates to:
  /// **'Banner for categories and items'**
  String get menu_inner_banner_hint;

  /// No description provided for @menu_loader.
  ///
  /// In en, this message translates to:
  /// **'Loader'**
  String get menu_loader;

  /// No description provided for @menu_loader_hint.
  ///
  /// In en, this message translates to:
  /// **'Add a loading animation for better user experience'**
  String get menu_loader_hint;

  /// No description provided for @menu_offer.
  ///
  /// In en, this message translates to:
  /// **'Offer'**
  String get menu_offer;

  /// No description provided for @menu_offer_hint.
  ///
  /// In en, this message translates to:
  /// **'Add your current offers or latest news'**
  String get menu_offer_hint;

  /// No description provided for @menu_main_colors.
  ///
  /// In en, this message translates to:
  /// **'Main Colors'**
  String get menu_main_colors;

  /// No description provided for @menu_colors_hint.
  ///
  /// In en, this message translates to:
  /// **'Customize the appearance colors of your menu'**
  String get menu_colors_hint;

  /// No description provided for @menu_primary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get menu_primary;

  /// No description provided for @menu_secondary.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get menu_secondary;

  /// No description provided for @menu_title_color.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get menu_title_color;

  /// No description provided for @menu_text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get menu_text;

  /// No description provided for @menu_currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get menu_currency;

  /// No description provided for @menu_currency_input.
  ///
  /// In en, this message translates to:
  /// **'Enter currency (e.g. \$)'**
  String get menu_currency_input;

  /// No description provided for @menu_currency_hint.
  ///
  /// In en, this message translates to:
  /// **'This currency will be applied to all item prices'**
  String get menu_currency_hint;

  /// No description provided for @menu_categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get menu_categories;

  /// No description provided for @menu_categories_hint.
  ///
  /// In en, this message translates to:
  /// **'Click to view and manage categories, subcategories, and items'**
  String get menu_categories_hint;

  /// No description provided for @menu_ordering.
  ///
  /// In en, this message translates to:
  /// **'Ordering'**
  String get menu_ordering;

  /// No description provided for @menu_ordering_hint.
  ///
  /// In en, this message translates to:
  /// **'Enable online ordering'**
  String get menu_ordering_hint;

  /// No description provided for @branch_ordering_hint.
  ///
  /// In en, this message translates to:
  /// **'Order based on branch'**
  String get branch_ordering_hint;

  /// No description provided for @menu_google_account.
  ///
  /// In en, this message translates to:
  /// **'Google Account'**
  String get menu_google_account;

  /// No description provided for @menu_google_account_hint.
  ///
  /// In en, this message translates to:
  /// **'Link your business location or Google account'**
  String get menu_google_account_hint;

  /// No description provided for @menu_go_home.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get menu_go_home;

  /// No description provided for @menu_publish_success.
  ///
  /// In en, this message translates to:
  /// **'Menu published successfully'**
  String get menu_publish_success;

  /// No description provided for @menu_delete_item.
  ///
  /// In en, this message translates to:
  /// **'Delete Item?'**
  String get menu_delete_item;

  /// No description provided for @menu_delete_item_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item? This action cannot be undone.'**
  String get menu_delete_item_message;

  /// No description provided for @menu_images_used.
  ///
  /// In en, this message translates to:
  /// **'Images Used'**
  String get menu_images_used;

  /// No description provided for @menu_used.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get menu_used;

  /// No description provided for @menu_items_for.
  ///
  /// In en, this message translates to:
  /// **'Items for'**
  String get menu_items_for;

  /// No description provided for @menu_items_manage_hint.
  ///
  /// In en, this message translates to:
  /// **'View, add, and edit items'**
  String get menu_items_manage_hint;

  /// No description provided for @menu_no_items.
  ///
  /// In en, this message translates to:
  /// **'No Items Added Yet'**
  String get menu_no_items;

  /// No description provided for @menu_add_item.
  ///
  /// In en, this message translates to:
  /// **'ADD ITEM'**
  String get menu_add_item;

  /// No description provided for @menu_getting_domain_info.
  ///
  /// In en, this message translates to:
  /// **'Getting Domain Info'**
  String get menu_getting_domain_info;

  /// No description provided for @menu_adding_domain.
  ///
  /// In en, this message translates to:
  /// **'Adding Domain'**
  String get menu_adding_domain;

  /// No description provided for @menu_failed_to_add_domain.
  ///
  /// In en, this message translates to:
  /// **'Failed to add domain'**
  String get menu_failed_to_add_domain;

  /// No description provided for @menu_checking_domain_status.
  ///
  /// In en, this message translates to:
  /// **'Checking Status'**
  String get menu_checking_domain_status;

  /// No description provided for @menu_deleting_domain.
  ///
  /// In en, this message translates to:
  /// **'Deleting Domain'**
  String get menu_deleting_domain;

  /// No description provided for @menu_failed_to_load_domain.
  ///
  /// In en, this message translates to:
  /// **'Failed to load domain'**
  String get menu_failed_to_load_domain;

  /// No description provided for @menu_delete_category.
  ///
  /// In en, this message translates to:
  /// **'Delete?'**
  String get menu_delete_category;

  /// No description provided for @menu_delete_category_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this category? All subcategories and items within it will also be deleted.'**
  String get menu_delete_category_message;

  /// No description provided for @menu_categories_title.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get menu_categories_title;

  /// No description provided for @menu_categories_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Add, view, and edit categories'**
  String get menu_categories_tooltip;

  /// No description provided for @menu_category_icon_colors.
  ///
  /// In en, this message translates to:
  /// **'Category Icon Colors'**
  String get menu_category_icon_colors;

  /// No description provided for @menu_category_icon_colors_hint.
  ///
  /// In en, this message translates to:
  /// **'Choose icon colors. This applies only to icons.'**
  String get menu_category_icon_colors_hint;

  /// No description provided for @menu_close_picker.
  ///
  /// In en, this message translates to:
  /// **'Close Picker'**
  String get menu_close_picker;

  /// No description provided for @menu_open_picker.
  ///
  /// In en, this message translates to:
  /// **'Open Picker'**
  String get menu_open_picker;

  /// No description provided for @menu_category_list.
  ///
  /// In en, this message translates to:
  /// **'Category List'**
  String get menu_category_list;

  /// No description provided for @menu_no_categories.
  ///
  /// In en, this message translates to:
  /// **'No Categories Found'**
  String get menu_no_categories;

  /// No description provided for @menu_add_category.
  ///
  /// In en, this message translates to:
  /// **'ADD CATEGORY'**
  String get menu_add_category;

  /// No description provided for @menu_fonts_title.
  ///
  /// In en, this message translates to:
  /// **'Fonts'**
  String get menu_fonts_title;

  /// No description provided for @menu_fonts_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Choose your menu font family'**
  String get menu_fonts_tooltip;

  /// No description provided for @menu_add_image.
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get menu_add_image;

  /// No description provided for @menu_upload_failed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed, please try again'**
  String get menu_upload_failed;

  /// No description provided for @menu_add_category_title.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get menu_add_category_title;

  /// No description provided for @menu_edit_category_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get menu_edit_category_title;

  /// No description provided for @menu_category_name.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get menu_category_name;

  /// No description provided for @menu_replace_image.
  ///
  /// In en, this message translates to:
  /// **'Replace Image'**
  String get menu_replace_image;

  /// No description provided for @menu_image_priority_hint.
  ///
  /// In en, this message translates to:
  /// **'If both an icon and an uploaded image are set, the uploaded image will be displayed instead of the icon.'**
  String get menu_image_priority_hint;

  /// No description provided for @menu_upgrade_for_images.
  ///
  /// In en, this message translates to:
  /// **'Upgrade your plan to upload custom images'**
  String get menu_upgrade_for_images;

  /// No description provided for @menu_category_name_required.
  ///
  /// In en, this message translates to:
  /// **'Category name cannot be empty.'**
  String get menu_category_name_required;

  /// No description provided for @menu_add_close.
  ///
  /// In en, this message translates to:
  /// **'Add & Close'**
  String get menu_add_close;

  /// No description provided for @menu_save_close.
  ///
  /// In en, this message translates to:
  /// **'Save & Close'**
  String get menu_save_close;

  /// No description provided for @menu_edit.
  ///
  /// In en, this message translates to:
  /// **'EDIT'**
  String get menu_edit;

  /// No description provided for @menu_add_view_subcategories.
  ///
  /// In en, this message translates to:
  /// **'Add & View Subcategories'**
  String get menu_add_view_subcategories;

  /// No description provided for @menu_contains.
  ///
  /// In en, this message translates to:
  /// **'Contains'**
  String get menu_contains;

  /// No description provided for @menu_subcategories_count.
  ///
  /// In en, this message translates to:
  /// **'subcategorie(s)'**
  String get menu_subcategories_count;

  /// No description provided for @menu_add_your_domain.
  ///
  /// In en, this message translates to:
  /// **'Add Your Domain'**
  String get menu_add_your_domain;

  /// No description provided for @menu_domain_input_label.
  ///
  /// In en, this message translates to:
  /// **'Insert Your Domain URL'**
  String get menu_domain_input_label;

  /// No description provided for @menu_domain_input_example.
  ///
  /// In en, this message translates to:
  /// **'Example: client1.com'**
  String get menu_domain_input_example;

  /// No description provided for @menu_domain_input_hint.
  ///
  /// In en, this message translates to:
  /// **'client1.com'**
  String get menu_domain_input_hint;

  /// No description provided for @menu_add_domain.
  ///
  /// In en, this message translates to:
  /// **'Add Domain'**
  String get menu_add_domain;

  /// No description provided for @menu_delete_domain.
  ///
  /// In en, this message translates to:
  /// **'Delete This Domain'**
  String get menu_delete_domain;

  /// No description provided for @menu_delete_domain_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unlink this domain from your menu?'**
  String get menu_delete_domain_message;

  /// No description provided for @menu_check_domain_status.
  ///
  /// In en, this message translates to:
  /// **'Check Domain Status'**
  String get menu_check_domain_status;

  /// No description provided for @menu_applied_on.
  ///
  /// In en, this message translates to:
  /// **'Applied On'**
  String get menu_applied_on;

  /// No description provided for @menu_url_copied.
  ///
  /// In en, this message translates to:
  /// **'URL copied to clipboard'**
  String get menu_url_copied;

  /// No description provided for @menu_nameservers_title.
  ///
  /// In en, this message translates to:
  /// **'NameServers to Add:'**
  String get menu_nameservers_title;

  /// No description provided for @menu_ns1_copied.
  ///
  /// In en, this message translates to:
  /// **'Primary nameserver (NS1) copied to clipboard'**
  String get menu_ns1_copied;

  /// No description provided for @menu_ns2_copied.
  ///
  /// In en, this message translates to:
  /// **'Secondary nameserver (NS2) copied to clipboard'**
  String get menu_ns2_copied;

  /// No description provided for @menu_check_domain.
  ///
  /// In en, this message translates to:
  /// **'Check Domain'**
  String get menu_check_domain;

  /// No description provided for @menu_add_subcategory_title.
  ///
  /// In en, this message translates to:
  /// **'Add Subcategory'**
  String get menu_add_subcategory_title;

  /// No description provided for @menu_edit_subcategory_title.
  ///
  /// In en, this message translates to:
  /// **'Edit Subcategory'**
  String get menu_edit_subcategory_title;

  /// No description provided for @menu_subcategory_name.
  ///
  /// In en, this message translates to:
  /// **'Subcategory Name'**
  String get menu_subcategory_name;

  /// No description provided for @menu_subcategory_name_required.
  ///
  /// In en, this message translates to:
  /// **'Subcategory name cannot be empty.'**
  String get menu_subcategory_name_required;

  /// No description provided for @menu_add_view_items.
  ///
  /// In en, this message translates to:
  /// **'Add & View Items'**
  String get menu_add_view_items;

  /// No description provided for @menu_items_count.
  ///
  /// In en, this message translates to:
  /// **'item(s)'**
  String get menu_items_count;

  /// No description provided for @menu_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get menu_phone_number;

  /// No description provided for @menu_tap_link_copy.
  ///
  /// In en, this message translates to:
  /// **'Tap link to copy'**
  String get menu_tap_link_copy;

  /// No description provided for @menu_link_copied.
  ///
  /// In en, this message translates to:
  /// **'Menu link copied to clipboard!'**
  String get menu_link_copied;

  /// No description provided for @menu_publish.
  ///
  /// In en, this message translates to:
  /// **'PUBLISH'**
  String get menu_publish;

  /// No description provided for @menu_change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get menu_change;

  /// No description provided for @menu_pick_color.
  ///
  /// In en, this message translates to:
  /// **'Pick a color:'**
  String get menu_pick_color;

  /// No description provided for @menu_day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get menu_day;

  /// No description provided for @menu_clicks.
  ///
  /// In en, this message translates to:
  /// **'Clicks'**
  String get menu_clicks;

  /// No description provided for @menu_year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get menu_year;

  /// No description provided for @menu_analytics_title.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get menu_analytics_title;

  /// No description provided for @menu_analytics_tooltip.
  ///
  /// In en, this message translates to:
  /// **'View insights and performance data for your menu'**
  String get menu_analytics_tooltip;

  /// No description provided for @menu_go_pro_to_unlock.
  ///
  /// In en, this message translates to:
  /// **'Go Pro to Unlock'**
  String get menu_go_pro_to_unlock;

  /// No description provided for @menu_go_premium_to_unlock.
  ///
  /// In en, this message translates to:
  /// **'Go Premium to Unlock'**
  String get menu_go_premium_to_unlock;

  /// No description provided for @menu_animation_title.
  ///
  /// In en, this message translates to:
  /// **'Animation'**
  String get menu_animation_title;

  /// No description provided for @menu_animation_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Choose how your menu opens with an animation pattern'**
  String get menu_animation_tooltip;

  /// No description provided for @menu_food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get menu_food;

  /// No description provided for @menu_new_branch.
  ///
  /// In en, this message translates to:
  /// **'NEW BRANCH'**
  String get menu_new_branch;

  /// No description provided for @menu_branch_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter branch name'**
  String get menu_branch_name_hint;

  /// No description provided for @menu_field_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get menu_field_required;

  /// No description provided for @menu_branch_link_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter branch link'**
  String get menu_branch_link_hint;

  /// No description provided for @menu_add_branch.
  ///
  /// In en, this message translates to:
  /// **'Add Branch'**
  String get menu_add_branch;

  /// No description provided for @menu_country_branches_title.
  ///
  /// In en, this message translates to:
  /// **'COUNTRY BRANCHES'**
  String get menu_country_branches_title;

  /// No description provided for @menu_country_branches_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Manage your restaurant branches by country and add location links'**
  String get menu_country_branches_tooltip;

  /// No description provided for @menu_adding_new_country.
  ///
  /// In en, this message translates to:
  /// **'Adding New Country'**
  String get menu_adding_new_country;

  /// No description provided for @menu_add_new_country.
  ///
  /// In en, this message translates to:
  /// **'Add New Country'**
  String get menu_add_new_country;

  /// No description provided for @menu_adding_branch.
  ///
  /// In en, this message translates to:
  /// **'Adding a Branch'**
  String get menu_adding_branch;

  /// No description provided for @menu_country.
  ///
  /// In en, this message translates to:
  /// **'COUNTRY'**
  String get menu_country;

  /// No description provided for @menu_country_name.
  ///
  /// In en, this message translates to:
  /// **'COUNTRY NAME'**
  String get menu_country_name;

  /// No description provided for @menu_add_country.
  ///
  /// In en, this message translates to:
  /// **'Add Country'**
  String get menu_add_country;

  /// No description provided for @menu_add_review.
  ///
  /// In en, this message translates to:
  /// **'Add Your Review'**
  String get menu_add_review;

  /// No description provided for @menu_write_review_hint.
  ///
  /// In en, this message translates to:
  /// **'Write a review (optional)'**
  String get menu_write_review_hint;

  /// No description provided for @menu_preview_notice.
  ///
  /// In en, this message translates to:
  /// **'This is only a preview'**
  String get menu_preview_notice;

  /// No description provided for @menu_send_review.
  ///
  /// In en, this message translates to:
  /// **'Send Review'**
  String get menu_send_review;

  /// No description provided for @menu_feedbacks_title.
  ///
  /// In en, this message translates to:
  /// **'FEEDBACKS'**
  String get menu_feedbacks_title;

  /// No description provided for @menu_feedbacks_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Collect and manage customer reviews'**
  String get menu_feedbacks_tooltip;

  /// No description provided for @menu_select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get menu_select_language;

  /// No description provided for @menu_language_required.
  ///
  /// In en, this message translates to:
  /// **'Please fill language field'**
  String get menu_language_required;

  /// No description provided for @menu_add_language.
  ///
  /// In en, this message translates to:
  /// **'Add Language'**
  String get menu_add_language;

  /// No description provided for @menu_languages_title.
  ///
  /// In en, this message translates to:
  /// **'LANGUAGES'**
  String get menu_languages_title;

  /// No description provided for @menu_languages_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Premium plans support up to 6 languages'**
  String get menu_languages_tooltip;

  /// No description provided for @menu_main_language_locked.
  ///
  /// In en, this message translates to:
  /// **'Main language cannot be deleted or deactivated'**
  String get menu_main_language_locked;

  /// No description provided for @menu_open_close_hours_title.
  ///
  /// In en, this message translates to:
  /// **'OPEN / CLOSE HOURS'**
  String get menu_open_close_hours_title;

  /// No description provided for @menu_open_close_hours_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Set your opening and closing hours so customers know when they can place orders'**
  String get menu_open_close_hours_tooltip;

  /// No description provided for @menu_from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get menu_from;

  /// No description provided for @menu_to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get menu_to;

  /// No description provided for @menu_opening_time_for.
  ///
  /// In en, this message translates to:
  /// **'Opening Time For'**
  String get menu_opening_time_for;

  /// No description provided for @menu_closing_time_for.
  ///
  /// In en, this message translates to:
  /// **'Closing Time For'**
  String get menu_closing_time_for;

  /// No description provided for @menu_social_media_title.
  ///
  /// In en, this message translates to:
  /// **'Social Media'**
  String get menu_social_media_title;

  /// No description provided for @menu_social_media_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Add your social media links'**
  String get menu_social_media_tooltip;

  /// No description provided for @menu_add_link.
  ///
  /// In en, this message translates to:
  /// **'ADD LINK'**
  String get menu_add_link;

  /// No description provided for @menu_social_media_validation_hint.
  ///
  /// In en, this message translates to:
  /// **'Please make sure to insert an icon and its URL'**
  String get menu_social_media_validation_hint;

  /// No description provided for @menu_link_url.
  ///
  /// In en, this message translates to:
  /// **'LINK URL'**
  String get menu_link_url;

  /// No description provided for @menu_media_url_required.
  ///
  /// In en, this message translates to:
  /// **'Please fill media URL'**
  String get menu_media_url_required;

  /// No description provided for @menu_save_media.
  ///
  /// In en, this message translates to:
  /// **'Save Media'**
  String get menu_save_media;

  /// No description provided for @menu_badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get menu_badges;

  /// No description provided for @menu_new_item.
  ///
  /// In en, this message translates to:
  /// **'New Item'**
  String get menu_new_item;

  /// No description provided for @menu_add_percentage_value.
  ///
  /// In en, this message translates to:
  /// **'Add % value'**
  String get menu_add_percentage_value;

  /// No description provided for @menu_image_carousel.
  ///
  /// In en, this message translates to:
  /// **'Image carousel'**
  String get menu_image_carousel;

  /// No description provided for @menu_images.
  ///
  /// In en, this message translates to:
  /// **'Image(s)'**
  String get menu_images;

  /// No description provided for @menu_prices.
  ///
  /// In en, this message translates to:
  /// **'Price(s)'**
  String get menu_prices;

  /// No description provided for @menu_types.
  ///
  /// In en, this message translates to:
  /// **'Type(s)'**
  String get menu_types;

  /// No description provided for @menu_cannot_leave_empty_fields.
  ///
  /// In en, this message translates to:
  /// **'Fields cannot be left empty'**
  String get menu_cannot_leave_empty_fields;

  /// No description provided for @menu_enter_price_label.
  ///
  /// In en, this message translates to:
  /// **'Enter price label'**
  String get menu_enter_price_label;

  /// No description provided for @menu_enter_price_amount.
  ///
  /// In en, this message translates to:
  /// **'Enter price amount'**
  String get menu_enter_price_amount;

  /// No description provided for @menu_add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get menu_add;

  /// No description provided for @menu_edit_s.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get menu_edit_s;

  /// No description provided for @menu_item_images_overflow_warning.
  ///
  /// In en, this message translates to:
  /// **'This item contains images that exceed the allowed counter limit'**
  String get menu_item_images_overflow_warning;

  /// No description provided for @menu_item_active.
  ///
  /// In en, this message translates to:
  /// **'Item Active'**
  String get menu_item_active;

  /// No description provided for @menu_item_inactive.
  ///
  /// In en, this message translates to:
  /// **'Item Inactive'**
  String get menu_item_inactive;

  /// No description provided for @menu_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get menu_active;

  /// No description provided for @menu_inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get menu_inactive;

  /// No description provided for @menu_new.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get menu_new;

  /// No description provided for @menu_offer_b.
  ///
  /// In en, this message translates to:
  /// **'OFFER'**
  String get menu_offer_b;

  /// No description provided for @menu_item_required_fields.
  ///
  /// In en, this message translates to:
  /// **'Item name, description, and price must not be empty'**
  String get menu_item_required_fields;

  /// No description provided for @menu_add_item_s.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get menu_add_item_s;

  /// No description provided for @menu_edit_item.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get menu_edit_item;

  /// No description provided for @menu_item_order.
  ///
  /// In en, this message translates to:
  /// **'Item Order'**
  String get menu_item_order;

  /// No description provided for @menu_title_cannot_be_empty.
  ///
  /// In en, this message translates to:
  /// **'Title cannot be empty'**
  String get menu_title_cannot_be_empty;

  /// No description provided for @menu_enter_type.
  ///
  /// In en, this message translates to:
  /// **'Enter type'**
  String get menu_enter_type;

  /// No description provided for @menu_background.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get menu_background;

  /// No description provided for @menu_add_type.
  ///
  /// In en, this message translates to:
  /// **'Add Type'**
  String get menu_add_type;

  /// No description provided for @menu_edit_type.
  ///
  /// In en, this message translates to:
  /// **'Edit Type'**
  String get menu_edit_type;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
