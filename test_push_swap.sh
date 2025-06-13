#!/bin/bash

# ██████╗ ██╗   ██╗███████╗██╗  ██╗    ███████╗██╗    ██╗ █████╗ ██████╗ 
# ██╔══██╗██║   ██║██╔════╝██║  ██║    ██╔════╝██║    ██║██╔══██╗██╔══██╗
# ██████╔╝██║   ██║███████╗███████║    ███████╗██║ █╗ ██║███████║██████╔╝
# ██╔═══╝ ██║   ██║╚════██║██╔══██║    ╚════██║██║███╗██║██╔══██║██╔═══╝ 
# ██║     ╚██████╔╝███████║██║  ██║    ███████║╚███╔███╔╝██║  ██║██║     
# ╚═╝      ╚═════╝ ╚══════╝╚═╝  ╚═╝    ╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝     
#
# 🧪 PUSH_SWAP TEST SUITE - Simple & Reliable Edition

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
RESET='\033[0m'

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
WARNING_TESTS=0
TEST_RESULTS=()

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
PUSH_SWAP="$PROJECT_DIR/push_swap"





print_color() {
    printf "$1$2$RESET"
}

print_header() {
    clear
    print_color $CYAN "╔══════════════════════════════════════════════════════════════╗\n"
    print_color $CYAN "║                    🧪 PUSH_SWAP TEST SUITE                   ║\n"
    print_color $CYAN "╚══════════════════════════════════════════════════════════════╝\n"
    echo
}

print_section() {
    echo
    print_color $MAGENTA "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
    print_color $WHITE "$1\n"
    print_color $MAGENTA "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
}

# Simple test function - now with checker validation
run_test() {
    local test_name=$1
    local test_input=$2
    local expected_exit_code=${3:-0}
    local max_operations=${4:-0}
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    printf "%-40s" "$test_name:"
    
    # Run push_swap (simple version without timeout for macOS compatibility)
    if [ "$test_input" = "EMPTY" ]; then
        output=$("$PUSH_SWAP" 2>&1)
        exit_code=$?
    else
        output=$("$PUSH_SWAP" $test_input 2>&1)
        exit_code=$?
    fi
    
    # Count operations
    local operation_count=0
    if [ $exit_code -eq 0 ] && [ -n "$output" ]; then
        operation_count=$(echo "$output" | wc -l | tr -d ' ')
    fi
    
    # Check exit code first
    if [ $exit_code -ne $expected_exit_code ]; then
        print_color $RED "[FAIL] "
        printf "Expected exit code %d, got %d\n" $expected_exit_code $exit_code
        FAILED_TESTS=$((FAILED_TESTS + 1))
        TEST_RESULTS+=("$test_name: FAILED - Wrong exit code ($exit_code instead of $expected_exit_code)")
        return
    fi
    
    # For success cases (exit_code = 0), validate with checker
    if [ $expected_exit_code -eq 0 ] && [ "$test_input" != "EMPTY" ]; then
        # Special check: if no output, verify input was actually already sorted
        if [ -z "$output" ]; then
            if ! is_input_sorted "$test_input"; then
                print_color $RED "[FAIL] "
                printf "No output but input is not sorted\n"
                FAILED_TESTS=$((FAILED_TESTS + 1))
                TEST_RESULTS+=("$test_name: FAILED - No output but input needs sorting")
                return
            fi
        fi
        
        local validation_result=$(validate_with_checker "$test_input" "$output")
        
        if [ "$validation_result" != "OK" ]; then
            print_color $RED "[FAIL] "
            printf "Checker validation failed: %s\n" "$validation_result"
            FAILED_TESTS=$((FAILED_TESTS + 1))
            TEST_RESULTS+=("$test_name: FAILED - Checker validation: $validation_result")
            return
        fi
    fi
    
    # If we get here, the test passed basic validation
    if [ $expected_exit_code -eq 0 ]; then
        # Success case - check operation count
        if [ $max_operations -gt 0 ] && [ $operation_count -gt $max_operations ]; then
            print_color $YELLOW "[WARN] "
            printf "Operations: %d/%d\n" $operation_count $max_operations
            WARNING_TESTS=$((WARNING_TESTS + 1))
            TEST_RESULTS+=("$test_name: WARNING - Too many operations ($operation_count/$max_operations)")
        else
            print_color $GREEN "[PASS]"
            if [ $operation_count -gt 0 ]; then
                printf " Operations: %d\n" $operation_count
            else
                printf " Already sorted\n"
            fi
            PASSED_TESTS=$((PASSED_TESTS + 1))
        fi
    else
        # Error case - should have error
        print_color $GREEN "[PASS] "
        printf "Error handled correctly\n"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    fi
}

# Check if input is already sorted
is_input_sorted() {
    local input=$1
    local numbers=($input)
    local count=${#numbers[@]}
    
    # Single number or empty is always sorted
    if [ $count -le 1 ]; then
        return 0
    fi
    
    # Check if each number is <= next number
    for ((i=1; i<count; i++)); do
        if [ ${numbers[i-1]} -gt ${numbers[i]} ]; then
            return 1  # Not sorted
        fi
    done
    
    return 0  # Sorted
}

# Validate with official checker
validate_with_checker() {
    local test_input=$1
    local operations=$2
    
    # If no operations (already sorted), assume OK
    if [ -z "$operations" ]; then
        echo "OK"
        return
    fi
    
    # Determine which checker to use based on OS
    local checker=""
    if [[ "$OSTYPE" == "darwin"* ]]; then
        checker="$SCRIPT_DIR/checker_Mac"
    else
        checker="$SCRIPT_DIR/checker_linux"
    fi
    
    # Check if checker exists and is executable
    if [ ! -f "$checker" ]; then
        echo "CHECKER_NOT_FOUND"
        return
    fi
    
    if [ ! -x "$checker" ]; then
        chmod +x "$checker" 2>/dev/null || {
            echo "CHECKER_NOT_EXECUTABLE"
            return
        }
    fi
    
    # Run checker with operations
    local checker_result=$(echo "$operations" | "$checker" $test_input 2>&1)
    local checker_exit=$?
    
    if [ $checker_exit -eq 0 ]; then
        case "$checker_result" in
            "OK")
                echo "OK"
                ;;
            "KO")
                echo "KO"
                ;;
            *)
                echo "CHECKER_UNKNOWN_OUTPUT"
                ;;
        esac
    else
        echo "CHECKER_ERROR"
    fi
}

# Simple random generation (no hanging)
generate_simple_numbers() {
    local count=$1
    local numbers=""
    local i
    
    for i in $(seq 1 $count); do
        local num=$((i + RANDOM % 100))
        numbers="$numbers $num"
    done
    
    echo $numbers
}

# Advanced random generation for performance tests
generate_random_numbers() {
    local count=$1
    local max_val=${2:-$((count * 10))}
    local numbers=""
    local used_numbers=()
    
    # Create array of unique random numbers
    while [ ${#used_numbers[@]} -lt $count ]; do
        local num=$((RANDOM % max_val + 1))
        
        # Check if number already exists
        local exists=0
        for existing in "${used_numbers[@]}"; do
            if [ "$existing" -eq "$num" ]; then
                exists=1
                break
            fi
        done
        
        # Add if unique
        if [ $exists -eq 0 ]; then
            used_numbers+=($num)
        fi
    done
    
    # Convert to space-separated string
    echo "${used_numbers[@]}"
}

# Generate guaranteed unsorted array for testing
generate_unsorted_numbers() {
    local count=$1
    
    if [ $count -eq 3 ]; then
        echo "3 1 2"
    elif [ $count -eq 5 ]; then
        echo "5 2 4 1 3"
    elif [ $count -eq 100 ]; then
        # Generate reverse sorted with some randomness
        local numbers=""
        for i in $(seq $count -1 1); do
            numbers="$numbers $i"
        done
        echo "$numbers"
    elif [ $count -eq 500 ]; then
        # Generate reverse sorted for maximum operations
        local numbers=""
        for i in $(seq $count -1 1); do
            numbers="$numbers $i"
        done
        echo "$numbers"
    else
        # Fallback to random
        generate_random_numbers $count
    fi
}

# Performance benchmark for specific size
run_performance_benchmark() {
    local size=$1
    # Optimize test count based on size for speed
    local test_count=100
    if [ $size -ge 500 ]; then
        test_count=50  # Reduce for large sizes
    elif [ $size -ge 100 ]; then
        test_count=75  # Moderate reduction
    fi
    
    local total_operations=0
    local min_operations=999999
    local max_operations=0
    local operations_array=()
    
    printf "%-15s" "$size numbers:"
    printf "Running %d tests... " $test_count
    
    for i in $(seq 1 $test_count); do
        # Generate random numbers (mix of random and guaranteed unsorted)
        local numbers
        if [ $((i % 10)) -eq 1 ]; then
            # Every 10th test use guaranteed unsorted
            numbers=$(generate_unsorted_numbers $size)
        else
            # Regular random numbers
            numbers=$(generate_random_numbers $size)
        fi
        
        # Run push_swap and count operations
        local output=$("$PUSH_SWAP" $numbers 2>/dev/null)
        local operations=0
        
        if [ $? -eq 0 ] && [ -n "$output" ]; then
            operations=$(echo "$output" | wc -l | tr -d ' ')
        fi
        
        # Update statistics
        total_operations=$((total_operations + operations))
        operations_array+=($operations)
        
        if [ $operations -lt $min_operations ]; then
            min_operations=$operations
        fi
        
        if [ $operations -gt $max_operations ]; then
            max_operations=$operations
        fi
        
        # Show progress with percentage
        if [ $((i % 5)) -eq 0 ]; then
            local percent=$((i * 100 / test_count))
            printf "\rTesting... %d%% (%d/%d)" $percent $i $test_count
        fi
    done
    
    # Calculate average
    local avg_operations=$((total_operations / test_count))
    
    # Save average for final validation check
    if [ $size -eq 100 ]; then
        echo $avg_operations > /tmp/push_swap_100_avg
    elif [ $size -eq 500 ]; then
        echo $avg_operations > /tmp/push_swap_500_avg
    fi
    
    # Calculate median (sort array and take middle value)
    IFS=$'\n' sorted=($(printf '%s\n' "${operations_array[@]}" | sort -n))
    local median=${sorted[$((test_count / 2))]}
    
    # Determine performance rating based on 42 evaluation criteria
    local rating=""
    local color=""
    local points=""
    
    if [ $size -eq 3 ] && [ $avg_operations -le 3 ]; then
        rating="EXCELLENT"
        color=$GREEN
        points=""
    elif [ $size -eq 5 ] && [ $avg_operations -le 12 ]; then
        rating="PASS (≤12 required)"
        color=$GREEN
        points=""
    elif [ $size -eq 5 ]; then
        rating="FAIL (>12 operations)"
        color=$RED
        points=""
    elif [ $size -eq 10 ]; then
        if [ $avg_operations -le 80 ]; then
            rating="EXCELLENT"
            color=$GREEN
        elif [ $avg_operations -le 120 ]; then
            rating="GOOD"
            color=$YELLOW
        else
            rating="NEEDS_IMPROVEMENT"
            color=$RED
        fi
        points=""
    elif [ $size -eq 50 ]; then
        if [ $avg_operations -le 400 ]; then
            rating="EXCELLENT"
            color=$GREEN
        elif [ $avg_operations -le 600 ]; then
            rating="GOOD"
            color=$YELLOW
        else
            rating="NEEDS_IMPROVEMENT"
            color=$RED
        fi
        points=""
    elif [ $size -eq 100 ]; then
        if [ $avg_operations -lt 700 ]; then
            rating="5 POINTS (Maximum)"
            color=$GREEN
            points="⭐⭐⭐⭐⭐"
        elif [ $avg_operations -lt 900 ]; then
            rating="4 POINTS"
            color=$GREEN
            points="⭐⭐⭐⭐"
        elif [ $avg_operations -lt 1100 ]; then
            rating="3 POINTS"
            color=$YELLOW
            points="⭐⭐⭐"
        elif [ $avg_operations -lt 1300 ]; then
            rating="2 POINTS"
            color=$YELLOW
            points="⭐⭐"
        elif [ $avg_operations -lt 1500 ]; then
            rating="1 POINT"
            color=$YELLOW
            points="⭐"
        else
            rating="FAIL (≥1500)"
            color=$RED
            points="❌"
        fi
    elif [ $size -eq 500 ]; then
        if [ $avg_operations -lt 5500 ]; then
            rating="5 POINTS (Maximum)"
            color=$GREEN
            points="⭐⭐⭐⭐⭐"
        elif [ $avg_operations -lt 7000 ]; then
            rating="4 POINTS"
            color=$GREEN
            points="⭐⭐⭐⭐"
        elif [ $avg_operations -lt 8500 ]; then
            rating="3 POINTS"
            color=$YELLOW
            points="⭐⭐⭐"
        elif [ $avg_operations -lt 10000 ]; then
            rating="2 POINTS"
            color=$YELLOW
            points="⭐⭐"
        elif [ $avg_operations -lt 11500 ]; then
            rating="1 POINT"
            color=$YELLOW
            points="⭐"
        else
            rating="FAIL (≥11500)"
            color=$RED
            points="❌"
        fi
    else
        rating="UNKNOWN_SIZE"
        color=$GRAY
        points=""
    fi
    
    printf "\r%-70s\n" " "  # Clear progress line
    if [ -n "$points" ]; then
        print_color $color "  ✓ Avg: $avg_operations operations | Min: $min_operations | Max: $max_operations | Median: $median\n"
        print_color $color "    $points $rating\n"
    else
        print_color $color "  ✓ Avg: $avg_operations operations | Min: $min_operations | Max: $max_operations | Median: $median | $rating\n"
    fi
}

# Build project
build_project() {
    if [ ! -f "$PUSH_SWAP" ]; then
        print_color $YELLOW "🔨 Building project...\n"
        cd "$PROJECT_DIR"
        if ! make > /dev/null 2>&1; then
            print_color $RED "❌ Build failed!\n"
            print_color $RED "Make sure you're running this from a push_swap project directory\n"
            print_color $RED "or that push_swap executable exists in: $PROJECT_DIR\n"
            exit 1
        fi
        print_color $GREEN "✅ Build successful!\n"
        cd "$SCRIPT_DIR"  # Return to script directory
    fi
}

# Main test function
main() {
    print_header
    build_project
    
    # ============== BASIC TESTS ==============
    print_section "🔵 BASIC FUNCTIONALITY TESTS"
    
    run_test "Empty input" "EMPTY" 0
    run_test "Single number" "42" 0
    run_test "Two numbers (sorted)" "1 2" 0
    run_test "Two numbers (unsorted)" "2 1" 0 3
    run_test "Three numbers (sorted)" "1 2 3" 0
    run_test "Three numbers (unsorted)" "3 1 2" 0 3
    
    # ============== SMALL STACK TESTS ==============
    print_section "🟡 SMALL STACK TESTS (≤ 5 elements)"
    
    run_test "3 numbers: 2 1 3" "2 1 3" 0 3
    run_test "3 numbers: 1 3 2" "1 3 2" 0 3
    run_test "3 numbers: 3 2 1" "3 2 1" 0 3
    run_test "4 numbers" "4 3 2 1" 0 12
    run_test "5 numbers" "5 4 3 2 1" 0 12
    
    # ============== MEDIUM STACK TESTS ==============
    print_section "🟠 MEDIUM STACK TESTS (6-100 elements)"
    
    run_test "6 numbers" "6 5 4 3 2 1" 0 20
    run_test "10 numbers" "10 9 8 7 6 5 4 3 2 1" 0 80
    run_test "20 numbers" "20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1" 0 200
    run_test "30 numbers" "$(seq 30 -1 1 | tr '\n' ' ')" 0 250
    

    
    # ============== ERROR HANDLING TESTS ==============
    print_section "🔴 ERROR HANDLING TESTS"
    
    run_test "Duplicate numbers" "1 2 2 3" 1
    run_test "Non-numeric input" "1 2 three 4" 1
    run_test "Integer overflow" "2147483648" 1
    run_test "Integer underflow" "-2147483649" 1
    run_test "Mixed valid/invalid" "1 2 3 abc" 1
    run_test "Only spaces" "   " 0
    run_test "Empty string argument" '""' 1
    
    # ============== EDGE CASES ==============
    print_section "🟣 EDGE CASE TESTS"
    
    run_test "Negative numbers" "-1 -2 -3" 0 3
    run_test "Mixed pos/neg" "-2 1 0 -1 2" 0 12
    run_test "INT_MAX/INT_MIN" "2147483647 -2147483648" 0 3
    run_test "Already sorted (large)" "1 2 3 4 5 6 7 8 9 10" 0
    run_test "Reverse sorted" "10 9 8 7 6 5 4 3 2 1" 0 70
    
    # ============== STRING INPUT TESTS ==============
    print_section "🟢 STRING INPUT TESTS"
    
    run_test "String input (sorted)" "1 2 3" 0
    run_test "String input (unsorted)" "3 1 2" 0 3
    run_test "String with spaces" "  1   2   3  " 0
    run_test "String with duplicates" "1 2 2" 1
    
    # ============== PERFORMANCE TESTS ==============
    if [ "$1" = "--performance" ] || [ "$1" = "-p" ]; then
        print_section "⚡ PERFORMANCE BENCHMARKS"
        
        # Clean up previous results
        rm -f /tmp/push_swap_100_avg /tmp/push_swap_500_avg
        
        print_color $YELLOW "Running performance benchmarks (100 tests per size)...\n"
        print_color $GRAY "This may take a few minutes. Please wait...\n"
        echo
        
        # Small sizes
        print_color $CYAN "📊 Small Stack Performance:\n"
        run_performance_benchmark 3
        run_performance_benchmark 5
        
        echo
        # Medium sizes
        print_color $CYAN "📊 Medium Stack Performance:\n"
        run_performance_benchmark 10
        run_performance_benchmark 50
        run_performance_benchmark 100
        
        echo
        # Large sizes
        print_color $CYAN "📊 Large Stack Performance:\n"
        run_performance_benchmark 500
        
        echo
        print_color $CYAN "📋 42 Evaluation Standards:\n"
        print_color $WHITE "  • 5 elements: ≤ 12 operations (Required)\n"
        echo
        print_color $WHITE "  🎯 100 elements scoring:\n"
        print_color $GREEN "    < 700: ⭐⭐⭐⭐⭐ 5 points (Maximum)\n"
        print_color $GREEN "    < 900: ⭐⭐⭐⭐ 4 points\n"
        print_color $YELLOW "    < 1100: ⭐⭐⭐ 3 points\n"
        print_color $YELLOW "    < 1300: ⭐⭐ 2 points\n"
        print_color $YELLOW "    < 1500: ⭐ 1 point\n"
        print_color $RED "    ≥ 1500: ❌ FAIL\n"
        echo
        print_color $WHITE "  🎯 500 elements scoring:\n"
        print_color $GREEN "    < 5500: ⭐⭐⭐⭐⭐ 5 points (Maximum)\n"
        print_color $GREEN "    < 7000: ⭐⭐⭐⭐ 4 points\n"
        print_color $YELLOW "    < 8500: ⭐⭐⭐ 3 points\n"
        print_color $YELLOW "    < 10000: ⭐⭐ 2 points\n"
        print_color $YELLOW "    < 11500: ⭐ 1 point\n"
        print_color $RED "    ≥ 11500: ❌ FAIL\n"
        echo
        print_color $CYAN "🏆 Project Validation Levels:\n"
        print_color $GREEN "  • 100%% validation (+ bonus eligibility): 100<700 AND 500<5500\n"
        print_color $YELLOW "  • 80%% minimum validation (3 combinations):\n"
        print_color $YELLOW "    - 100<1100 AND 500<8500\n"
        print_color $YELLOW "    - 100<700 AND 500<11500\n"
        print_color $YELLOW "    - 100<1300 AND 500<5500\n"
        
        # Final project validation check (if we have both 100 and 500 results)
        if [ -f "/tmp/push_swap_100_avg" ] && [ -f "/tmp/push_swap_500_avg" ]; then
            local avg_100=$(cat /tmp/push_swap_100_avg)
            local avg_500=$(cat /tmp/push_swap_500_avg)
            
            echo
            print_color $MAGENTA "🎖️ FINAL PROJECT VALIDATION:\n"
            
            # Calculate estimated grade based on performance
            local estimated_grade=0
            
            if [ $avg_100 -lt 700 ] && [ $avg_500 -lt 5500 ]; then
                estimated_grade=100
                print_color $GREEN "  ✅ 100%% VALIDATION + BONUS ELIGIBILITY\n"
                print_color $GREEN "     (100: $avg_100 < 700) AND (500: $avg_500 < 5500)\n"
            elif [ $avg_100 -lt 1500 ] && [ $avg_500 -lt 11500 ]; then
                # Calculate grade based on points system
                local points_100=0
                local points_500=0
                
                # Calculate 100 element points
                if [ $avg_100 -lt 700 ]; then points_100=5
                elif [ $avg_100 -lt 900 ]; then points_100=4
                elif [ $avg_100 -lt 1100 ]; then points_100=3
                elif [ $avg_100 -lt 1300 ]; then points_100=2
                elif [ $avg_100 -lt 1500 ]; then points_100=1
                fi
                
                # Calculate 500 element points  
                if [ $avg_500 -lt 5500 ]; then points_500=5
                elif [ $avg_500 -lt 7000 ]; then points_500=4
                elif [ $avg_500 -lt 8500 ]; then points_500=3
                elif [ $avg_500 -lt 10000 ]; then points_500=2
                elif [ $avg_500 -lt 11500 ]; then points_500=1
                fi
                
                local total_points=$((points_100 + points_500))
                # Based on real 42 evaluation: 7 points = 84%
                if [ $total_points -eq 10 ]; then
                    estimated_grade=100
                elif [ $total_points -eq 9 ]; then
                    estimated_grade=95
                elif [ $total_points -eq 8 ]; then
                    estimated_grade=90
                elif [ $total_points -eq 7 ]; then
                    estimated_grade=84
                elif [ $total_points -eq 6 ]; then
                    estimated_grade=80
                elif [ $total_points -eq 5 ]; then
                    estimated_grade=75
                elif [ $total_points -eq 4 ]; then
                    estimated_grade=70
                elif [ $total_points -eq 3 ]; then
                    estimated_grade=65
                elif [ $total_points -eq 2 ]; then
                    estimated_grade=60
                else
                    estimated_grade=50
                fi
                
                if [ $estimated_grade -ge 80 ]; then
                    print_color $GREEN "  ✅ PROJECT VALIDATION PASSED ($estimated_grade%%)\n"
                    print_color $GREEN "     Points: $points_100 (100 numbers) + $points_500 (500 numbers) = $total_points/10\n"
                else
                    print_color $YELLOW "  ⚠️  MARGINAL VALIDATION ($estimated_grade%%)\n"
                    print_color $YELLOW "     Points: $points_100 (100 numbers) + $points_500 (500 numbers) = $total_points/10\n"
                fi
                print_color $CYAN "     Performance: (100: $avg_100) AND (500: $avg_500)\n"
            else
                print_color $RED "  ❌ PROJECT VALIDATION FAILED\n"
                print_color $RED "     (100: $avg_100) AND (500: $avg_500)\n"
                print_color $RED "     One or both tests exceed maximum thresholds\n"
            fi
        fi
    fi
    

    
    # ============== FINAL REPORT ==============
    print_section "📊 TEST SUMMARY"
    
    printf "Total tests run: %d\n" $TOTAL_TESTS
    print_color $GREEN "Passed: $PASSED_TESTS\n"
    print_color $YELLOW "Warnings: $WARNING_TESTS\n"
    print_color $RED "Failed: $FAILED_TESTS\n"
    echo
    
    if [ $FAILED_TESTS -gt 0 ]; then
        print_color $RED "❌ FAILED TESTS:\n"
        for result in "${TEST_RESULTS[@]}"; do
            if [[ $result == *"FAILED"* ]]; then
                print_color $RED "  • $result\n"
            fi
        done
        echo
    fi
    
    if [ $WARNING_TESTS -gt 0 ]; then
        print_color $YELLOW "⚠️  WARNINGS:\n"
        for result in "${TEST_RESULTS[@]}"; do
            if [[ $result == *"WARNING"* ]]; then
                print_color $YELLOW "  • $result\n"
            fi
        done
        echo
    fi
    
    # Final verdict
    if [ $FAILED_TESTS -eq 0 ]; then
        print_color $GREEN "🎉 ALL TESTS PASSED! 🎉\n"
        if [ $WARNING_TESTS -gt 0 ]; then
            print_color $YELLOW "Note: Some warnings detected - see details above.\n"
        fi
        exit 0
    else
        print_color $RED "❌ SOME TESTS FAILED ❌\n"
        exit 1
    fi
}

# Help function
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  --performance, -p Run performance benchmarks (100 tests per size)"
    echo "  --help, -h        Show this help message"
    echo
    echo "Features:"
    echo "  • Comprehensive testing suite"
    echo "  • Performance benchmarking with 42 evaluation standards"
    echo "  • Automatic grade estimation"
    echo "  • Cross-platform compatibility"
    echo
    echo "Examples:"
    echo "  $0                Basic comprehensive tests"
    echo "  $0 --performance  Run performance benchmarks"
}

# Parse command line arguments
case "$1" in
    --help|-h)
        show_help
        exit 0
        ;;
    *)
        main "$1"
        ;;
esac 