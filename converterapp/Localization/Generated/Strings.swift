// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Strings {

  internal enum AccountDetails {
    /// Edit
    internal static let edit = Strings.tr("Localizable", "AccountDetails.Edit")
    /// Transactions
    internal static let transactions = Strings.tr("Localizable", "AccountDetails.Transactions")
  }

  internal enum Accounts {
    /// Add first account
    internal static let addAccount = Strings.tr("Localizable", "Accounts.addAccount")
    /// Account
    internal static let contextMenuTitle = Strings.tr("Localizable", "Accounts.contextMenuTitle")
    /// Edit
    internal static let editAccount = Strings.tr("Localizable", "Accounts.editAccount")
    /// Remove
    internal static let removeAccount = Strings.tr("Localizable", "Accounts.removeAccount")
    /// Show
    internal static let showAccount = Strings.tr("Localizable", "Accounts.showAccount")
  }

  internal enum AddAccounts {
    /// Currency
    internal static let accountCurrency = Strings.tr("Localizable", "AddAccounts.AccountCurrency")
    /// Account Name
    internal static let accountName = Strings.tr("Localizable", "AddAccounts.AccountName")
    /// Done
    internal static let done = Strings.tr("Localizable", "AddAccounts.Done")
    /// Save
    internal static let save = Strings.tr("Localizable", "AddAccounts.Save")
  }

  internal enum AddTransaction {
    /// Amount
    internal static let amount = Strings.tr("Localizable", "AddTransaction.Amount")
    /// Date
    internal static let date = Strings.tr("Localizable", "AddTransaction.Date")
    /// Dismiss
    internal static let dismiss = Strings.tr("Localizable", "AddTransaction.Dismiss")
    /// Enter valid amount.
    internal static let invalidAmount = Strings.tr("Localizable", "AddTransaction.InvalidAmount")
    /// Enter valid name.
    internal static let invalidName = Strings.tr("Localizable", "AddTransaction.InvalidName")
    /// Name
    internal static let name = Strings.tr("Localizable", "AddTransaction.Name")
  }

  internal enum Converter {
    /// Converter
    internal static let title = Strings.tr("Localizable", "Converter.Title")
  }

  internal enum CurrencyDetails {
    /// 1 Month
    internal static let _1Month = Strings.tr("Localizable", "CurrencyDetails.1Month")
    /// 6 Months
    internal static let _6Months = Strings.tr("Localizable", "CurrencyDetails.6Months")
    /// 7 Days
    internal static let _7Days = Strings.tr("Localizable", "CurrencyDetails.7Days")
    /// 1 Year
    internal static let year = Strings.tr("Localizable", "CurrencyDetails.Year")
  }

  internal enum FavouriteCurrencies {
    /// All Currencies
    internal static let allCurrencies = Strings.tr("Localizable", "FavouriteCurrencies.AllCurrencies")
    /// Currencies
    internal static let currencies = Strings.tr("Localizable", "FavouriteCurrencies.Currencies")
    /// Done
    internal static let done = Strings.tr("Localizable", "FavouriteCurrencies.Done")
    /// Favourite Currencies
    internal static let favouriteCurrencies = Strings.tr("Localizable", "FavouriteCurrencies.FavouriteCurrencies")
    /// Search Currencies
    internal static let searchCurrencies = Strings.tr("Localizable", "FavouriteCurrencies.SearchCurrencies")
  }

  internal enum Main {
    /// Accounts
    internal static let accounts = Strings.tr("Localizable", "Main.accounts")
    /// Converter
    internal static let converter = Strings.tr("Localizable", "Main.converter")
    /// Rates
    internal static let rates = Strings.tr("Localizable", "Main.rates")
  }

  internal enum Rates {
    /// Currency rates
    internal static let title = Strings.tr("Localizable", "Rates.Title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
