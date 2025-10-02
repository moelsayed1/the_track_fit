import json

# Additional missing translations not yet in the file
missing_en = {
    'warning': 'Warning',
    'testNotification': 'Test Notification',
    'failedToLoadMainGoalOptions': 'Failed to load main goal options',
    'mainGoalUpdatedSuccessfully': 'Main goal updated successfully!',
    'failedToUpdateMainGoal': 'Failed to update main goal',
    'errorPickingImage': 'Error picking image',
    'couponAppliedSuccessfully': 'Coupon applied successfully!',
    'exerciseSubtitle': 'Exercise subtitle',
    'exerciseType': 'Exercise type'
}

# Read current file
with open('lib/l10n/app_en.arb', 'r', encoding='utf-8') as f:
    data = json.load(f)

# Add missing translations
data.update(missing_en)

# Write back
with open('lib/l10n/app_en.arb', 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print('English translations updated successfully!')
print(f'Total translations: {len(data)}')
