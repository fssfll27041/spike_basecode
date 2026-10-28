################################################################################
# mission_seven.py
#
# Description:Flip thw rock
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

def mission_seven(r: robot):
    print("Running Mission 7")
    # Your code goes here...

    r.robot.straight(400)
    r.lam.run_time(-750, 2000, wait=False)
    r.robot.drive(-200, 0)
    wait(1000)

    r.robot.stop()

    r.lam.run_time(500, 1000)
    
    r.robot.straight(150)

    r.lam.run_time(-500, 500)
    r.lam.run_time(-500, 2000, wait=False)
    r.robot.drive(-200, 0)
    wait(2000)

################################
# KEEP THIS AT THE END OF THE FILE
# This redirects to running main.
################################
if __name__ == "__main__":
    from main import main
    main()
