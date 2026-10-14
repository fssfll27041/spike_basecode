################################################################################
# mission_eight.py
#
# Description:
# a mission
#
# Author(s): Eleanor
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

def mission_eight(r: robot):
    print("Running Mission 8")
    # Your code goes here...

    r.robot.straight(650)
    r.robot.turn(90)
    r.robot.straight(600)
    r.robot.settings(STRAIGHT_SPEED * 2, STRAIGHT_ACCEL * 2, TURN_RATE, TURN_ACCEL)
    r.robot.drive(-800, 15)
    wait(4000)
    r.robot.stop()
    r.robot.settings(STRAIGHT_SPEED, STRAIGHT_ACCEL, TURN_RATE, TURN_ACCEL)







################################
# KEEP THIS AT THE END OF THE FILE
# This redirects to running main.
################################
if __name__ == "__main__":
    from main import main
    main()
