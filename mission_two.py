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
from pybricks.tools import wait, StopWatch
from robot import robot, STRAIGHT_SPEED, STRAIGHT_ACCEL, TURN_RATE, TURN_ACCEL

def mission_two(r: robot):
    print("Running Mission 2")
    # Your code goes here...
    # r.ram(500, 100,)

    # Drive towards the tree
    r.robot.straight (670)
    r.robot.turn (90)
    r.robot.straight (400) # score the building 
    r.robot.straight (-50)

    # Turn to the tree and get the vine
    r.robot.turn (-70)
    r.robot.straight (150)
    r.lam.run_time (500, 1500)
    #r.lam.run_time (-2000, 1400)
    r.lam.run_time (-500, 1500)

    # Back up and get the vine
    r.robot.straight (-200)
    r.lam.run_time (-700, 700)  # go down in prep
    r.robot.turn(-20)
    r.robot.straight (200)
    r.lam.run_time (500, 1500)
    r.lam.run_time (-1000, 700)

    # Drive home
    r.robot.settings(STRAIGHT_SPEED * 2, STRAIGHT_ACCEL * 2, TURN_RATE, TURN_ACCEL)
    r.robot.drive(-1000, 10)
    wait(3000)

    r.robot.stop()
    r.robot.settings(STRAIGHT_SPEED, STRAIGHT_ACCEL, TURN_RATE, TURN_ACCEL)

################################
# KEEP THIS AT THE END OF THE FILE
# This redirects to running main.
################################
if __name__ == "__main__":
    from main import main
    main()
