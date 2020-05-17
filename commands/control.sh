#!/usr/bin/env bash

PWM_DIR=/sys/class/pwm/pwmchip0
PWM0=$PWM_DIR/pwm0
PWM1=$PWM_DIR/pwm1

PERIOD=20000000

#Duty Cycles
STOP=20000000

FRWD0=2000000
BACK0=200000
#SLOW0=1000000
SLOW0=$BACK0

FRWD1=200000
BACK1=2000000
#SLOW1=1000000
SLOW1=$BACK1

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
	disable
	enable

	echo "Setting Servo Pulse Period"
	sudo bash -c "echo $PERIOD > $PWM0/period"
	sudo bash -c "echo $PERIOD > $PWM1/period"

	echo "Setting Servo Duty Cycle"
	sudo bash -c "echo $FRWD0 > $PWM0/duty_cycle"
	sudo bash -c "echo $FRWD1 > $PWM1/duty_cycle"

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
	set_duty_cycle 0 $FRWD0
	set_duty_cycle 1 $SLOW1
}

turn_right() {
	echo "RIGHT TURN"
	set_duty_cycle 0 $SLOW0
	set_duty_cycle 1 $FRWD1
}

go_straight() {
	echo "STRAIGHT AHEAD"
	set_duty_cycle 0 $FRWD0
	set_duty_cycle 1 $FRWD1
}

full_stop() {
	echo "Stopping"
	set_duty_cycle 0 $STOP
	set_duty_cycle 1 $STOP
}

perform_test() {
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
}

case "$1" in
	"--test")
	perform_test
	;;
	"--setup")
	setup
	;;
	"--enable")
	enable
	;;
	"--disable")
	disable
	;;
	"--left")
	turn_left
	;;
	"--right")
	turn_right
	;;
	"--straight")
	go_straight
	;;
	"--stop")
	full_stop
	;;
	*)
	echo "No Arguments Provided"
esac
