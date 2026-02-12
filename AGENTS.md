# AGENTS.md - TVBoxOS-Mobile Development Guidelines
Implement basic authentication with Supabase. use library /supabase/supabase for API and docs.
## Build Commands

```bash
# Debug build
./gradlew assembleDebug

# Release build
./gradlew assembleRelease

# Clean build
./gradlew clean

# Build all modules
./gradlew build

# Lint check
./gradlew lint

# Run lint with specific variant
./gradlew lintDebug

# Build specific module
./gradlew :app:assembleDebug

# Install to connected device/emulator
./gradlew installDebug

# View dependencies
./gradlew dependencies

# Debug build with logging
./gradlew assembleDebug --stacktrace

# Find help
./gradlew tasks
```

## Build Scripts

Use the cross-platform build scripts for a complete build workflow (copy keystore → build → cleanup).

### Quick Start

**Windows:**
```cmd
build.bat
```

**Mac/Linux:**
```bash
chmod +x build.sh
./build.sh
```

### Build Outputs

| Variant | Location |
|---------|----------|
| Debug | `app/build/outputs/apk/debug/MBox_v*.apk` |
| Release | `app/build/outputs/apk/release/MBox_v*.apk` |

### How It Works

1. Copies `TVBoxOSC.jks` from `../MBox-Build/DIY/` to `app/`
2. Builds Debug APK
3. Builds Release APK
4. Deletes the keystore file (security)

### Requirements

- Parent directory contains `MBox-Build` repository with signing key
- JDK 21+, Android SDK, Gradle 8.7+

## Test Commands

```bash
# Run unit tests
./gradlew test

# Run specific test class
./gradlew test --tests "com.github.tvbox.osc.util.TestClassName"

# Run tests with specific method
./gradlew test --tests "com.github.tvbox.osc.util.TestClassName.testMethod"

# Run Android instrumented tests
./gradlew connectedAndroidTest

# Run specific instrumented test
./gradlew connectedAndroidTest --tests "com.github.tvbox.osc.TestClassName"
```

## Project Structure

```
TVBoxOS-Mobile/
├── app/                    # Main application module
│   ├── src/main/java/com/github/tvbox/osc/
│   │   ├── api/           # API configuration
│   │   ├── base/          # Base classes (BaseActivity, BaseVbActivity, BaseVbFragment)
│   │   ├── bean/          # Data classes/beans
│   │   ├── cache/         # Room database management
│   │   ├── constant/      # Constants
│   │   ├── receiver/      # Broadcast receivers
│   │   ├── server/        # Local server
│   │   ├── ui/
│   │   │   ├── activity/  # Activities
│   │   │   ├── adapter/   # RecyclerView adapters
│   │   │   ├── dialog/    # Dialogs
│   │   │   ├── fragment/  # Fragments
│   │   │   └── widget/    # Custom views
│   │   └── util/          # Utility classes
│   └── src/main/res/      # Resources (layout, values, drawable, etc.)
├── player/                 # Video player module
├── quickjs/               # JavaScript engine module
├── TabLayout/             # Custom TabLayout module
├── ViewPager1Delegate/   # ViewPager delegate module
├── crash/                # Crash handling module
├── build.gradle           # Root build configuration
└── settings.gradle        # Project settings
```

## Code Style Guidelines

### Kotlin Conventions

1. **Naming Conventions**
   - Classes: PascalCase (`MainActivity`, `HomeFragment`, `DoubanSuggestBean`)
   - Functions/variables: camelCase (`initData()`, `mBinding`, `tabIndex`)
   - Constants: UPPER_SNAKE_CASE in companion object
   - Package: lowercase (`com.github.tvbox.osc.ui.activity`)

2. **ViewBinding Usage**
   - Use `BaseVbActivity<T : ViewBinding>` for activities with ViewBinding
   - Use `BaseVbFragment<T : ViewBinding>` for fragments with ViewBinding
   - Access binding via `mBinding` property (lateinit)
   - Example: `mBinding.vp.adapter`, `mBinding.bottomNav`

3. **Activity/Fragment Patterns**
   - Activities extend `BaseVbActivity<ActivityBinding>`
   - Fragments extend `BaseVbFragment<FragmentBinding>`
   - Override `init()` for initialization logic
   - Use `jumpActivity()` helper for navigation
   - Use `setLoadSir()` for loading states

4. **Imports Organization**
   - Android framework imports first
   - Third-party library imports next
   - Project imports last
   - Group by package, alphabetically sorted within groups

5. **Data Classes (Beans)**
   - Use `data class` for domain models
   - Primary constructor properties first
   - Nullable properties with default null values
   - Custom getters for computed properties when needed

6. **Null Safety**
   - Use nullable types (`?`) for potentially null values
   - Use `?.` for safe calls
   - Use `?.let {}` for null checks with scope
   - Use `?:` for default values
   - Use `lateinit` for ViewBinding (guaranteed initialized before use)

7. **Error Handling**
   - Use try-catch for operations that may throw
   - Use callback interfaces for async operations
   - Show user feedback with ToastUtils/XPopup
   - Log errors with `e.printStackTrace()` for debugging

8. **Coroutines**
   - Use `lifecycleScope.launch` for coroutine lifecycle management
   - Use `withContext(Dispatchers.IO)` for blocking IO operations
   - Use `Dispatchers.Main` for UI operations

### XML Resources

1. **Layout Files**
   - Use ViewBinding-compatible IDs (snake_case)
   - Prefix activity layouts with `activity_`
   - Prefix fragment layouts with `fragment_`
   - Prefix dialog layouts with `dialog_`
   - Prefix item layouts with `item_`

2. **Values Resources**
   - `colors.xml`: Primary, accent, background colors
   - `strings.xml`: All user-facing strings
   - `styles.xml`: Theme and widget styles
   - `dimens.xml`: Dimension values for consistent spacing
   - `attrs.xml`: Custom view attributes

3. **Drawables**
   - Use vector drawables where possible
   - Prefix shape drawables with `shape_`
   - Prefix selector drawables with `selector_`
   - Prefix background drawables with `bg_`

### Module Dependencies

- `player/`: Video playback functionality
- `quickjs/`: JavaScript engine
- `TabLayout/`: Custom tab layout (angcyo library)
- `ViewPager1Delegate/`: ViewPager delegation
- `crash/`: Crash reporting

### Key Libraries

- **Networking**: OkHttp 3.12.11
- **Image Loading**: Glide 4.12.0, Picasso 2.71828
- **Database**: Room 2.3.0
- **JSON**: Gson 2.8.7, XStream 1.4.15
- **UI**: Material 1.4.0, Lottie 5.2.0
- **Utils**: UtilCodeX 1.31.0, Hawk 2.0.1
- **Permissions**: XXPermissions 13.6
- **HTML Parsing**: JSoup 1.14.1
- **Event Bus**: EventBus 3.2.0

### Gradle Configuration

- **Gradle Version**: 8.7
- **Android Gradle Plugin (AGP)**: 8.4.0
- **Kotlin Version**: 1.9.22
- **Compile SDK**: 33
- **Min SDK**: 24
- **Target SDK**: 30
- **Java Version**: 21 (for build, targets Java 21 bytecode)

### Development Notes

- Signing config uses `TVBoxOSC.jks` with credentials in build.gradle
- APK output format: `MBox_v{version}_{buildType}_{date}.apk`
- MultiDex enabled for large app size
- Room schema exported to `app/schemas/`
- Uses Chinese comments and UI strings

### Common Tasks

1. **Add new Activity**: Extend `BaseVbActivity<ActivityBinding>`, implement `init()`
2. **Add new Fragment**: Extend `BaseVbFragment<FragmentBinding>`, implement `init()`
3. **Add new Dialog**: Create dialog class, use XPopup.Builder for complex dialogs
4. **Add new Data Class**: Use `data class` with constructor properties
5. **Add new API Source**: Configure in ApiConfig, use LoadConfigCallback pattern

### Code Review Checklist

- [ ] ViewBinding initialized before use
- [ ] Null safety handled properly
- [ ] Resources extracted to strings.xml
- [ ] Hardcoded dimensions moved to dimens.xml
- [ ] Coroutines use proper dispatchers
- [ ] Async operations handle errors gracefully
- [ ] Chinese translations provided for new strings
- [ ] No sensitive data in logs
- [ ] Lifecycle awareness (use lifecycleScope, ViewModelProvider)
