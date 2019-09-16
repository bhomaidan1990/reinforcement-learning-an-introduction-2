
# Reinforcement Learning: An Introduction
### by _Richard Sutton_ & _Andrew Barto_ (2nd edition)


## Solutions to Exercises and Programming Problems


This repository contains my answers to exercises and programming problems from the [reinforcement learning bible](https://www.amazon.com/Reinforcement-Learning-Introduction-Adaptive-Computation/dp/0262039249). I'm not sure if it's a good idea to make the solutions public because authors' intention clearly is the opposite. Despite initially not liking it, I have to admit it's a brilliant decision. Not having the answers easily available makes one think of creative ways how to check whether what he just came up is correct. The sanity checking process frequently reveals much more about the topic than working out the answer.

On the other hand, Googling for the answer helped me to get unstuck in many cases. So it would be selfish of me not to return the favor to others. Especially beacause the answers are scattered all over the internet so there's no single place to look them up. Besides that, formulation of many of the programming problems is very deceiving. Initially it looks like an innocent, hour long, fun coding challenge. More often than not it turns into an entire weekend long wrestling with a pig in the mud :)

If you see a wrong answer, please, let me know by opening an [issue](https://github.com/vojtamolda/reinforcement-learning-an-introduction/issues/). All the programming problems use [OpenAI gym](https://gym.openai.com/) as the API between the agent and the environment. So checking the [documentation](https://gym.openai.com/docs/) may help to get a faster start. The code is written in [Python 3](https://python.org) and uses [numpy](https://numpy.org/) library for vectorized linear algebra operations.


---


### Chapter 1 - Introduction
 - [`chapter01.pdf`](chapter01/chapter01.pdf)


## Part I - Tabular Solution Methods

### Chapter 2 - Multi-armed Bandits
 - [`chapter02.pdf`](chapter02/chapter02.pdf)
 - Non-Stationary Problem - [`exercise02-05.ipynb`](chapter02/exercise02-05.ipynb)
 - Non-Stationary Hyper-Parameter Sweep - [`exercise02-11.ipynb`](chapter02/exercise02-11.ipynb)

### Chapter 3 - Finite Markdov Decision Processes
 - [`chapter03.pdf`](chapter03/chapter03.pdf)

### Chapter 4 - Dynamic Programming
 - [`chapter04.pdf`](chapter04/chapter04.pdf)
 - Jack's Car Rental - [`exercise04-07.ipynb`](chapter04/exercise04-07.ipynb)
 - Gambler's Problem - [`exercise04-09.ipynb`](chapter04/exercise04-09.ipynb)

### Chapter 5 - Monte Carlo Methods
 - [`chapter05.pdf`](chapter05/chapter05.pdf)
 - Racetrack - [`exercise05-12.ipynb`](chapter05/exercise05-12.ipynb)

### Chapter 6 - Temporal-Difference Learning
 - [`chapter06.pdf`](chapter06/chapter06.pdf)
 - Windy Gridworld with King’s Moves - [`exercise06-09.ipynb`](chapter06/exercise06-09.ipynb)
 - Windy Gridworld with Stochastic Wind - [`exercise06-10.ipynb`](chapter06/exercise06-10.ipynb)
 
### Chapter 7 - n-step Bootstrapping
 - [`chapter07.pdf`](chapter07/chapter07.pdf)
 - TD Error Sum Algorithm - [`exercise07-02.ipynb`](chapter07/exercise07-02.ipynb)
 - Data Efficiency of n-Step Off-Policy Methods - [`exercise07-10.ipynb`](chapter07/exercise07-10.ipynb)

### Chapter 8 - Planning and Learning with Tabular Methods
 - [`chapter08.pdf`](chapter08/chapter08.pdf)
 - Dyna-Q+ with Action Exploration Bonus - [`exercise08-04.ipynb`](chapter08/exercise08-04.ipynb)
 - Trajectory Sampling Experiment - [`exercise08-08.ipynb`](chapter08/exercise08-08.ipynb)


## Part II - Approximate Methods
