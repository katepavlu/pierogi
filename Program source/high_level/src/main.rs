fn main() {
    println!("Hello, world!");
}




fn poll_keyboard() -> char {
    let  key = '1';

    key
}

// simple one instruction operation
fn add(left:i32, right:i32) -> i32 {
    left + right
}

// simple one instruction operation
fn sub(left:i32, right:i32) -> i32 {
    left - right
}

/// Booth's algorithm
fn mult(mut left:i32, mut right:i32) -> i32 {

    let mut accumulator:i64 = 0;

    if (left & 1) as u32 > 0 {
        accumulator -= right as i64
    }

    let mut index = 32;
    while index > 0 {
        right = right << 1;

        if (left & 3) == 1 {
            accumulator += right as i64; 
        }
        if (left & 3) == 2 {
            accumulator -= right as i64;
        }

        index -= 1;
        left = left >> 1;
    }

    accumulator as i32
}

/// long division https://en.wikipedia.org/wiki/Division_algorithm
fn div(mut left:i32, mut right:i32) -> i32 {
    let sign_l = left as u32 & 0x8000_0000;
    let sign_r = right as u32 & 0x8000_0000;

    if right == 0 {
        return 0x7fff_ffff;
    }

    if sign_l > 0 {
        left = -left;
    }
    if sign_r > 0 {
        right = -right;
    }
    let sign_out = sign_l ^ sign_r;

    let mut q= 0;
    let mut r = 0;
    let mut i = 32;
    while i != 0 {
        r = r<<1;
        q = q<<1;
        r |= (left as u32 >> 31) as i32;
        left = left << 1;
        println!("r: {r} q: {q} left: {left} right: {right}");
        if right as u32 <= r as u32 {
            r = r - right;
            q |= 1;
        }
        i -= 1;  
    }

    if sign_out > 0 {
       q = -q;
    }
    q
}

#[cfg(test)]
mod tests {

    #[test]
    fn add() {
        assert_eq!(super::add(5, 5), 10);
        assert_eq!(super::add(5, -5), 0);
    }

    #[test]
    fn sub() {
        assert_eq!(super::sub(5, 5), 0);
        assert_eq!(super::sub(5, -5), 10);
    }

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
        assert_eq!(super::div(-0x7fff_ffff, 1), -0x7fff_ffff);

        assert_eq!(super::div(0x7fff_ffff, 16), 0x07ff_ffff);
    }
}