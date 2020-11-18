Rollout framwork v1.0

##### DATA MODEL #####

1. Host -> One Name (1->1) and one IP (1->1) [rollout.config]

2a. One Host -> multiple templates (1->1..n) [./templates/*], but one a time (1->1) [rollout.config]
2b. One template -> multiple hosts (1->1..n) [rollout.config, ./templates/*]

3. One configuration -> one host (1->1) and one template (1->1) [./configs/*]

4a. One template -> one build file (1->1)  [./builds/*] and multiple hosts (1->1..n) [rollout.confg]
4b. One build file -> one template (1->1) [./builds/*] and multiple hosts (1->1..n) [rollout.config {via 2a.}]


##### DIRECTORIES #####

User directories (to be modified by User):
    ./templates: Configuration templates containing at least a "sattelite.sh"
    ./configs: Host specifc configurations for templates
    ./builds: Template build configuration containing build actions to build working configurations out of templates and host specifc configurations


Rollout internal directories (NOT to be modified by User):
    ./files: Contains (hopefully) working configurations out of templates and host specifc configurations, ready for deployment.
             Configurations are organized in directories named by Hostnames. These are symlinked by Links named by Host-IPs.
    ./scripts: Contains Rollout framwork scripts