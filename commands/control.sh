#!/usr/bin/env bash

PWM_DIR=/sys/class/pwm/pwmchip0
PWM0=$PWM_DIR/pwm0
PWM1=$PWM_DIR/pwm1
PERIOD=20000000

DUTY_CYCLE=1500000
FRWD=1500000
SLOW=1000000
BACK=500000

enable() {
	echo "Enabling"
	sudo bash -c "echo 0 > $PWM_DIR/export"
	sudo bash -c "echo 1 > $PWM_DIR/export"
	sudo bash -c "echo 1 > $PWM0/enable"
	sudo bash -c "echo 1 > $PWM1/enable"
}


disable() {
	echo "Disabling"
	sudo bash -c "echo 0 > $PWM0/enable"
	sudo bash -c "echo 0 > $PWM1/enable"
	sudo bash -c "echo 0 > $PWM_DIR/unexport"
	sudo bash -c "echo 1 > $PWM_DIR/unexport"
}

setup() {
	echo "Setting up $PWM_DIR"

	enable

	echo "Setting Servo Pulse Period"
	sudo bash -c "echo $PERIOD > $PWM0/period"
	sudo bash -c "echo $PERIOD > $PWM1/period"

	echo "Setting Servo Duty Cycle"
	sudo bash -c "echo $DUTY_CYCLE > $PWM0/duty_cycle"
	sudo bash -c "echo $DUTY_CYCLE > $PWM1/duty_cycle"

}

set_duty_cycle() {
	echo "$1  $2"
	if [ "$1" == 0 ]; then
		sudo bash -c "echo $2 > $PWM0/duty_cycle"
	fi
	if [ "$1" == 1 ]; then
		sudo bash -c "echo $2 > $PWM1/duty_cycle"
	fi
}

turn_left() {
	echo "LEFT TURN"
	set_duty_cycle 0 $FRWD
	set_duty_cycle 1 $SLOW
}

turn_right() {
	echo "RIGHT TURN"
	set_duty_cycle 0 $SLOW
	set_duty_cycle 1 $FRWD
}

go_straight() {
	echo "STRAIGHT AHEAD"
	set_duty_cycle 0 $FRWD
	set_duty_cycle 1 $FRWD
}

setup

sleep 1

turn_left

sleep 1

go_straight

sleep 1

turn_right 

sleep 1

disable
echo "Test Completed"
