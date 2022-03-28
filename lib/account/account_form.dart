import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mono/account/account_form_viewmodel.dart';
import 'package:mono/account/validators.dart';
import 'package:mono/data/account/account_data.dart';
import 'package:mono/utils/date_utils.dart';

class AccountForm extends StatefulWidget {
  final AccountFormViewModel viewModel = GetIt.I();

  AccountForm({Key? key}) : super(key: key);

  @override
  _AccountFormState createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  late AccountData _accountData;
  late AccountFormState _formState;

  @override
  void initState() {
    _formState = widget.viewModel.getFormState();
    _accountData = widget.viewModel.getAccountData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final AppLocalizations _local = AppLocalizations.of(context)!;

    final _appBarActions = List<Widget>.empty(growable: true);
    if (_formState == AccountFormState.locked) {
      _appBarActions.addAll([
        IconButton(
          onPressed: () => _onDeleteDataClicked(context),
          icon: const Icon(Icons.delete_outline),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _formState = AccountFormState.edit;
            });
          },
          icon: const Icon(Icons.edit_outlined),
        )
      ]);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.accountFormTitle),
        actions: _appBarActions,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AccountTextFormField(
                        enabled: _formState == AccountFormState.edit,
                        initialValue: _accountData.firstName,
                        onSaved: (value) => _accountData.firstName = value,
                        labelText: _local.accountFormFirstNameLabel,
                        validationErrorText: _local.accountFormFirstNameError,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: AccountTextFormField(
                        enabled: _formState == AccountFormState.edit,
                        initialValue: _accountData.lastName,
                        onSaved: (value) => _accountData.lastName = value,
                        labelText: _local.accountFormLastNameLabel,
                        validationErrorText: _local.accountFormLastNameError,
                      ),
                    ),
                  ],
                ),
                AccountTextFormField(
                  enabled: _formState == AccountFormState.edit,
                  initialValue: _accountData.streetAndHousenumber,
                  onSaved: (value) => _accountData.streetAndHousenumber = value,
                  labelText: _local.accountFormStreetLabel,
                  validationErrorText: _local.accountFormStreetError,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AccountTextFormField(
                        enabled: _formState == AccountFormState.edit,
                        initialValue: _accountData.postalCode,
                        onSaved: (value) => _accountData.postalCode = value,
                        textInputType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          LengthLimitingTextInputFormatter(5),
                        ],
                        labelText: _local.accountFormPostalCodeLabel,
                        validationErrorText: _local.accountFormPostalCodeError,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: AccountTextFormField(
                        enabled: _formState == AccountFormState.edit,
                        initialValue: _accountData.city,
                        onSaved: (value) => _accountData.city = value,
                        labelText: _local.accountFormCityLabel,
                        validationErrorText: _local.accountFormCityError,
                      ),
                    ),
                  ],
                ),
                AccountTextFormField(
                  enabled: _formState == AccountFormState.edit,
                  initialValue: _accountData.mail,
                  onSaved: (value) => _accountData.mail = value,
                  validator: const MailValidator(),
                  labelText: _local.accountFormMailLabel,
                  textCapitalization: TextCapitalization.none,
                  textInputType: TextInputType.emailAddress,
                  validationErrorText: _local.accountFormMailError,
                ),
                AccountTextFormField(
                  enabled: _formState == AccountFormState.edit,
                  initialValue: _accountData.phoneNumber,
                  onSaved: (value) => _accountData.phoneNumber = value,
                  labelText: _local.accountFormPhoneLabel,
                  textInputType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  validationErrorText: _local.accountFormPhoneError,
                ),
                AccountTextFormField(
                  enabled: _formState == AccountFormState.edit,
                  initialValue: _accountData.dateOfBirth,
                  onSaved: (value) => _accountData.dateOfBirth = value,
                  hintText: _local.accountFormDateOfBirthHint,
                  labelText: _local.accountFormDateOfBirthLabel,
                  validator: DateOfBirthValidator(),
                  textInputType: TextInputType.datetime,
                  textInputAction: TextInputAction.done,
                  validationErrorText: _local.accountFormDateOfBirthError,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    DateTextFormatter(),
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
                const SizedBox(height: 8),
                Visibility(
                  visible: _formState == AccountFormState.edit,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: widget.viewModel.hasAnyData(),
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _formState = AccountFormState.locked;
                            });
                          },
                          child: Text(_local.accountFormButtonCancel),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            await widget.viewModel.setAccountData(_accountData);
                            setState(() {
                              _formState = AccountFormState.locked;
                              _accountData = widget.viewModel.getAccountData();
                            });
                          }
                        },
                        child: Text(_local.accountFormButtonSave),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onDeleteDataClicked(BuildContext context) {
    final AppLocalizations _local = GetIt.I();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(_local.accountFormDeleteDialogTitle),
          content: Text(_local.accountFormDeleteDialogDescription),
          actions: [
            TextButton(
              child: Text(_local.accountFormDeleteDialogButtonCancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(_local.accountFormDeleteDialogButtonOk),
              onPressed: () async {
                Navigator.of(context).pop();
                await widget.viewModel.deleteAccountData();
                setState(() {
                  _accountData = widget.viewModel.getAccountData();
                });
              },
            ),
          ],
        );
      },
    );
  }
}

class AccountTextFormField extends StatelessWidget {
  final bool enabled;
  final String labelText;
  final String? hintText;
  final String? initialValue;
  final String validationErrorText;
  final StringValidator validator;
  final FormFieldSetter<String>? onSaved;
  final TextInputAction textInputAction;
  final TextInputType? textInputType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;

  const AccountTextFormField({
    Key? key,
    required this.onSaved,
    required this.labelText,
    required this.validationErrorText,
    this.hintText,
    this.initialValue,
    this.textInputType,
    this.inputFormatters,
    this.enabled = true,
    this.validator = const NotEmptyValidator(),
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.words,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        inputFormatters: inputFormatters,
        enabled: enabled,
        initialValue: initialValue,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization,
        keyboardType: textInputType,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
          hintText: hintText,
        ),
        validator: (value) {
          FocusScope.of(context).unfocus();
          if (validator.validate(value)) {
            return null;
          }
          return validationErrorText;
        },
        onSaved: onSaved,
      ),
    );
  }
}
