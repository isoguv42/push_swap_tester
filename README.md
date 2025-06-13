# 🧪 Push_Swap Test Suite

<div align="center">

```
██████╗ ██╗   ██╗███████╗██╗  ██╗    ███████╗██╗    ██╗ █████╗ ██████╗ 
██╔══██╗██║   ██║██╔════╝██║  ██║    ██╔════╝██║    ██║██╔══██╗██╔══██╗
██████╔╝██║   ██║███████╗███████║    ███████╗██║ █╗ ██║███████║██████╔╝
██╔═══╝ ██║   ██║╚════██║██╔══██║    ╚════██║██║███╗██║██╔══██║██╔═══╝ 
██║     ╚██████╔╝███████║██║  ██║    ███████║╚███╔███╔╝██║  ██║██║     
╚═╝      ╚═════╝ ╚══════╝╚═╝  ╚═╝    ╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝     

████████╗███████╗███████╗████████╗███████╗██████╗ 
╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝██╔════╝██╔══██╗
   ██║   █████╗  ███████╗   ██║   █████╗  ██████╔╝
   ██║   ██╔══╝  ╚════██║   ██║   ██╔══╝  ██╔══██╗
   ██║   ███████╗███████║   ██║   ███████╗██║  ██║
   ╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
```

[![42 School](https://img.shields.io/badge/42-School-000000?style=flat&logo=42&logoColor=white)](https://42.fr)
[![42 Network](https://img.shields.io/badge/42-Network-000000?style=flat&logo=42&logoColor=white)](https://42network.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-blue)](https://github.com/isoguv42/push_swap_tester)

**Professional testing suite for 42 School's push_swap project**  
*Compatible with 42 Network, Codam, and all 42 campuses worldwide*

</div>

## 📋 Table of Contents

1. [Overview](#-overview)
2. [Features](#-features)
3. [Installation](#-installation)
4. [Usage](#-usage)
5. [Test Categories](#-test-categories)
6. [Performance Benchmarks](#-performance-benchmarks)
7. [42 Evaluation Standards](#-42-evaluation-standards)
8. [Platform Compatibility](#-platform-compatibility)
9. [Contributing](#-contributing)
10. [License](#-license)

## 🎯 Overview

This comprehensive test suite is designed to thoroughly validate push_swap implementations against 42 School's evaluation criteria. It provides automated testing, performance benchmarking, and detailed reporting to ensure your push_swap project meets all requirements for 42 Network campuses including Codam, 42 Paris, 42 Silicon Valley, and more.

## ✨ Features

- **🔍 Comprehensive Testing**: 31 carefully crafted test cases covering all edge cases
- **⚡ Performance Benchmarking**: Automated performance testing with 42 evaluation standards
- **🎯 Official Checker Integration**: Uses official checker_Mac/checker_linux for validation
- **🌈 Beautiful Output**: Colored terminal output with progress tracking
- **📊 Detailed Reporting**: Comprehensive test results with failure analysis
- **🔧 Cross-Platform**: Works on both macOS and Linux
- **🚀 Easy Integration**: Simple Makefile integration for any push_swap project
- **🏫 42 Network Compatible**: Tested across multiple 42 campuses

## 🚀 Installation

### Automatic Installation (Recommended)

Add this to your push_swap project's Makefile:

```makefile
# Test suite integration
TEST_REPO = https://github.com/isoguv42/push_swap_tester.git
TEST_DIR = push_swap_tester

$(TEST_DIR):
	@echo "📚 Downloading test suite..."
	@git clone $(TEST_REPO) $(TEST_DIR) 2>/dev/null || { \
		echo "❌ Failed to clone test repository"; \
		exit 1; \
	}
	@echo "✅ Test suite downloaded successfully!"

test: $(NAME) $(TEST_DIR)
	@echo "🧪 Running test suite..."
	@./$(TEST_DIR)/test_push_swap.sh

test-performance: $(NAME) $(TEST_DIR)
	@echo "⚡ Running performance benchmarks..."
	@./$(TEST_DIR)/test_push_swap.sh --performance

fclean: clean
	@rm -f $(NAME)
	@rm -rf $(TEST_DIR)
```

### Manual Installation

```bash
git clone https://github.com/isoguv42/push_swap_tester.git
cd push_swap_tester
chmod +x test_push_swap.sh
```

## 🎮 Usage

### Basic Testing

```bash
# Run all tests (31 comprehensive tests)
make test

# Or run directly
./push_swap_tester/test_push_swap.sh
```

### Performance Benchmarking

```bash
# Run performance benchmarks with 42 evaluation
make test-performance

# Or run directly
./push_swap_tester/test_push_swap.sh --performance
```

### Available Options

```bash
./test_push_swap.sh --help          # Show help
./test_push_swap.sh --performance   # Performance benchmarks
```

## 🧪 Test Categories

### 🔵 Basic Functionality Tests (6 tests)
- Empty input handling
- Single number validation
- Two numbers (sorted/unsorted)
- Three numbers (sorted/unsorted)

### 🟡 Small Stack Tests (5 tests)
- 3 numbers: Various permutations
- 4 numbers: Reverse sorted
- 5 numbers: Reverse sorted
- **Requirement**: ≤ 12 operations for 5 elements

### 🟠 Medium Stack Tests (4 tests)
- 6, 10, 20, 30 numbers
- Progressive difficulty scaling
- Operation count validation

### 🔴 Error Handling Tests (7 tests)
- Duplicate numbers
- Non-numeric input
- Integer overflow/underflow
- Mixed valid/invalid input
- Edge case inputs

### 🟣 Edge Case Tests (5 tests)
- Negative numbers
- Mixed positive/negative
- INT_MAX/INT_MIN boundaries
- Already sorted arrays
- Reverse sorted arrays

### 🟢 String Input Tests (4 tests)
- String argument parsing
- Whitespace handling
- Duplicate detection in strings

## ⚡ Performance Benchmarks

### 42 School Evaluation Standards

#### 🎯 100 Elements Scoring
- **< 700 operations**: ⭐⭐⭐⭐⭐ 5 points (Maximum)
- **< 900 operations**: ⭐⭐⭐⭐ 4 points
- **< 1100 operations**: ⭐⭐⭐ 3 points
- **< 1300 operations**: ⭐⭐ 2 points
- **< 1500 operations**: ⭐ 1 point
- **≥ 1500 operations**: ❌ FAIL

#### 🎯 500 Elements Scoring
- **< 5500 operations**: ⭐⭐⭐⭐⭐ 5 points (Maximum)
- **< 7000 operations**: ⭐⭐⭐⭐ 4 points
- **< 8500 operations**: ⭐⭐⭐ 3 points
- **< 10000 operations**: ⭐⭐ 2 points
- **< 11500 operations**: ⭐ 1 point
- **≥ 11500 operations**: ❌ FAIL

### 🏆 Project Validation Levels

- **100% validation + bonus eligibility**: 100<700 AND 500<5500
- **80% minimum validation** (example combinations):
  - 100<1100 AND 500<8500
  - 100<700 AND 500<11500
  - 100<1300 AND 500<5500
  - ... (other valid combinations exist)

## 🌐 Platform Compatibility

### ✅ Supported Platforms
- **macOS**: Uses `checker_Mac`
- **Linux**: Uses `checker_linux`

### 📋 Requirements
- **Bash**: Version 4.0+
- **Git**: For automatic installation
- **Standard Unix tools**: `wc`, `tr`, `seq`, `printf`

### 🔧 Dependencies
- Official checker binaries (included)
- Your compiled `push_swap` executable

## 📊 Sample Output

```
╔══════════════════════════════════════════════════════════════╗
║                    🧪 PUSH_SWAP TEST SUITE                   ║
╚══════════════════════════════════════════════════════════════╝

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔵 BASIC FUNCTIONALITY TESTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Empty input:                            [PASS] Already sorted
Single number:                          [PASS] Already sorted
Two numbers (sorted):                   [PASS] Already sorted
Two numbers (unsorted):                 [PASS] Operations: 1
Three numbers (sorted):                 [PASS] Already sorted
Three numbers (unsorted):               [PASS] Operations: 2

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🟡 SMALL STACK TESTS (≤ 5 elements)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
3 numbers: 2 1 3:                       [PASS] Operations: 1
3 numbers: 1 3 2:                       [PASS] Operations: 1
3 numbers: 3 2 1:                       [PASS] Operations: 2
4 numbers:                              [PASS] Operations: 8
5 numbers:                              [PASS] Operations: 12

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🟠 MEDIUM STACK TESTS (6-100 elements)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
6 numbers:                              [PASS] Operations: 15
10 numbers:                             [PASS] Operations: 45
20 numbers:                             [PASS] Operations: 120
30 numbers:                             [PASS] Operations: 180

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔴 ERROR HANDLING TESTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Duplicate numbers:                      [PASS] Error handled correctly
Non-numeric input:                      [PASS] Error handled correctly
Integer overflow:                       [PASS] Error handled correctly
Integer underflow:                      [PASS] Error handled correctly
Mixed valid/invalid:                    [PASS] Error handled correctly
Only spaces:                            [PASS] Already sorted
Empty string argument:                  [PASS] Error handled correctly

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🟣 EDGE CASE TESTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Negative numbers:                       [PASS] Operations: 2
Mixed pos/neg:                          [PASS] Operations: 8
INT_MAX/INT_MIN:                        [PASS] Operations: 1
Already sorted (large):                 [PASS] Already sorted
Reverse sorted:                         [PASS] Operations: 45

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🟢 STRING INPUT TESTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
String input (sorted):                  [PASS] Already sorted
String input (unsorted):                [PASS] Operations: 2
String with spaces:                     [PASS] Already sorted
String with duplicates:                 [PASS] Error handled correctly

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 TEST SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total tests run: 31
Passed: 31
Warnings: 0
Failed: 0

✅ ALL TESTS PASSED! ✅

🎖️ PERFORMANCE BENCHMARK RESULTS:
  • 100 elements: Avg 850 operations (⭐⭐⭐⭐ 4 points)
  • 500 elements: Avg 6200 operations (⭐⭐⭐⭐ 4 points)
  
🏆 PROJECT VALIDATION: 80% Grade (7/10 points)
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Guidelines
- Follow existing code style
- Add tests for new features
- Update documentation
- Ensure cross-platform compatibility

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **42 School** and **42 Network** for the push_swap project
- **Codam** and other 42 campuses for testing and feedback
- **Official checker** binaries for validation
- **42 Community** for continuous improvement

## 🔍 Keywords

`42 school` `42 network` `codam` `push swap` `push_swap` `tester` `42 project` `algorithm` `sorting` `stack` `42 paris` `42 silicon valley` `42 campus` `ecole 42` `42 cursus` `42 common core`

---

<div align="center">

**Made with ❤️ for 42 School students worldwide**

[Report Bug](https://github.com/isoguv42/push_swap_tester/issues) · [Request Feature](https://github.com/isoguv42/push_swap_tester/issues) · [Contribute](https://github.com/isoguv42/push_swap_tester/pulls)

</div> 