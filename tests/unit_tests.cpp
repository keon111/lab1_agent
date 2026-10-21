#include "math_operations.h"

#include <gtest/gtest.h>

TEST(MathOperationsTest, BasicAddition) {
    EXPECT_EQ(add(2, 3), 5);
}
