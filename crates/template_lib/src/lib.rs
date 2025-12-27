#![doc = include_str!("../README.md")]

#[must_use]
pub fn add(left: u64, right: u64) -> u64 {
    left.checked_add(right).unwrap_or(0)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = add(2, 2);
        assert_eq!(result, 4);
    }
}
