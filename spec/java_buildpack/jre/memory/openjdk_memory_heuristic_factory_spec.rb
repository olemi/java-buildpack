# Encoding: utf-8
# Cloud Foundry Java Buildpack
# Copyright (c) 2013 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'
require 'java_buildpack/jre/memory/openjdk_memory_heuristic_factory'
require 'java_buildpack/util/tokenized_version'

module JavaBuildpack::Jre

  describe OpenJDKMemoryHeuristicFactory do

    SIZES = { 'a' => 'b' }
    HEURISTICS = { 'c' => 'd' }
    PRE_8 = JavaBuildpack::Util::TokenizedVersion.new('1.7.0')
    POST_8 = JavaBuildpack::Util::TokenizedVersion.new('1.8.0')
    EXPECTED_JAVA_MEMORY_OPTIONS = { 'heap' => '-Xmx', 'metaspace' => '-XX:MaxMetaspaceSize=', 'permgen' => '-XX:MaxPermSize=', 'stack' => '-Xss' }

    it 'should pass the appropriate constructor parameters for versions prior to 1.8' do
      WeightBalancingMemoryHeuristic.stub(:new).with(SIZES, HEURISTICS, %w(heap stack native permgen), EXPECTED_JAVA_MEMORY_OPTIONS)
      OpenJDKMemoryHeuristicFactory.create_memory_heuristic(SIZES, HEURISTICS, PRE_8)
    end

    it 'should pass the appropriate constructor parameters for versions 1.8 and higher' do
      WeightBalancingMemoryHeuristic.stub(:new).with(SIZES, HEURISTICS, %w(heap stack native metaspace), EXPECTED_JAVA_MEMORY_OPTIONS)
      OpenJDKMemoryHeuristicFactory.create_memory_heuristic(SIZES, HEURISTICS, POST_8)
    end
  end

end
