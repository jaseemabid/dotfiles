#![feature(clamp)]
use std::{env, fs};

fn main() {
    let uid = unsafe { geteuid() };
    if uid != 0 {
        panic!("UID {} is not root", uid);
    }

    let args: Vec<String> = env::args().collect();
    match args.as_slice() {
        [_, x] => run(x),
        _ => help(),
    }
}

fn run(cmd: &str) {
    match cmd {
        "+" => set(percent() + 10),
        "-" => set(percent() - 10),
        n if n.parse::<i64>().is_ok() => set(n.parse::<i64>().unwrap()),
        _ => help(),
    }
}

fn help() {
    println!("brightness +|-|N");
}

fn max() -> i64 {
    read("/sys/class/backlight/intel_backlight/max_brightness")
}

fn current() -> i64 {
    read("/sys/class/backlight/intel_backlight/brightness")
}

fn percent() -> i64 {
    (100 * current()) / max()
}

fn set(p: i64) {
    let p = p.clamp(5, 100);
    write(p * max() / 100)
}

fn read(path: &str) -> i64 {
    fs::read_to_string(path)
        .unwrap_or_else(|_| panic!("Couldn't open file: {}", path))
        .trim()
        .parse::<i64>()
        .unwrap_or_else(|e| panic!("Failed to read number from `{}`", e))
}

fn write(b: i64) {
    fs::write(
        "/sys/class/backlight/intel_backlight/brightness",
        b.to_string(),
    )
    .unwrap();
}

#[link(name = "c")]
extern "C" {
    fn geteuid() -> u32;
}

#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn t_test() {
        assert_eq!(7500, max());
        assert!(current() <= 7500);
        assert!(percent() < 100);
    }

    #[test]
    #[ignore]
    fn t_write() {
        write(5000)
    }
}
