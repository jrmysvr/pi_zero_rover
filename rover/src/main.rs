extern crate sysfs_pwm;
#[macro_use]
extern crate error_chain;
#[macro_use]
extern crate clap;

mod error;
use error::*;

mod rover;

const PWM_CHIP: u32 = 0;
const LEFT_PWM: u32 = 0;
const RIGHT_PWM: u32 = 1;

fn run() -> Result<()> {
    use clap::App;
    use rover::Rover;

    let yaml = load_yaml!("cli.yml");
    let matches = App::from_yaml(yaml).version(crate_version!()).get_matches();

    let rover = Rover::new(PWM_CHIP, LEFT_PWM, RIGHT_PWM)?;

    // find out which subcommand was given, get_matches will print a help
    // message and exit if an unknown command is given.
    if let Some(_) = matches.subcommand_matches("disable") {
        rover.enable(false)
    } else if let Some(_) = matches.subcommand_matches("enable") {
        rover.enable(true)
    } else if let Some(_) = matches.subcommand_matches("stop") {
        rover.stop()
    } else if let Some(matches) = matches.subcommand_matches("speed") {
        // left is required so it will always be set here, otherwise
        // get_matches above will print a help message and exit.
        let left = matches.value_of("LEFT").unwrap();
        // if right is not set then use the left value
        let right = matches.value_of("RIGHT").unwrap_or(left);
        // parse the values into i8s and return an error if this fails.
        let left: i8 = left.parse::<i8>().chain_err(|| "failed to parse left speed")?;
        let right: i8 = right.parse::<i8>().chain_err(|| "failed to parse right speed")?;

        rover.set_speed(left, right)?;
        if !matches.is_present("dont-enable") {
            rover.enable(true)?;
        }
        Ok(())
    } else if let Some(_) = matches.subcommand_matches("unexport") {
        rover.unexport()
    } else {
        // If no command was specified print the help message
        println!("{}", matches.usage());
        Ok(())
    }
}

fn main() {
    println!("=======================================");
    println!("            Rover Pi Zero              ");
    println!("=======================================");

    if let Err(ref e) = run() {
        use std::io::Write;
        let stderr = &mut ::std::io::stderr();
        // Error message for when we cannot write to stderr
        let errmsg = "Error writing to stderr";

        // Print out the error that occurred.
        writeln!(stderr, "error: {}", e).expect(errmsg);

        // And what caused it.
        for e in e.iter().skip(1) {
            writeln!(stderr, "caused by: {}", e).expect(errmsg);
        }

        // As well as any backtrace if they are enabled.
        if let Some(backtrace) = e.backtrace() {
            writeln!(stderr, "backtrace: {:?}", backtrace).expect(errmsg);
        }

        ::std::process::exit(1);
    }
}
