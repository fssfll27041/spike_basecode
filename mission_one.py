################################################################################
# mission_one.py
#
# Description:
# Lift the drone
#
# Author(s):Gerald
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

    #preform the drone survey mission
    r.robot.straight(710)
    r.robot.straight(-900)









################################
# KEEP THIS AT THE END OF THE FILE
# This redirects to running main.
################################
if __name__ == "__main__":
    from main import main
    main()
