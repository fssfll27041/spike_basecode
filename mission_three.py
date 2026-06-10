################################################################################
# mission_three.py
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

def mission_three(r: robot):
    print("Running Mission 3")
    # Your code goes here...
    # Sample Code: Test running the attachment motor until stalled
    r.robot.straight(800)
    r.robot.turn(90)
    r.robot.straight(445)
    r.robot.turn(-90)
    r.robot.straight(35)
    r.lam.run_time(-3000,1000)
    r.lam.run_time(3000,1000)
    r.robot.straight(-200)


################################
# KEEP THIS AT THE END OF THE FILE
# This redirects to running main.
################################
if __name__ == "__main__":
    from main import main
    main()
