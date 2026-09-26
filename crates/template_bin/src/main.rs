#![doc = include_str!("../README.md")]
#![allow(clippy::print_stdout, reason = "template code")]

use template_lib::add;

fn main() {
    println!("Hello, world!");
    println!("{}", add(1, 2));
}
