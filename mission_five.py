################################################################################
# mission_five.py
#
# Description:
# drive forward, fast up (), drive back while dropping slowly.
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

from robot import robot, STRAIGHT_SPEED, STRAIGHT_ACCEL, TURN_RATE, TURN_ACCEL
from pybricks.tools import wait, StopWatch

def mission_five(r: robot):
    print("Running Mission 5")
    r.robot.straight(835)
    r.robot.turn (-25)    #turn to get hook behind red bar

    # r.lam.run_time(400, 1000)
    # r.lam.run_time(-200, 2500)
    r.robot.settings(STRAIGHT_SPEED / 4, STRAIGHT_ACCEL / 4, TURN_RATE, TURN_ACCEL)
    r.robot.straight(-50) #back up to pull bar, SLOWLY
    r.robot.turn(-90)

    r.robot.straight(260)
    r.robot.turn(135)
    r.robot.straight(150)
    r.robot.straight(-120)
    r.robot.turn(90)
    r.robot.straight(900)

################################
# KEEP THIS AT THE END OF THE FILE
# This redirects to running main.
################################
if __name__ == "__main__":
    from main import main
    main()





################################
# KEEP THIS AT THE END OF THE FILE
# This redirects to running main.
################################
if __name__ == "__main__":
    from main import main
    main()
