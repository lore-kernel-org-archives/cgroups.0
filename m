From: Waiman Long <longman@redhat.com>
Subject: [PATCH-cgroup v4 0/6] cgroup/cpuset: Add new cpuset partition type & empty effecitve cpus
Date: Tue, 10 Aug 2021 23:06:01 -0400
Message-ID: <20210811030607.13824-1-longman@redhat.com>
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628651201;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=GVV0lBAl3hD0f4Dk5D3L8gm1OSCHD8KzaozfnnFi9L0=;
        b=DdBb5aXMW9xSteoL9Vvx8wryHlU0W9v56GPw7PDcYl5g4uUmY9X0rJ9lt/5f8EPdrU2L+s
        eHDwBzyflf3+cudDcPwwSAVyepaz8W73jMfyPYe8kjI+aYkIhaaXRXSnAbmbtWglOB6UwL
        /7yJs0s6hmQMs+5PC4amHMHxNGjDr6I=
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>

v4:
 - Rebased to the for-5.15 branch of cgroup git tree and dropped the
   first 3 patches of v3 series which have been merged.
 - Beside prohibiting violation of cpu exclusivity rule, allow arbitrary
   changes to cpuset.cpus of a partition root and force the partition root
   to become invalid in case any of the partition root constraints
   are violated. The documentation file and self test are modified
   accordingly.

v3:
 - Add two new patches (patches 2 & 3) to fix bugs found during the
   testing process.
 - Add a new patch to enable inotify event notification when partition
   become invalid.
 - Add a test to test event notification when partition become invalid.

v2:
 - Drop v1 patch 1.
 - Break out some cosmetic changes into a separate patch (patch #1).
 - Add a new patch to clarify the transition to invalid partition root
   is mainly caused by hotplug events.
 - Enhance the partition root state test including CPU online/offline
   behavior and fix issues found by the test.

This patchset makes four enhancements to the cpuset v2 code.

 Patch 1: Enable event notification on "cpuset.cpus.partition" whenever
 the state of a partition changes.

 Patch 2: Properly handle partition root tree and make partition
 invalid in case changes to cpuset.cpus violate any of the partition
 root constraints.

 Patch 3: Add a new partition state "isolated" to create a partition
 root without load balancing. This is for handling intermitten workloads
 that have a strict low latency requirement.

 Patch 4: Allow partition roots that are not the top cpuset to distribute
 all its cpus to child partitions as long as there is no task associated
 with that partition root. This allows more flexibility for middleware
 to manage multiple partitions.

Patch 5 updates the cgroup-v2.rst file accordingly. Patch 6 adds a new
cpuset test to test the new cpuset partition code.

Waiman Long (6):
  cgroup/cpuset: Enable event notification when partition state changes
  cgroup/cpuset: Properly handle partition root tree
  cgroup/cpuset: Add a new isolated cpus.partition type
  cgroup/cpuset: Allow non-top parent partition root to distribute out
    all CPUs
  cgroup/cpuset: Update description of cpuset.cpus.partition in
    cgroup-v2.rst
  kselftest/cgroup: Add cpuset v2 partition root state test

 Documentation/admin-guide/cgroup-v2.rst       | 104 +--
 kernel/cgroup/cpuset.c                        | 282 +++++---
 tools/testing/selftests/cgroup/Makefile       |   5 +-
 .../selftests/cgroup/test_cpuset_prs.sh       | 632 ++++++++++++++++++
 tools/testing/selftests/cgroup/wait_inotify.c |  86 +++
 5 files changed, 980 insertions(+), 129 deletions(-)
 create mode 100755 tools/testing/selftests/cgroup/test_cpuset_prs.sh
 create mode 100644 tools/testing/selftests/cgroup/wait_inotify.c

-- 
2.18.1

