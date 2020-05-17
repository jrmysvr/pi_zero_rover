#!/usr/bin/env bash

PWM_DIR=/sys/class/pwm/pwmchip0
PWM0=$PWM_DIR/pwm0
PWM1=$PWM_DIR/pwm1

FRWD=2000000
BACK=1000000
STOP=1500000

sudo bash -c "echo $FRWD > $PWM0/duty_cycle"
sudo bash -c "echo $BACK > $PWM1/duty_cycle"
sleep 1
sudo bash -c "echo $STOP > $PWM0/duty_cycle"
sudo bash -c "echo $STOP > $PWM1/duty_cycle"

