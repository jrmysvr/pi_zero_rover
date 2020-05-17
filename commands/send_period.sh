#!/usr/bin/env bash

PWM_DIR=/sys/class/pwm/pwmchip0
PWM0=$PWM_DIR/pwm0
PWM1=$PWM_DIR/pwm1

PERIOD=$1
sudo bash -c "echo $PERIOD > $PWM0/period"
sudo bash -c "echo $PERIOD > $PWM1/period"
