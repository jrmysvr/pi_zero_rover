#!/usr/bin/env bash

PWM_DIR=/sys/class/pwm/pwmchip0
PWM0=$PWM_DIR/pwm0
PWM1=$PWM_DIR/pwm1

DUTY_CYCLE=$1
sudo bash -c "echo $DUTY_CYCLE > $PWM0/duty_cycle"
sudo bash -c "echo $DUTY_CYCLE > $PWM1/duty_cycle"
