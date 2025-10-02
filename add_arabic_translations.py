import json

# Arabic translations for the missing keys
missing_ar = {
    'warning': 'تحذير',
    'testNotification': 'إشعار تجريبي',
    'failedToLoadMainGoalOptions': 'فشل في تحميل خيارات الهدف الرئيسي',
    'mainGoalUpdatedSuccessfully': 'تم تحديث الهدف الرئيسي بنجاح!',
    'failedToUpdateMainGoal': 'فشل في تحديث الهدف الرئيسي',
    'errorPickingImage': 'خطأ في اختيار الصورة',
    'couponAppliedSuccessfully': 'تم تطبيق الكوبون بنجاح!',
    'exerciseSubtitle': 'وصف التمرين',
    'exerciseType': 'نوع التمرين'
}

# Read current Arabic file
with open('lib/l10n/app_ar.arb', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Add missing translations
data.update(missing_ar)

# Write back
with open('lib/l10n/app_ar.arb', 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print('Arabic translations updated successfully!')
print(f'Total translations: {len(data)}')
