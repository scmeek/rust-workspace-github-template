#![cfg(target_os = "linux")]
#![allow(clippy::exit, reason = "Use of main macro by Iai-Callgrind")]

use iai_callgrind::{library_benchmark, library_benchmark_group, main};
use lib::add;
use std::hint::black_box;

#[library_benchmark]
fn iai_add() {
    black_box(add(black_box(42), black_box(58)));
}

library_benchmark_group!(
    name = my_group;
    benchmarks =
        iai_add,
);

main!(library_benchmark_groups = my_group);
