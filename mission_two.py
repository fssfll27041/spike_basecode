################################################################################
# mission_two.py
#
# Description:
# vine and tree mission
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

def mission_two(r: robot):
    print("Running Mission 2")
    # Your code goes here...
    # r.ram(500, 100,)

    r.robot.straight (670)
    r.robot.turn (90)
    r.robot.straight (350)
    r.robot.turn (-70)
    r.robot.straight (40)
    r.robot.straight (110)
    r.lam.run_time (500, 1500)
    r.lam.run_time (-2000, 1400)
    r.robot.straight (-200)
    r.lam.run_time (-700, 700)
    r.robot.turn(-20)
    r.robot.straight (200)
    r.lam.run_time (500, 1500)
    r.lam.run_time (-1000, 700)
################################
# KEEP THIS AT THE END OF THE FILE
# This redirects to running main.
################################
if __name__ == "__main__":
    from main import main
    main()
