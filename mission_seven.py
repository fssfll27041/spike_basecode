################################################################################
# mission_seven.py
#
# Description: Flip the rock
#
#
# Author(s): Eleanor/Gerald
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

def mission_seven(r: robot):
    print("Running Mission 7")

    #driving up to the rock, first flip
    r.robot.straight(425)
    r.lam.run_time(-750, 1600, wait=False)
    r.robot.drive(-200, 0)
    wait(1000)

    r.robot.stop()

    r.lam.run_time(500, 1000)
    
    r.robot.straight(150)

    r.lam.run_time(-200, 1500, wait=False)
    r.robot.drive(-200, 0)
    wait(2000)

################################
# KEEP THIS AT THE END OF THE FILE
# This redirects to running main.
################################
if __name__ == "__main__":
    from main import main
    main()
