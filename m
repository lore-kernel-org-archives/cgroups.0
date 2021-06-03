From: Waiman Long <longman@redhat.com>
Subject: [PATCH 0/5] cgroup/cpuset: Enable cpuset partition with no load balancing
Date: Thu,  3 Jun 2021 17:24:11 -0400
Message-ID: <20210603212416.25934-1-longman@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622755493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=I7Je95OOknB79OPSw/FKhXFURHd0Sf3BEVJm/9BIKEw=;
        b=bnohuAg2YecIkqbajG00yS8pND2TgomI1VgBjiyuXgGPleGDoYKtt3qTsiROHIkS+j/PQ+
        VPEBLA7z42/kjQcZr/CoZgfYBjzHkBzUFZ8m/SWgB6rH/aCF+ljfgz6An6yB3cuyKwtiSd
        3q8AxpnmtAYhKYrRY124lp1i5IxwpuQ=
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Waiman Long <longman@redhat.com>

This patchset makes the following two major changes to the cpuset v2 code:

 Patch 2: Add a new partition state "root-nolb" to create a partition
 root with load balancing disabled. This is for handling intermitten
 workloads that have a strict low latency requirement.

 Patch 3: Allow partition roots that are not the top cpuset to distribute
 all its cpus to child partitions as long as there is no task associated
 with that partition root. This allows more flexibility for middleware
 to manage multiple partitions.

Patch 4 updates the cgroup-v2.rst file accordingly. Patch 5 adds a test
to test the new cpuset partition code.

Waiman Long (5):
  cgroup/cpuset: Don't call validate_change() for some flag changes
  cgroup/cpuset: Add new cpus.partition type with no load balancing
  cgroup/cpuset: Allow non-top parent partition root to distribute out
    all CPUs
  cgroup/cpuset: Update description of cpuset.cpus.partition in
    cgroup-v2.rst
  kselftest/cgroup: Add cpuset v2 partition root state test

 Documentation/admin-guide/cgroup-v2.rst       |  19 ++-
 kernel/cgroup/cpuset.c                        | 124 +++++++++++----
 tools/testing/selftests/cgroup/Makefile       |   2 +-
 .../selftests/cgroup/test_cpuset_prs.sh       | 141 ++++++++++++++++++
 4 files changed, 247 insertions(+), 39 deletions(-)
 create mode 100755 tools/testing/selftests/cgroup/test_cpuset_prs.sh

-- 
2.18.1

