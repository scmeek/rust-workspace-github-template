use std::process::Command;

#[test]
fn prints_greeting_and_sum() {
    let output = Command::new(env!("CARGO_BIN_EXE_template_bin"))
        .output()
        .expect("template binary should run");

    assert!(output.status.success());
    assert_eq!(output.stdout, b"Hello, world!\n3\n");
    assert!(output.stderr.is_empty());
}
