################################################################################
# mission_five.py
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

def mission_five(r: robot):
    print("Running Mission 5")
    # Your code goes here...

    #the robot drives forward lifts the attachment and then backs.
    r.robot.straight (750)
    r.lam.run_time(1000, 1000)

    #Will lower atachment turn and drive forward.
    r.robot.straight(-200)
    r.lam.run_time(1000,1000)
    r.robot.straight(-200)

    #The robot wil get in posistion and drive for to complete the fungie farm mision.
    r.robot.turn(90)
    r.robot.straight(200)
    r.robot.turn(45)
    r.robot.straight(100)
    r.robot.turn(90)

    # TEMPORARY CODE
    r.robot.settings(700, 300, 300, 200)
    r.robot.straight(200)
    r.robot.drive(225,45)






################################
# KEEP THIS AT THE END OF THE FILE
# This redirects to running main.
################################
if __name__ == "__main__":
    from main import main
    main()
