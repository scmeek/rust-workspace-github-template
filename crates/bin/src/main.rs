#![allow(clippy::print_stdout, reason = "template code")]

use lib::add;

fn main() {
    println!("Hello, world!");
    println!("{}", add(1, 2));
}
