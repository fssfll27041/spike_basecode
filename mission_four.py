################################################################################
# mission_four.py
#
# Description:
# traversal mission
#
# Author(s): Andreu
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

def mission_four(r: robot):
    print("Running Mission 4")
    # Your code goes here...
    r.robot.settings(1000,1000,1000,1000)
    r.robot.straight(2030)
    r.robot.settings(400,400,400,400)

################################
# KEEP THIS AT THE END OF THE FILE
# This redirects to running main.
################################
if __name__ == "__main__":
    from main import main
    main()
