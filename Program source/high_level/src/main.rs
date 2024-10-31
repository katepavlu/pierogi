mod arithmetic;

use std::io;

fn main() {
    let mut input1;
    let mut input2;
    let mut op1;
    let mut op2;
    loop{

        (input1,op1) = read_multidigit();

        if op1 == 0x2a { //clear
            println!("out: 0");
            continue;
        }

        loop {

            (input2,op2) = read_multidigit();

            if op1 == 0x41 { //plus
                input1 = input1 + input2;
            }
            if op1 == 0x42 { //minus
                input1 = input1 - input2;
            }
            if op1 == 0x43 { //mul
                input1 = arithmetic::mult(input1, input2);
            }
            if op1 == 0x44 { //div
                input1 = arithmetic::div(input1, input2);
            }

            println!("out: {}", input1);

            if op2 == 0x23 { // equals
                (_, op2) = read_multidigit();
            }

            if op2 == 0x2a { //clear
                println!("out: 0");
                break;
            }

            op1 = op2;
        }
    }
}

// reads a decimal multidigit number
fn read_multidigit() -> (i32, i32) {
    let mut num = 0;
    let mut c;

    loop {
        c = read_keyb_detector();
        if (c < 0x3a) && (0x2f < c )
        {
            num = arithmetic::mult(num, 10);
    
            num += (c - 0x30) as i32;

            println!("num: {}", num); 
            // this represents printing to the screen
        }
        else {
            break;
        }

    }
    (num, c)
}

// polls keyboard until a rising edge is found
fn read_keyb_detector() -> i32 {

    loop {
        if read_single_num() == 0 {
            break;
        }
    }
    let mut num;

    loop {
        num = read_single_num();
        if num != 0 {
            break;
        }
    }

    num
}

/// emulates reading from the keyboard status register
fn read_single_num() -> i32 {

    let mut input = String::new();

    io::stdin()
        .read_line(&mut input)
        .expect("line read error");

    input.pop(); // cho off the \n

    let parsed = match i32::from_str_radix(&input, 16) {
        Ok(i) => i,
        _ => 0,
    };

    parsed
   
}