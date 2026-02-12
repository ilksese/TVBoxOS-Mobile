# AGENTS.md - TVBoxOS-Mobile Development Guide

## Quick Reference

**Language**: Mixed Java/Kotlin Android app  
**Package**: `com.github.tvbox.osc`  
**Gradle**: 8.7 | AGP: 8.4.0 | Kotlin: 1.9.22  
**SDK**: Min 24, Target 30, Compile 33 | Java 21

## Build Commands

```bash
# Build APKs (automated script with keystore handling)
./build.sh         # Mac/Linux
build.bat          # Windows

# Standard builds
./gradlew assembleDebug
./gradlew assembleRelease
./gradlew clean build

# Module-specific
./gradlew :app:assembleDebug
./gradlew installDebug

# Diagnostics
./gradlew tasks
./gradlew dependencies
./gradlew assembleDebug --stacktrace
```

**Output**: `app/build/outputs/apk/{debug|release}/MBox_v*.apk`

## Lint & Test Commands

```bash
# Lint
./gradlew lint
./gradlew lintDebug
./gradlew lintFix

# Unit tests (all variants)
./gradlew test
./gradlew testDebugUnitTest

# Single test class
./gradlew test --tests "com.github.tvbox.osc.util.ClassName"

# Single test method
./gradlew test --tests "com.github.tvbox.osc.util.ClassName.methodName"

# Instrumented tests (requires device/emulator)
./gradlew connectedAndroidTest
./gradlew connectedDebugAndroidTest
./gradlew connectedAndroidTest --tests "com.github.tvbox.osc.TestClassName"
```

## Project Structure

```
app/src/main/java/com/github/tvbox/osc/
├── api/           API configuration & sources
├── base/          BaseActivity, BaseVbActivity, BaseVbFragment
├── bean/          Data models (Java POJOs, Kotlin data classes)
├── cache/         Room database entities & DAOs
├── ui/
│   ├── activity/  Activities (mixed Java/Kotlin)
│   ├── fragment/  Fragments
│   ├── adapter/   RecyclerView adapters
│   ├── dialog/    Dialog implementations
│   └── widget/    Custom views
└── util/          Utility classes

Modules: player/, quickjs/, TabLayout/, ViewPager1Delegate/, crash/
```

## Code Style

### Naming Conventions

- **Classes**: PascalCase (`MainActivity`, `DoubanSuggestBean`)
- **Functions/Variables**: camelCase (`initData()`, `mBinding`, `tabIndex`)
- **Constants**: UPPER_SNAKE_CASE in companion object
- **Packages**: lowercase (`com.github.tvbox.osc.ui.activity`)

### Kotlin Patterns

**ViewBinding Activities/Fragments:**
```kotlin
class MainActivity : BaseVbActivity<ActivityMainBinding>() {
    override fun init() {
        mBinding.vp.adapter = // access binding via mBinding
    }
}
```

**Data Classes:**
```kotlin
data class DoubanSuggestBean(
    var id: String,
    var title: String,
) {
    var doubanRating: String? = null
        get() = field ?: ""  // custom getter with default
}
```

**Null Safety:**
- Use `?` for nullable types
- Use `?.` for safe calls, `?.let {}` for null scopes
- Use `?:` for defaults, `lateinit` for guaranteed-init properties

**Coroutines:**
```kotlin
lifecycleScope.launch {
    withContext(Dispatchers.IO) { /* blocking work */ }
    withContext(Dispatchers.Main) { /* UI updates */ }
}
```

### Java Patterns

**Activities:** Extend `BaseActivity`, override `getLayoutResID()` or use ViewBinding via subclass  
**Data Beans:** Use POJOs with XStream annotations for XML/JSON parsing  
**Async:** Callback interfaces, EventBus for cross-component communication

### Import Organization

1. Android framework (`android.*`, `androidx.*`)
2. Third-party libraries (`com.google.*`, `com.squareup.*`)
3. Project imports (`com.github.tvbox.osc.*`)

Group by package, alphabetically sorted.

### XML Resources

**Layouts:**
- IDs: snake_case for ViewBinding
- Prefixes: `activity_*`, `fragment_*`, `dialog_*`, `item_*`

**Drawables:**
- Prefixes: `shape_*`, `selector_*`, `bg_*`
- Prefer vector drawables

**Values:**
- Extract strings to `strings.xml` (Chinese & English)
- Dimensions to `dimens.xml`
- Colors to `colors.xml`

### Error Handling

- `try-catch` for exceptions
- Callback interfaces for async results
- `ToastUtils.showShort()` / `XPopup` for user feedback
- `e.printStackTrace()` for debugging (avoid in production)

## Key Libraries

| Category | Library | Version |
|----------|---------|---------|
| Network | OkHttp | 3.12.11 |
| Image | Glide, Picasso | 4.12.0, 2.71828 |
| Database | Room | 2.3.0 |
| JSON | Gson, XStream | 2.8.7, 1.4.15 |
| UI | Material, Lottie | 1.4.0, 5.2.0 |
| Utils | UtilCodeX, Hawk | 1.31.0, 2.0.1 |
| Permissions | XXPermissions | 13.6 |
| HTML | JSoup | 1.14.1 |
| Events | EventBus | 3.2.0 |

## Common Tasks

**New Activity:** Extend `BaseVbActivity<ActivityXxxBinding>`, override `init()`  
**New Fragment:** Extend `BaseVbFragment<FragmentXxxBinding>`, override `init()`  
**New Dialog:** Use `XPopup.Builder()` or extend dialog classes  
**Navigation:** Use `jumpActivity()` helper  
**Loading States:** Use `setLoadSir()` with LoadSir callbacks

## Notes

- **MultiDex** enabled (large app)
- **Room schemas** exported to `app/schemas/`
- **Signing**: Uses `TVBoxOSC.jks` (copied by build scripts)
- **APK naming**: `MBox_v{version}_{buildType}_{date}.apk`
- **Comments**: Chinese & English mixed
- **EventBus**: Activities auto-register in `BaseActivity.onCreate()`
- **ImmersionBar**: Status bar theming in base classes
