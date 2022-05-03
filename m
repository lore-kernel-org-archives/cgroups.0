From: Waiman Long <longman@redhat.com>
Subject: [PATCH v10 0/8] cgroup/cpuset: Major cpu partition code restructuring
Date: Tue,  3 May 2022 12:21:41 -0400
Message-ID: <20220503162149.1764245-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651594967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+g2uJIOUxcZwM6c5aOyAIEGRNprcj0Uo89xpRn5Hq6Y=;
        b=RzUdgkz9/IO2W32zeJ2z1fZxfZYBs8TdoId4J/tQ5pzUz34wkKj6P3zKDxSUmx6yO1/Qfg
        7it66MKRZhcwglkBUAPr1/86qS2Hj0iw9fYlqunFxXXCnrHg9RK2Y3maFPSq1KnlGQnjON
        1QSCrLv8icg/5NjPyANFcDQEIAK0kEw=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>

v10:
 - Relax constraints for changes made to "cpuset.cpus"
   and "cpuset.cpus.partition" as suggested. Now almost all changes
   are allowed.

v9:
 - Add a new patch 1 to remove the child cpuset restriction on parent's
   "cpuset.cpus".
 - Relax initial root partition entry limitation to allow cpuset.cpus to
   overlap that of parent's.
 - An "isolated invalid" displayed type is added to
   cpuset.cpus.partition.
 - Resetting partition root to "member" will leave child partition root
   as invalid.
 - Update documentation and test accordingly.

v8:
 - Reorganize the patch series and rationalize the features and
   constraints of a partition.
 - Update patch descriptions and documentation accordingly.

This patchset include the following enhancements to the cpuset v2
partition code.
 1) Allow partitions that have no task to have empty effective cpus.
 2) Relax the constraints on what changes are allowed in cpuset.cpus
    and cpuset.cpus.partition. However, the partition remain invalid
    until the constraints of a valid partition root is satisfied.
 3) Add a new "isolated" partition type for partitions with no load
    balancing which is available in v1 but not yet in v2.
 4) Allow the reading of cpuset.cpus.partition to include a reason
    string as to why the partition remain invalid.

 In addition, the cgroup-v2.rst documentation file is updated and
 a self test is added to verify the correctness the partition code.

Waiman Long (8):
  cgroup/cpuset: Add top_cpuset check in update_tasks_cpumask()
  cgroup/cpuset: Miscellaneous cleanups & add helper functions
  cgroup/cpuset: Allow no-task partition to have empty
    cpuset.cpus.effective
  cgroup/cpuset: Relax constraints to partition & cpus changes
  cgroup/cpuset: Add a new isolated cpus.partition type
  cgroup/cpuset: Show invalid partition reason string
  cgroup/cpuset: Update description of cpuset.cpus.partition in
    cgroup-v2.rst
  kselftest/cgroup: Add cpuset v2 partition root state test

 Documentation/admin-guide/cgroup-v2.rst       | 145 ++--
 kernel/cgroup/cpuset.c                        | 712 +++++++++++-------
 tools/testing/selftests/cgroup/Makefile       |   5 +-
 .../selftests/cgroup/test_cpuset_prs.sh       | 674 +++++++++++++++++
 tools/testing/selftests/cgroup/wait_inotify.c |  87 +++
 5 files changed, 1295 insertions(+), 328 deletions(-)
 create mode 100755 tools/testing/selftests/cgroup/test_cpuset_prs.sh
 create mode 100644 tools/testing/selftests/cgroup/wait_inotify.c

-- 
2.27.0

