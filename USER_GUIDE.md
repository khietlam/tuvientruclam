# TuVienTrucLam - User Guide

Welcome to TuVienTrucLam! This guide will help you install, configure, and use the application effectively.

## 📱 Table of Contents

- [Getting Started](#getting-started)
- [Installation](#installation)
- [First Launch](#first-launch)
- [Main Features](#main-features)
- [Settings & Configuration](#settings--configuration)
- [Tips & Best Practices](#tips--best-practices)
- [Troubleshooting](#troubleshooting)
- [FAQ](#faq)

---

## Getting Started

### What is TuVienTrucLam?

TuVienTrucLam is a mobile application designed for Buddhist temples to manage and display information about individuals. The app features:

- **Advanced Search**: Find people by name, ID, dates, or location with Vietnamese diacritic support
- **Slideshow Display**: Automated presentation of images with smooth transitions
- **Smart Caching**: Optimized image loading for thousands of photos
- **Offline Support**: Works without internet connection once data is loaded

### System Requirements

**Minimum Requirements:**
- Android 5.0 (Lollipop) or higher
- 2GB RAM
- 500MB free storage space
- ARM or x86 processor

**Recommended:**
- Android 8.0 (Oreo) or higher
- 4GB RAM
- 1GB free storage space

---

## Installation

### Method 1: Download APK (Recommended)

1. **Download the APK**
   - Visit the [GitHub Releases page](https://github.com/khietlam/tuvientruclam/releases)
   - Download the latest `app-release.apk` file

2. **Enable Unknown Sources** (if needed)
   - Go to **Settings** → **Security**
   - Enable **Install from Unknown Sources** or **Install Unknown Apps**
   - Grant permission to your file manager or browser

3. **Install the App**
   - Open the downloaded APK file
   - Tap **Install**
   - Wait for installation to complete
   - Tap **Open** to launch the app

### Method 2: Build from Source

For developers who want to build from source:

```bash
# Clone the repository
git clone https://github.com/khietlam/tuvientruclam.git
cd tuvientruclam

# Install dependencies
flutter pub get

# Build release APK
flutter build apk --release

# Install on connected device
flutter install
```

---

## First Launch

### Initial Setup

1. **Launch the App**
   - Tap the TuVienTrucLam icon on your home screen
   - The app will display a loading screen

2. **Grant Permissions**
   - When prompted, grant **Storage Permission**
   - This allows the app to read image files from your device

3. **Select Data Folder**
   - On first launch, you'll be prompted to select a data folder
   - Navigate to the folder containing your temple data
   - Tap **Select** to confirm

4. **Wait for Data Loading**
   - The app will load all person records and images
   - This may take a few moments depending on data size
   - A loading indicator will show progress

### Understanding the Interface

The app has a clean, intuitive interface with the following main screens:

- **Main Screen**: Displays the slideshow and navigation controls
- **Search Dialog**: Advanced search functionality
- **Settings Dialog**: Configure app behavior and manage cache

---

## Main Features

### 1. Slideshow Display

The slideshow automatically cycles through images with smooth transitions.

**Controls:**
- **Play/Pause Button**: Start or stop automatic slideshow
- **Previous/Next Arrows**: Navigate manually between images
- **Grid View Button**: View all images in a grid layout

**How to Use:**
1. Launch the app to start the slideshow automatically
2. Tap the **Pause** button (⏸) to stop auto-advance
3. Use **← →** arrows to navigate manually
4. Tap **Play** button (▶) to resume automatic slideshow

**Slideshow Settings:**
- Default transition time: 5 seconds (configurable)
- Smooth fade-in animations
- Smart preloading for seamless transitions

### 2. Search Functionality

Find specific people quickly using the advanced search feature.

**How to Search:**

1. **Open Search Dialog**
   - Tap the **Search** button (🔍) on the main screen
   - The search dialog will appear with a text field

2. **Enter Search Terms**
   - Type the person's name, ID, or other information
   - Search supports Vietnamese with or without diacritics
   - Examples:
     - Search "Tam" will find "Tâm", "Tám", "Tam"
     - Search by ID: "1001"
     - Search by date: "2024"
     - Search by location: "Saigon"

3. **View Results**
   - **Single Result**: App automatically displays the person's information
   - **Multiple Results**: A list appears showing all matches
   - **No Results**: Message indicates no matches found

4. **Navigate Results**
   - Tap on a result to view details
   - Use **Load More** button if there are many results (shows 20 at a time)
   - Tap **Close** to return to slideshow

**Search Tips:**
- ✅ Search is case-insensitive
- ✅ Supports partial name matching
- ✅ Works with Vietnamese diacritics (Tâm, Tám, Tấn, etc.)
- ✅ Can search multiple fields simultaneously
- ✅ Use spaces to search multiple terms

**Example Searches:**
```
"Nguyen Van"     → Finds all people with "Nguyen Van" in their name
"1001"           → Finds person with ID 1001
"Saigon"         → Finds people from Saigon
"2024"           → Finds people with 2024 in any date field
"Thich Tam"      → Finds "Thích Tâm", "Thích Tám", etc.
```

### 3. Grid View

View all images in a grid layout for quick browsing.

**How to Use:**
1. Tap the **Grid** button on the main screen
2. Scroll through the grid of thumbnails
3. Tap any image to view it in full screen
4. Tap **Back** to return to slideshow

**Grid Features:**
- Displays all available images
- Smooth scrolling
- Quick navigation
- Tap to view full size

### 4. Person Information Display

View detailed information about each person.

**Information Shown:**
- **Thế Danh** (Secular Name)
- **Pháp Danh** (Dharma Name)
- **Ngày Mất** (Date of Passing)
- **Hướng Thọ** (Age at Passing)
- **Nguyên Quán** (Place of Origin)
- **Photo** (if available)

**How to View:**
- Information appears automatically during slideshow
- Or search for a specific person
- Details display in a clean, readable format

---

## Settings & Configuration

Access settings by tapping the **Settings** button (⚙️) on the main screen.

### Slideshow Duration

**Configure transition time between images:**

1. Open **Settings**
2. Find **"Thời gian chuyển slide (giây)"** section
3. Enter a value between **1-60 seconds**
4. Tap **Save** to apply

**Recommended Settings:**
- **Fast**: 3-5 seconds (for quick browsing)
- **Normal**: 5-10 seconds (default)
- **Slow**: 15-30 seconds (for detailed viewing)

### Cache Management

The app uses smart caching to load images quickly and efficiently.

#### Auto Clear Cache

**Set automatic cache cleanup schedule:**

1. Open **Settings**
2. Find **"Tự động xóa cache"** dropdown
3. Select frequency:
   - **Không bao giờ** (Never) - Keep cache indefinitely
   - **Hàng ngày** (Daily) - Clear cache every day
   - **Hàng tuần** (Weekly) - Clear cache every week
   - **Hàng tháng** (Monthly) - Clear cache every month

**Recommended:** Weekly or Monthly for best performance

#### Manual Cache Clear

**Clear cache immediately:**

1. Open **Settings**
2. Scroll to **"Quản lý cache hình ảnh"** section
3. View cache statistics (number of preloaded images)
4. Tap **"Xóa cache ngay"** (Clear cache now)
5. Confirm the action

**When to Clear Cache:**
- App is running slowly
- Storage space is low
- After updating data files
- Images not displaying correctly

#### Cache Statistics

View current cache status:
- **Preloaded images**: Number of images currently cached
- Updates in real-time

### Change Data Folder

**Switch to a different data source:**

1. Open **Settings**
2. Tap **"Đổi thư mục dữ liệu"** (Change data folder)
3. Navigate to the new folder location
4. Select the folder
5. App will reload with new data

**Use Cases:**
- Switching between different temple locations
- Loading updated data files
- Testing with different datasets

---

## Tips & Best Practices

### Performance Optimization

**For Best Performance:**

1. **Regular Cache Clearing**
   - Set auto-clear to Weekly or Monthly
   - Manually clear if app slows down

2. **Optimal Slideshow Speed**
   - Use 5-10 seconds for normal viewing
   - Faster speeds may cause loading delays

3. **Storage Management**
   - Keep at least 500MB free space
   - Clear cache if storage is low

4. **Data Organization**
   - Keep all images in one folder
   - Use consistent file naming
   - Ensure JSON data is properly formatted

### Search Efficiency

**Search Faster:**

1. **Use Specific Terms**
   - More specific = faster results
   - "Thích Tâm Minh" better than "Tam"

2. **ID Search**
   - Fastest method for known IDs
   - Direct lookup, no fuzzy matching

3. **Partial Names**
   - Use first/last name only
   - App will find all matches

### Battery Saving

**Extend Battery Life:**

1. **Pause Slideshow**
   - Stop auto-advance when not viewing
   - Reduces CPU usage

2. **Lower Brightness**
   - Adjust device screen brightness
   - Biggest battery saver

3. **Close When Not in Use**
   - Exit app completely
   - Prevents background processing

### Data Management

**Keep Data Organized:**

1. **Backup Regularly**
   - Copy data folder to safe location
   - Backup before major updates

2. **Consistent Format**
   - Use same JSON structure
   - Validate data before loading

3. **Image Quality**
   - Use optimized images (not too large)
   - Recommended: 1920x1080 or smaller
   - Format: JPG or PNG

---

## Troubleshooting

### Common Issues and Solutions

#### App Won't Start

**Problem**: App crashes on launch or shows blank screen

**Solutions:**
1. Restart your device
2. Clear app data: Settings → Apps → TuVienTrucLam → Clear Data
3. Reinstall the app
4. Check Android version compatibility (5.0+)

#### Images Not Loading

**Problem**: Slideshow shows blank or missing images

**Solutions:**
1. **Check Permissions**
   - Go to Settings → Apps → TuVienTrucLam → Permissions
   - Enable Storage permission

2. **Verify Data Folder**
   - Ensure images are in the correct folder
   - Check file names match JSON data

3. **Clear Cache**
   - Open Settings → Clear cache now
   - Restart app

4. **Check File Format**
   - Supported: JPG, PNG
   - Ensure files aren't corrupted

#### Search Not Working

**Problem**: Search returns no results or incorrect results

**Solutions:**
1. **Check Search Terms**
   - Verify spelling
   - Try without diacritics

2. **Reload Data**
   - Change data folder and change back
   - Forces data refresh

3. **Check JSON Data**
   - Ensure data file is properly formatted
   - Validate JSON structure

#### App Running Slowly

**Problem**: Laggy performance, slow transitions

**Solutions:**
1. **Clear Cache**
   - Settings → Clear cache now
   - Frees up memory

2. **Reduce Slideshow Speed**
   - Increase transition time to 10+ seconds
   - Gives more time for preloading

3. **Free Up Storage**
   - Delete unnecessary files
   - Keep 500MB+ free space

4. **Restart App**
   - Close completely and reopen
   - Clears memory

5. **Restart Device**
   - Clears system memory
   - Resolves most performance issues

#### Storage Full Warning

**Problem**: Device shows low storage warning

**Solutions:**
1. **Clear App Cache**
   - Settings → Clear cache now
   - Can free 100-200MB

2. **Delete Unused Apps**
   - Remove apps you don't use
   - Free up system storage

3. **Move Files to SD Card**
   - Transfer photos/videos
   - Keep internal storage free

#### Permission Denied Errors

**Problem**: App can't access files or folders

**Solutions:**
1. **Grant Storage Permission**
   - Settings → Apps → TuVienTrucLam → Permissions
   - Enable Storage

2. **Check Folder Location**
   - Ensure folder is accessible
   - Try moving to internal storage

3. **Reinstall App**
   - Uninstall and reinstall
   - Grant permissions when prompted

---

## FAQ

### General Questions

**Q: Is internet connection required?**
A: No, the app works completely offline once data is loaded.

**Q: How many images can the app handle?**
A: The app is optimized for 3000+ images with smart caching and preloading.

**Q: Can I use the app on tablets?**
A: Yes, the app has responsive design and works on tablets and phones.

**Q: What languages are supported?**
A: The app is designed for Vietnamese with full diacritic support, but works with any language.

**Q: Is my data secure?**
A: All data is stored locally on your device. No data is sent to external servers.

### Data & Files

**Q: What data format is required?**
A: The app uses JSON format for person data and standard image files (JPG/PNG).

**Q: Can I edit data within the app?**
A: No, data editing must be done externally. Use the "Change data folder" feature to load updated data.

**Q: How do I update person information?**
A: Edit the JSON data file externally, then use "Change data folder" to reload.

**Q: What's the maximum image size?**
A: No hard limit, but recommend 1920x1080 or smaller for best performance.

**Q: Can I use the app with multiple data sets?**
A: Yes, use "Change data folder" to switch between different data sets.

### Performance

**Q: Why is the slideshow slow?**
A: Try clearing cache, reducing slideshow speed, or freeing up device storage.

**Q: How much storage does the app use?**
A: App size is ~50MB. Cache can grow to 200MB depending on usage.

**Q: Does the app drain battery?**
A: Normal usage is battery-efficient. Pause slideshow when not viewing to save battery.

**Q: Can I run the app in the background?**
A: Yes, but pause the slideshow to save resources.

### Search

**Q: How does Vietnamese search work?**
A: Search is diacritic-insensitive. "Tam" finds "Tâm", "Tám", "Tấn", etc.

**Q: Can I search by multiple criteria?**
A: Yes, use spaces to search multiple terms. All terms must match.

**Q: Why doesn't search find my person?**
A: Check spelling, try partial names, or search by ID for exact matches.

**Q: Is search case-sensitive?**
A: No, search is completely case-insensitive.

### Settings

**Q: What's the best slideshow duration?**
A: 5-10 seconds is recommended for normal viewing.

**Q: How often should I clear cache?**
A: Set auto-clear to Weekly or Monthly. Clear manually if app slows down.

**Q: Will clearing cache delete my data?**
A: No, only cached images are cleared. Your original data files are safe.

**Q: Can I backup my settings?**
A: Settings are stored in app data. Backup your data folder for complete backup.

### Technical

**Q: What Android version is required?**
A: Android 5.0 (Lollipop) or higher. Android 8.0+ recommended.

**Q: Does the app work on iOS?**
A: Currently Android only. iOS version may be available in the future.

**Q: Can I contribute to development?**
A: Yes! Visit the [GitHub repository](https://github.com/khietlam/tuvientruclam) to contribute.

**Q: Where can I report bugs?**
A: Create an issue on [GitHub Issues](https://github.com/khietlam/tuvientruclam/issues).

**Q: Is the source code available?**
A: Yes, the project is open source under MIT License.

---

## Getting Help

### Support Resources

**Documentation:**
- [README.md](README.md) - Project overview
- [CI-CD.md](CI-CD.md) - Build and deployment guide
- [TEST_COVERAGE.md](TEST_COVERAGE.md) - Testing documentation

**Online Support:**
- **GitHub Issues**: [Report bugs or request features](https://github.com/khietlam/tuvientruclam/issues)
- **GitHub Discussions**: [Ask questions and share ideas](https://github.com/khietlam/tuvientruclam/discussions)

### Before Asking for Help

Please provide the following information:
1. **Device Information**: Model, Android version
2. **App Version**: Check in app info
3. **Problem Description**: What happened vs. what you expected
4. **Steps to Reproduce**: How to recreate the issue
5. **Screenshots**: If applicable
6. **Error Messages**: Any error text shown

---

## Updates & Releases

### Checking for Updates

1. Visit [GitHub Releases](https://github.com/khietlam/tuvientruclam/releases)
2. Check the latest version number
3. Download and install the new APK if available

### Update Process

1. Download the latest APK
2. Install over existing app (data is preserved)
3. Grant any new permissions if requested
4. App will automatically migrate settings

### Release Notes

Check the [Releases page](https://github.com/khietlam/tuvientruclam/releases) for:
- New features
- Bug fixes
- Performance improvements
- Breaking changes

---

## Appendix

### Keyboard Shortcuts

When using external keyboard:
- **Space**: Play/Pause slideshow
- **←/→**: Previous/Next image
- **Ctrl+F**: Open search
- **Esc**: Close dialogs

### File Structure

```
data_folder/
├── data.json          # Person information
└── images/            # Image files
    ├── 1001.jpg
    ├── 1002.jpg
    └── ...
```

### JSON Data Format

```json
{
  "persons": [
    {
      "id": 1001,
      "theDanh": "Nguyễn Văn A",
      "phapDanh": "Thích Tâm Minh",
      "ngayMat": "01/01/2024",
      "huongTho": 75,
      "nguyenQuan": "Sài Gòn"
    }
  ]
}
```

### Performance Benchmarks

**Tested with 3000+ images:**
- Initial load: ~5-10 seconds
- Image transition: <100ms
- Search response: <500ms
- Cache size: ~200MB max

---

**Thank you for using TuVienTrucLam!** 🙏

For more information, visit the [GitHub repository](https://github.com/khietlam/tuvientruclam).

*Last updated: February 7, 2026*
