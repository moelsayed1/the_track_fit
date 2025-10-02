import os
import re

# Files to update with their hardcoded text replacements
updates = {
    'lib/features/questions/gender_question/presentation/widgets/gender_screen_body.dart': [
        ("'What\\'s your gender ?'", "AppLocalizations.of(context)!.whatsYourGender"),
        ("'Female'", "AppLocalizations.of(context)!.female"),
        ("'Male'", "AppLocalizations.of(context)!.male"),
        ("'Let\\'s Set Up Your Plan'", "AppLocalizations.of(context)!.letsSetUpYourPlan"),
    ],
    'lib/features/auth/login/presentation/screens/login_screen.dart': [
        ("'Email'", "AppLocalizations.of(context)!.emailPlaceholder"),
        ("'Password'", "AppLocalizations.of(context)!.passwordPlaceholder"),
        ("'Forget Password ?'", "AppLocalizations.of(context)!.forgetPassword"),
    ],
    'lib/features/profile/presentation/widgets/change_password_profile.dart': [
        ("'New Password'", "AppLocalizations.of(context)!.newPasswordPlaceholder"),
        ("'Confirm Password'", "AppLocalizations.of(context)!.confirmPasswordPlaceholder"),
        ("'Current Password'", "AppLocalizations.of(context)!.currentPasswordPlaceholder"),
    ],
}

# Add localization import if not present
def add_import(content):
    if 'AppLocalizations' not in content:
        # Find the last import statement
        import_match = re.findall(r"import '[^']+';", content)
        if import_match:
            last_import = import_match[-1]
            content = content.replace(last_import, 
                last_import + "\\nimport '../../../../../generated/l10n/app_localizations.dart';")
    return content

# Process each file
for filepath, replacements in updates.items():
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Add import
        content = add_import(content)
        
        # Apply replacements
        for old, new in replacements:
            content = content.replace(old, new)
        
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        
        print(f'Updated: {filepath}')
    except Exception as e:
        print(f'Error updating {filepath}: {e}')

print('\\nAll files updated!')
