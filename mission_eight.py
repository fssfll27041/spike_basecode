################################################################################
# mission_eight.py
#
# Description: one flip for the rock 
#
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

    r.robot.straight(425)
    r.lam.run_time(-750, 1600, wait=False)
    r.robot.drive(-200, 0)
    wait(3000)










################################
# KEEP THIS AT THE END OF THE FILE
# This redirects to running main.
################################
if __name__ == "__main__":
    from main import main
    main()
