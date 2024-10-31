mod arithmetic;

fn main() {
    let mut input1;
    let mut input2;
    loop{

        input1 = 0;
        input2 = 0;

        loop {



        }
    }
}


fn read_multidigit() -> (i32, u32) {
    let mut num = 0;
    let mut c;

    loop {
        c = read_keyb_detector();
        if (c < 0x3a) && (0x2f < c )
        {
            num = arithmetic::mult(num, 10);
    
            num += (c - 0x30) as i32;
        }
        else {
            break;
        }

    }
    (num, c)
}


/// emulates reading from the keyboard status register
fn read_keyb_detector() -> u32 {

}

#[cfg(test)]
mod tests {

    #[test]
    

}