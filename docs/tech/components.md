# Components

AI-Dojo comprises an interconnected set of components addressing specific needs in building the infrastructure, training
the agents, etc. Most of these components can be run in a standalone mode and as such, they are living in their own
repositories and have a separate documentation. This page indexes these components and discusses when the user has to 
refer to their documentation.

## General

### AI-Dojo

This eponymous component is the primary part responsible for the orchestration and running of other components,
launching tasks, providing information to the frontend, etc. It is started as a part of the deployment processes and
provides an API to control the rest of the system.

Normally, users interact with this component through the frontend, but using its REST API, more complex workflows can be 
orchestrated.

- [Link to the project repository](https://gitlab.com/ai-dojo-public/ai-dojo/)

### Frontend

The frontend for AI-Dojo is a web-based user interface that enables control of the most common functions. The frontend
is aimed towards users, who want to test or develop their own agents. Creators of scenarios and developers of more
low-level components, such as behavioral models, will likely need more direct interaction with system components.

The usage of the frontend is covered in the [User guide](../user/quickstart.md).

- [Link to the project repository](https://gitlab.com/ai-dojo-public/frontend/)

## Simulation & Emulation

### CYST - core

CYST is a multi-agent discrete-event simulation framework tailored for cybersecurity domain. Its goal is to enable
high-throughput and realistic simulation of cybersecurity interactions in arbitrary infrastructures. In AI-Dojo, it
is responsible for controlling both the simulation and emulation and to provide a unified interface to agents. 

Users directly interact with CYST anytime they are developing agents or a backend components, as CYST provides an API 
for all the simulation and emulation layers.

- [Link to project documentation](https://pages.gitlab.com/ai-dojo-public/cyst-core/)
- [Link to the project repository](https://gitlab.com/ai-dojo-public/cyst-core)

### Cryton

Cryton is a Cron-like red team framework for complex attack scenarios automation and scheduling. It provides ways to 
plan, execute, and evaluate multistep attacks. In AI-Dojo it enables execution of emulated attack actions by utilizing 
various offensive security tools.

As Cryton is the cornerstone of the current emulation layer, users usually interact with it when running agents in the
emulated environment. Nevertheless, Cryton's actions are transparent to users, so they are only utilizing its 
visualization layer that is channeled into the frontend.

- [Link to the project group](https://gitlab.ics.muni.cz/cryton)
- [Link to the documentation](https://cryton.gitlab-pages.ics.muni.cz/)

### CYST - platform - Docker + Cryton

This component provides and integration layer between cyst-core engine and Cryton. It implements necessary primitives 
that enable execution of training runs within the docker-based platform, which uses the unified API of CYST. Aside 
from being selectable as an execution layer, this component should be completely transparent to the user.

- [Link to the project repository](https://gitlab.com/ai-dojo-public/cyst-platform-docker-cryton)

### CYST - models - dojo-cryton

This component provides behavioral models for simulation and emulation that utilize either cyst-core, or the cyst
docker+cryton platform. It implements a set of actions relevant for the initial AI-Dojo scenarios. If needed, this
component can be easily extended by new actions.

- [Link to the project repository](https://gitlab.com/ai-dojo-public/cyst-models-dojo-cryton)

### dr-emu

The primary responsibility of this component is building of semi-realistic network topologies using Docker to provide
an emulation layer for training runs. It stretches the abilities of Docker to provide a lightweight alternative to full
virtualization, while enabling creation of a network-connected sandbox.

- [Link to the project repository](https://gitlab.com/ai-dojo-public/dr-emu)

### CIF

This component, Custom Image Forge, enables creation of Docker images that exist as a collection of multiple services 
with a shared disk space, thus emulating a (semi-)complete virtual machine. Its main purpose is to provide dr-emu with
images that enable realization of local exploits that would otherwise be impossible in a typical microservice Docker
fashion.

- [Link to the project repository](https://gitlab.com/ai-dojo-public/cif)

### Firehole

Firehole addresses one of the pressing issues in vulnerability emulation - the gradual vanishing of suitable images of
vulnerable services. It sits as a proxy layer in front of services and intercepts incoming requests. If it recognizes a
working exploit, it emulates its effect. Therefore, it enables to reduce the task of maintaining the vulnerable image 
library to maintaining of exploit causes and effects, regardless of the underlying version of the service.

- [Link to the project repository](https://gitlab.com/ai-dojo-public/firehole)

## Content generation

### PAGAN

This component enables parametrized generation of network terrains and scenarios. It enables evading one of the most
costly process in agent training - preparation of training data/environments. The scenarios it generates are provably
accurate and enable large degree of customization to help tailor the training process.

- [Link to the research paper](https://dl.acm.org/doi/10.1145/3664476.3664523)
- [Link to the project repository](https://gitlab.com/ai-dojo-public/pagan)

### Gringotts

This component acts as a knowledgebase that PAGAN is using as a basis of scenario generation. It contains a collection
of useful information about software (via CPE), a collection of vulnerabilities & weaknesses and information (via CVE,
CWE), relations between software, enablers and attack techniques, etc.

- [Link to the project repository](https://gitlab.com/ai-dojo-public/gringotts)

## Agent interoperability

### CYST - agents - NetSecEnv

While various agents can be easily implemented within the AI-Dojo platform, the collection of agents that is distributed
with AI-Dojo uses a separate system for tracking and managing their actions, ensuring state and reward translations, 
goal observation, parallelization, etc. Therefore, this component provides an agent that acts as a proxy in executed 
scenarios for that system. The agent exposes a REST API that is used to control it within the simulation/emulation.

- [Link to the project repository](https://gitlab.com/ai-dojo-public/cyst-agents-netsecenv)

## Agents

### Random agent

Random agent is a simple baseline agent that selects action randomly in each step from available valid actions with 
uniform probability. This random agent is primarily used as a baseline in comparison with other agents and to evaluate 
the complexity of the scenario, performance of the defenders and other comparisons. For reproducibility, it is 
recommended to use fix random seed when using this agent.

- [Link to project repository](https://github.com/stratosphereips/NetSecGameAgents/tree/aidojo-stable/agents/attackers/random)

### Interactive agent

The interactive agent primary use is to allow human users to play the game. It provides either CLI or web interface 
which visualize the state of the game There are several models of operation of this agent:

- Human, without autocompletion of fields nor assistance.
- Human, with autocompletion of fields, but without assistance.
- Human, with autocompletion of fields and LLM assistance.


- [Link to project repository](https://github.com/stratosphereips/NetSecGameAgents/tree/aidojo-stable/agents/attackers/interactive_tui)

### Q-learning agent

A **Q-learning agent** learns to act in an environment by **estimating the quality (Q-value)** of taking a certain 
action in a certain state.

- It keeps a **Q-table**: a lookup table where each entry `Q(s, a)` stores the agent's estimate of the **expected 
cumulative reward** from state `s` after taking action `a`.
- The agent **updates** the Q-values after each interaction with the environment, using the formula:

`Q(s, a) ← Q(s, a) + α [ r + γ max_a' Q(s', a') - Q(s, a) ]`

- [Link to project repository](https://github.com/stratosphereips/NetSecGameAgents/tree/aidojo-stable/agents/attackers/q_learning)

### Sarsa agent
 
A **SARSA agent** (State-Action-Reward-State-Action) learns to act in an environment by **updating the value (Q-value)**
of a state-action pair based on the action it *actually* takes, not the best possible action.

- It keeps a **Q-table**: a lookup table where each entry `Q(s, a)` stores the agent's estimate of the **expected 
cumulative reward** from state `s` after taking action `a`.
- The agent **updates** the Q-values after each interaction with the environment, using the formula:

`Q(s, a) ← Q(s, a) + α [ r + γ Q(s', a') - Q(s, a) ]`

- [Link to project repository](https://github.com/stratosphereips/NetSecGameAgents/tree/aidojo-stable/agents/attackers/sarsa)

### LLM agent

The LLM agent is based on the large language model. It uses advance prompting techniques to process the textual 
description of the role of the agent, its goals, the current state of the game and previous actions to generate the next
action. Several publicly available language models were tested and can be used with this agent. Details about the agent 
architecture, the prompts and its performance can be found in [Out of the Cage How Stochastic Parrots Win in Cyber Security
Environments](https://arxiv.org/pdf/2308.12086)

- [Link to project repository](https://github.com/stratosphereips/NetSecGameAgents/tree/aidojo-stable/agents/attackers/llm_qa)

### Random defender

Random agent is a simple baseline agent that selects action randomly in each step from available valid actions with 
uniform probability. This random agent is primarly used as a baseline in comparison with other agents and to evaluate 
the complexity of the scenario, performance of the defenders and other comparisons. For reproducibility, it is 
recommended to use fix random seed when using this agent.

- [Link to project repository](https://github.com/stratosphereips/NetSecGameAgents/tree/aidojo-stable/agents/defenders/random)

### Stochastic defender

Stochastic defender makes the blocking based on heuristic and probabiliy distribution over the action types. The agent 
repeatedly checks the logs in each host by using `FindData` action and analyzing the content. This agent implements a 
detection heuristic that only applies probabilistic detection after certain suspicious patterns have been observed in an
agent’s behavior. It considers the most recent actions in the log within a **fixed-size time window** (default size is 5)
to analyze short-term patterns.

The agent checks for three types of suspicious behavior: (1) a high ratio of the same action type in the recent window, 
(2) multiple consecutive occurrences of the same action type, and (3) frequent repetition of the exact same parametrized
action across the entire episode. For each check, it compares the observed statistics against predefined thresholds that
differ for each action type. For instance, some actions are flagged if their proportion in the window is high, while 
others are flagged if they are repeated too many times consecutively or across the whole episode.

- [Link to project repository](https://github.com/stratosphereips/NetSecGameAgents/tree/aidojo-stable/agents/defenders/probabilistic)

### SLIPS defender

SLIPS defender is based on open-source ML-drived IDS called [Stratoshpere Linux IPS]
(https://github.com/stratosphereips/StratosphereLinuxIPS). It is using wide range of modules to detect suspicious 
behavior in the network traffic. SLIPS agent is directly connected to CYST simulation engine as it operates on Netflows,
not the high-level GameState representation.

- [Link to project repository]()

### Random benign agent

Random benign agent is a limited version of the attacker. It can only perform a subset of action (Finding hosts and data
and moving data). The agent has a APM limit which can be modified when starting.

- [Link to project repository](https://github.com/stratosphereips/NetSecGameAgents/blob/aidojo-stable/agents/benign/random/benign_random_agent.py)

## Deployment

Deployment of the platform is handled through the docker compose script that is distributed with this user guide.

- [Link to deployment repository](https://gitlab.com/ai-dojo-public/ai-dojo-user-guide)
