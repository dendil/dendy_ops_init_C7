[TOC]



## Get started

### Install Git

```bash
yum install git -y
git --version
```

### Clone 

Run below commands on an empty directory:
```bash
git clone https://github.com/dendil/dendy_ops_init_C7.git
cd dendy_ops_init_C7
find . -name '*.sh' -exec chmod u+x {} \;
```



### init centos7
```bash
bash  init.sh
```



### Use Aliyun Yum repo

```bash
/opt/components/aliyun/use_aliyun_yum_repo.sh
```



### Install tools

Install some basic tools, e.g. wget, vim, etc.

```bash
/opt/components/tools/install_tools.sh
```

## Increase ulimit

```bash
/opt/components/utils/increase_ulimit.sh
```



### Set `ntp` time sync

```bash
# Recommend to set ntp time sync with chrony
/opt/components/timedate/sync_timedate_chrony.sh

# Or set ntp time sync with ntp
/opt/components/timedate/sync_timedate_ntp.sh
```



### Install OpenJDK

Install OpenJDK8:

```bash
/opt/components/openjdk/install_openjdk8.sh
```

### Install Jenkins

> Make sure OpenJDK8 is installed

Install Jenkins by Jenkins Yum repo:

```bash
/opt/components/jenkins/install_jenkins.sh
```



Or install Jenkins by Jenkins mirror:

```bash
/opt/components/jenkins/install_jenkins_rpm.sh
```



### Install Build Tools

### Install Gradle

```bash
# Install default Gradle (Gradle5.4)
/opt/components/gradle/install_gradle.sh

# Install specific Gradle version
# Example: /opt/components/gradle/install_gradle.sh 4.6
/opt/components/gradle/install_gradle.sh <version>
```



### Install Maven

```bash
# Install default Maven (Maven3.6.0)
/opt/components/maven/install_maven.sh

# Install specific Maven version
# /opt/components/maven/install_maven.sh 3.5.0
/opt/components/maven/install_maven.sh <version>
```



### Install GitLab CE

Install GitLab CE with HTTP:

```bash
# /opt/components/gitlab/install_gitlab_ce_http.sh gitlab.xdevops.cn
/opt/components/gitlab/install_gitlab_ce_http.sh <gitlab_domain>
```



Install GitLab CE with HTTPS using manual SSL cert:

```bash
# /opt/components/gitlab/install_gitlab_ce_https.sh gitlab.xdevops.cn "/C=CN/ST=Guangdong/L=Guangzhou/O=xdevops/OU=xdevops/CN=gitlab.xdevops.cn"
/opt/components/gitlab/install_gitlab_ce_https.sh <gitlab_domain> <ssl_cert_subj>
```



Configure HTTPS for an existing HTTP GitLab CE using manual SSL cert:

```bash
# Set domain name mapping in host file if necessary
# echo "$(/opt/components/utils/get_ip.sh) gitlab.xdevops.cn" >> /etc/hosts
echo "$(/opt/components/utils/get_ip.sh) <gitlab_domain>" >> /etc/hosts

# /opt/components/gitlab/configure_gitlab_ce_manual_ssl.sh gitlab.xdevops.cn "/C=CN/ST=Guangdong/L=Guangzhou/O=xdevops/OU=xdevops/CN=gitlab.xdevops.cn"
/opt/components/gitlab/configure_gitlab_ce_manual_ssl.sh <gitlab_domain> <ssl_cert_subj>
```



> Even throuh GitLab integrate Letsencrypt natively, but I have encountered a Letsencrypt error when run `gitlab-ctl reconfigure` and haven't resolved it, so I have to use manual SSL cert at this moment.



### Install Docker CE

Install Docker latest version:

```bash
/opt/components/docker/install_docker_ce.sh
```

Install a Docker specific version:

```bash
# Example: /opt/components/docker/install_docker_ce.sh 18.03.0
/opt/components/docker/install_docker_ce.sh <version>
```

Install Docker 17.03.2 (older version):

```bash
/opt/components/docker/install_docker_ce_17_03_2.sh
```



### Install Docker Compose

```bash
# Install default Docker Compose (Docker Compose 1.24.0)
/opt/components/docker-compose/install_docker_compose.sh

# Install specific Docker Compose version
# /opt/components/docker-compose/install_docker_compose.sh 1.24.0
/opt/components/docker-compose/install_docker_compose.sh <version>
```



### Install Harbor

```bash
# Install default Harbor (Harbor 1.8.0)
/opt/components/harbor/install_harbor.sh

# Install specific Harbor version,e.g Harbor 1.7.5
# /opt/components/harbor/install_harbor.sh 1.7 5
/opt/components/harbor/install_harbor.sh <major_version> <minor_version>
```



### Install Nexus

```bash
# Install default Nexus (nexus-3.16.1-02)
/opt/components/nexus/install_nexus.sh

# Install specific Nexus version
# /opt/components/nexus/install_nexus.sh 3.16.1-02
/opt/components/nexus/install_nexus.sh <version>
```



### Install Redmine

```bash
/opt/components/redmine/install_redmine.sh
```



### Install SonarQube

```bash
/opt/components/sonarqube/install_sonarqube.sh
```

### Install GitLab with Docker Compose

```bash
/opt/components/gitlab-docker/install_gitlab.sh
```


