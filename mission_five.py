################################################################################
# mission_five.py
#
# Description:
# drive forward, fast up (), drive back while dropping slowly.
#
# Author(s): [Your Name(s)]
# Date: [YYYY-MM-DD]
# Version: 1.0
#
# Dependencies:
# - robot
# - pybricks.tools
#
################################################################################

from robot import robot, STRAIGHT_SPEED, STRAIGHT_ACCEL, TURN_RATE, TURN_ACCEL
from pybricks.tools import wait, StopWatch

def mission_five(r: robot):
    print("Running Mission 5")
    # Drive forward close to the mycellium
    r.robot.straight(820)
    # Drive to the the ant test
    r.robot.turn(-90)
    r.robot.straight(260)
    r.robot.turn(135)

    # approach slowly
    r.robot.settings (STRAIGHT_SPEED / 4, STRAIGHT_ACCEL / 4, TURN_RATE, TURN_ACCEL)
    r.robot.straight(150)
    r.robot.settings (STRAIGHT_SPEED, STRAIGHT_ACCEL, TURN_RATE, TURN_ACCEL)
    r.robot.straight(-120)
    r.robot.turn(90)
    r.robot.straight(900)

################################
# KEEP THIS AT THE END OF THE FILE
# This redirects to running main.
################################
if __name__ == "__main__":
    from main import main
    main()
