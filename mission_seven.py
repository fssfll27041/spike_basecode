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
from robot import robot
from pybricks.tools import wait, StopWatch

def mission_seven(r: robot):
    print("Running Mission 7")
    # Your code goes here...

    r.robot.straight(370)
    r.lam.run_time(-500,1000)
    r.robot.straight(-400)

################################
# KEEP THIS AT THE END OF THE FILE
# This redirects to running main.
################################
if __name__ == "__main__":
    from main import main
    main()
