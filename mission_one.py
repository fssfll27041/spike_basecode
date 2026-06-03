################################################################################
# mission_one.py
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

def mission_one(r: robot):
    print("Running Mission 1")
    # Your code goes here...
    # Sample Code: Run attachment motors and drive motors
    r.robot.straight (700)
    r.robot.turn(-45)
    r.robot.straight(80)
    # r.lam.run_time (-500,1000)
    # r.robot.straight(-50)
    # r.lam.run_time (200,2000)

    for i in range(3):
        r.lam.run_time(-1000, 1000)
        r.robot.straight(-50)
        r.lam.run_time(1000,1000)
        r.robot.straight(50)

    r.robot.drive(-1000,20)







################################
# KEEP THIS AT THE END OF THE FILE
# This redirects to running main.
################################
if __name__ == "__main__":
    from main import main
    main()
