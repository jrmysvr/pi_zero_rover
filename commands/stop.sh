#!/usr/bin/env bash

PWM_DIR=/sys/class/pwm/pwmchip0
PWM0=$PWM_DIR/pwm0
PWM1=$PWM_DIR/pwm1


echo "Stopping"
sudo bash -c "echo 0 > $PWM0/enable"
sudo bash -c "echo 0 > $PWM1/enable"
sudo bash -c "echo 0 > $PWM_DIR/unexport"
sudo bash -c "echo 1 > $PWM_DIR/unexport"

