#!/usr/bin/env bash

PWM_DIR=/sys/class/pwm/pwmchip0
PWM0=$PWM_DIR/pwm0
PWM1=$PWM_DIR/pwm1


if [ ! -d $PWM0 ] || [ ! -d $PWM1 ]; then
	echo "Setting up $PWM_DIR"
	sudo bash -c "echo 0 > $PWM_DIR/export"
	sudo bash -c "echo 1 > $PWM_DIR/export"
fi

echo "Enabling Servos"
sudo bash -c "echo 1 > $PWM0/enable"
sudo bash -c "echo 1 > $PWM1/enable"
