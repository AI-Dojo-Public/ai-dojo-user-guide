Given the large number of components and repositories the AI-Dojo project consists of, we provide a relatively simple 
and unified approach to project deployment and development. The deployment process differs based on your intentions and
needs. We consider three categories of needs:

- *Pure users* - who want to try out the system, or do analyses of already existing agents without any further development. 
- *Agent and plug-in developers* - who want to develop their own agents or AI-Dojo plugins and test them within AI-Dojo.
- *System developers* - who want to extend or modify AI-Dojo codebase. 

The following guide is structured according to these categories. 

## 1. Pure users

For pure users the whole system can be easily installed through Docker.

### Requirements

- [Docker Compose](https://docs.docker.com/compose/install/){target="_blank"}
- `curl` / `wget`
- System with **4096 MB of RAM** and **2 CPU cores**

### Deployment

Download the Compose config file to any location:

=== "curl"

    ```shell
    curl -O https://gitlab.com/ai-dojo-public/ai-dojo-user-guide/-/raw/master/docker-compose.yml
    ```

=== "wget"

    ```shell
    wget https://gitlab.com/ai-dojo-public/ai-dojo-user-guide/-/raw/master/docker-compose.yml
    ```

And then just run it:
```shell
docker compose up -d
```

The system should be up and running in at most a couple of minutes (depending on the speed of your network connection 
and the power of your HW), subsequent launching should be much faster. You can check the system status by navigating to
the [AI-Dojo frontend](http://127.0.0.1:8000), which is the last component to launch.

### Additional agents and system persistence

Ai-Dojo enables you to install agents from various sources through the [frontend](agents.md). These agents are installed
to a persistent virtual environment in a Docker volume. This way, newly installed agents survive shutdown/restart of the
Docker engine. However, this can also mean that a faulty agent can get stuck in the system without an option to 
correctly remove it. In such case, you need to remove the volume from the system and repair the system. This action, 
however, means that you will lose all other installed agents and will have to reinstall them.

```shell
docker volume ls
docker volume rm <prefix>dojo_venv
docker compose up -d
```

## 2. Agent and plug-in developers

Agent and plug-in developers follow the same procedure as pure users. However, they need to make their own creations
accessible to the AI-Dojo platform. To do this, you need to modify the `docker-compose.yml` and add your development
directories as mounted volumes.

Consider that you have two AI-Dojo related projects in separate directories:

```shell
/home/usr/repositories/agents/my-awesome-agent-01
/home/usr/repositories/plugins/new-behavioral-model
```

You would then modify the `docker-compose.yml` like this:

```yaml
  dojo:
    volumes:
      - /home/usr/repositories/agents/my-awesome-agent-01:/modules/my-awesome-agent-01
      - /home/usr/repositories/plugins/new-behavioral-model:/modules/new-behavioral-model
```

When you run the `docker compose up -d`, AI-Dojo goes through all the top-level directories in the `/modules` directory
and attempts to install them into the underlying virtual environment in the editable mode. This way, when you make 
changes into your codebase, this changes will automatically propagate inside AI-Dojo and you can, e.g., run a new 
simulation run and test your modifications without needing to restart AI-Dojo.

## 3. System developers

System developers are expected to clone the repositories of project components that they want to modify. Once they have
them, they need to modify the downloaded `docker-compose.yml` to not build the particular component, by commenting out 
respective image build instructions.

There is no clear mapping between an image and respective repositories, though. For example, the AI-Dojo backend 
currently requires four other components: CYST core, CYST - models - Dojo+Cryton, CYST - platform - Docker+Cryton, and 
CYST - agents - NetSecEnv. 

If you know that your changes will be isolated to the AI-Dojo backend then there is no issue - the remaining components
will be downloaded and installed by Poetry through normal installation process. If, however, you know that you will be
modifying multiple dependent components, then you have to transitively change the dependency locations in 
`pyproject.toml` of all components that are going to use the modified component. This is a typical issue with CYST - 
core. If you are to modify it, the path must be changed in all dependent components, otherwise Poetry will error out
with version mismatch.

The components' paths are prepared in `pyproject.toml` files and if your repository structure is the same as the AI-Dojo 
group, you just need to (un)comment it here.

Example:
```toml
[tool.poetry.dependencies]
python = ">3.11.0, <4.0.0"
# Use CYST components' local paths and not remote git repositories if you also want to hack on them. Beware that you
# will have to make this change in all other dependent projects that will be using the same dependency (this
# typically happens with cyst-core).
# cyst-core = {git = "https://gitlab.com/ai-dojo-public/cyst-core.git", branch = "master" }
cyst-core = {path = "../cyst-core", develop = true}
# cyst-models-dojo-cryton = {git = "https://gitlab.com/ai-dojo-public/cyst-models-dojo-cryton.git", branch = "master" }
cyst-models-dojo-cryton = { path = "../cyst-models-dojo-cryton", develop=true }
# cyst-platform-docker-cryton = {git = "https://gitlab.com/ai-dojo-public/cyst-platform-docker-cryton.git", branch = "master" }
cyst-platform-docker-cryton = { path = "../cyst-platform-docker-cryton", develop=true }
# cyst-agents-netsecenv = {git = "https://gitlab.com/ai-dojo-public/cyst-agents-netsecenv.git", branch = "master" }
cyst-agents-netsecenv = { path = "../cyst-agents-netsecenv", develop=true }
```