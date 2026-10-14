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
from robot import robot, STRAIGHT_SPEED, STRAIGHT_ACCEL, TURN_RATE, TURN_ACCEL
from pybricks.tools import wait, StopWatch

def mission_four(r: robot):
    print("Running Mission 4")
    
    r.robot.settings(
                STRAIGHT_SPEED * 2, STRAIGHT_ACCEL * 2,
                TURN_RATE * 2, TURN_ACCEL * 2,
            )

    # Your code goes here...
    r.robot.straight(2030)

    r.robot.settings(
                STRAIGHT_SPEED, STRAIGHT_ACCEL,
                TURN_RATE, TURN_ACCEL,
            )


################################
# KEEP THIS AT THE END OF THE FILE
# This redirects to running main.
################################
if __name__ == "__main__":
    from main import main
    main()
