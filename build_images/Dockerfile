FROM cassandra

ARG HIVE_DOWNLOAD_URL=https://s3.amazonaws.com/public-repo-1.hortonworks.com/HDP/centos7/2.x/updates/2.6.5.1001/tars/hive/apache-hive-1.2.1000.2.6.5.1001-8-bin.tar.gz
ARG RUBY_GIT_URL=https://github.com/sstephenson/ruby-build.git
ARG RBENV_URL=https://github.com/sstephenson/rbenv.git

ENV PATH=$PATH:/usr/local/hive/bin:/usr/local/hive/sbin

RUN mkdir -p /path/to/workdir
WORKDIR /path/to/workdir

RUN yum update -y

# Install rbenv
RUN yum install -y epel-release nodejs git-core zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison curl sqlite-devel && \
    git clone ${RBENV_URL} .rbenv && \
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile && \
    echo 'eval "$(rbenv init -)"' >> ~/.bash_profile && \
    exec $SHELL

# Install Ruby
RUN git clone ${RUBY_GIT_URL ~/.rbenv/plugins/ruby-build && \
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile && \
    exec $SHELL
RUN rbenv install -v 2.2.1 && \
    gem install rails

# Generate a new Rails application
RUN rails new blog ---skip-active-record --skip-active-storage -T --skip-bundle
WORKDIR /path/to/blog
RUN bundle add cequel && \
    bundle add activemodel-serializers-xml && \
    rails g scaffold post title body && \
    root 'posts#index' && \
    rails g cequel:configuration && \
    rails cequel:keyspace:create && \
    rails cequel:migrate

COPY files/post.rb app/models/post.rb

## I had to search these default ports ##
EXPOSE 3000 7000 9042 7001

ENTRYPOINT ["cassandra", "-f"]
CMD ["rails s"]





