################################################################################
# mission_two.py
#
# Description:
# [Describe What your mission does here]
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
from robot import robot
from pybricks.tools import wait, StopWatch

def mission_two(r: robot):
    print("Running Mission 2")
    # Your code goes here...
    # Sample code: Test Driving in a box

    r.robot.drive(100,90)
    wait(450)
    r.robot.stop
    r.robot.straight(515)
    r.robot.turn(-50)
    r.lam.run_time (-5000,1000)
    r.robot.turn(80)
################################
# KEEP THIS AT THE END OF THE FILE
# This redirects to running main.
################################
if __name__ == "__main__":
    from main import main
    main()
