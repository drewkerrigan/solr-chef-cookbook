#
# Author:: Drew Kerrigan (<dr.kerrigan@gmail.com>)
# Cookbook Name:: solr
#
# Copyright (c) 2013 Basho Technologies, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name              "solr"
maintainer        "Drew Kerrigan"
maintainer_email  "dr.kerrigan@gmail.com"
license           "Apache 2.0"
description       "Installs and configures Solr"
version           "0.1.a"
depends           "java"

recipe            "solr", "Installs Solr from a package"


%w{ubuntu debian centos redhat fedora}.each do |os|
  supports os
end