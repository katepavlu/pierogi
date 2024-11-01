use std::num::Wrapping;

/// Booth's algorithm
pub fn mult(left:i32, right:i32) -> i32 {

    let mut left = Wrapping(left as u32);
    let mut right = Wrapping(right as u32);


    let mut accumulator = Wrapping(0 as u32);

    if (left & Wrapping(1)) != Wrapping(0) {
        accumulator -= right;
    }

    let mut index = 32;
    while index != 0 {
        right = right << 1;

        if (left & Wrapping(3)) == Wrapping(1) {
            accumulator += right; 
        }
        if (left & Wrapping(3)) == Wrapping(2) {
            accumulator -= right;
        }

        index -= 1;
        left = left >> 1;
    }

    let Wrapping(result) = accumulator;
    result as i32
}

/// long division https://en.wikipedia.org/wiki/Division_algorithm
pub fn div(left:i32, right:i32) -> i32 {

    let mut left=Wrapping(left as u32);
    let mut right = Wrapping(right as u32);

    let sign_l = left & Wrapping(0x8000_0000);
    let sign_r = right & Wrapping(0x8000_0000);

    if right == Wrapping(0) {
        left = Wrapping(0x7fff_ffff);
        right = Wrapping(1);
    }

    if sign_l != Wrapping(0) {
        left = -left;
    }
    if sign_r != Wrapping(0) {
        right = -right;
    }
    let sign_out = sign_l ^ sign_r;

    let mut q= Wrapping(0 as u32);
    let mut r = Wrapping(0 as u32);
    let mut i = Wrapping(32 as u32);
    while i != Wrapping(0) {
        r = r<<1;
        q = q<<1;
        r |= left >> 31;
        left = left << 1;
        if right < r+Wrapping(1) {
            r = r - right;
            q |= 1;
        }
        i -= 1;  
    }

    if sign_out != Wrapping(0) {
       q = -q;
    }
    let Wrapping(q) = q;
    q as i32
}

#[cfg(test)]
mod tests {
    #[test]
    fn mult() {
        assert_eq!(super::mult(4, 5), 20);
        assert_eq!(super::mult(4, -5), -20);
        assert_eq!(super::mult(-4, 5), -20);
        assert_eq!(super::mult(-4, -5), 20);

        assert_eq!(super::mult(0x7fff_ffff, 1), 0x7fff_ffff);
        assert_eq!(super::mult(-0x8000_0000, 1), -0x8000_0000);
    }

    #[test]
    fn div() {
        assert_eq!(super::div(5, 4), 1);
        assert_eq!(super::div(5, -4), -1);
        assert_eq!(super::div(-5, 4), -1);
        assert_eq!(super::div(-5, -4), 1);
        assert_eq!(super::div(0x800, 16), 0x80);

        assert_eq!(super::div(0x7fff_ffff, 1), 0x7fff_ffff);
        assert_eq!(super::div(-0x8000_0000, 1), -0x8000_0000);

        assert_eq!(super::div(0x7fff_ffff, 16), 0x07ff_ffff);
    }
}