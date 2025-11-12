use criterion::{Criterion, criterion_group, criterion_main};
use std::hint::black_box;
use template_lib::add;

fn bench_add(c: &mut Criterion) {
    c.bench_function("my_function", |b| {
        b.iter(|| add(black_box(42), black_box(58)));
    });
}

criterion_group!(benches, bench_add);
criterion_main!(benches);
