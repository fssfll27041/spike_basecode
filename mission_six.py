################################################################################
# mission_six.py
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

def mission_six(r: robot):
    print("Running Mission 6")
    
    # Drive forward, stopping next to the tree, then turn right and approach
    r.robot.straight(710)
    r.robot.turn(90)
    r.robot.straight(60)

    # now lift the arm to support the tree
    r.lam.run_time(500, 500)
    r.lam.run_time(-500, 500)

    # reverse and go home
    r.robot.straight(-110)
    r.robot.turn(-90)
    r.robot.straight(-710)



################################
# KEEP THIS AT THE END OF THE FILE
# This redirects to running main.
################################
if __name__ == "__main__":
    from main import main
    main()
