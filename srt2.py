def leading_zeros(x: int, width: int) -> int:
    return width - len(bin(x)[2:].zfill(width).lstrip('0'))

def srt_digit_select(top_bits: int) -> int:
    """
    SRT Radix-2 digit selection using Robertson-style threshold table:
    This is a simple version based only on top 3 bits of remainder.
    """
    if top_bits < -1:
        return -1
    elif top_bits > 1:
        return +1
    else:
        return 0

def srt_divide_lookup(a: int, b: int, n: int = 8):
    assert b != 0, "Division by zero"

    # 1. Normalize
    a_neg, b_neg = a < 0, b < 0
    A = abs(a)
    B = abs(b)
    k = leading_zeros(B, n)
    B <<= k
    A <<= k
    P = 0
    Q_digits = []

    for _ in range(n):
        # Take top bits from P to decide quotient digit (simulating top 3 or 4 bits)
        # Scale remainder for selection (approximate Ri/D)
        if B == 0:
            approx_ratio = 0
        else:
            approx_ratio = (P << 1) // B  # Scale for lookup
        qi = srt_digit_select(approx_ratio)

        # Update P and A
        if qi == -1:
            P = (P << 1) + ((A >> (n + k - 1)) & 1) + B
        elif qi == 0:
            P = (P << 1) + ((A >> (n + k - 1)) & 1)
        else:  # +1
            P = (P << 1) + ((A >> (n + k - 1)) & 1) - B

        A = (A << 1) & ((1 << (2 * n)) - 1)
        Q_digits.append(qi)

    # Final correction
    if P < 0:
        P += B
        Q_digits[-1] -= 1

    # Convert quotient digits from redundant (signed digits) to binary
    Q = 0
    for q in Q_digits:
        Q = (Q << 1) + q

    # Adjust sign
    quotient = -Q if a_neg != b_neg else Q
    remainder = -P >> k if a_neg else P >> k

    return quotient, remainder


# Example usage
if __name__ == "__main__":
    a = 25
    b = 7
    q, r = srt_divide_lookup(a, b, n=8)
    print(f"{a} / {b} = {q} with remainder {r}")
