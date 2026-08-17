Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B5E4B04AF;
	Mon, 17 Aug 2026 21:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787003385; cv=none; b=NK947WQt3+JzmDhlszqCw5D/IOiOffn570EK6928Ew8mNMP7ApqahDKVHlhl7a0t+oVWXYEO4ZmauLIIJYsEJl3dZPZRRIS2jVULh6ngvSQn4nZ9QkBJ2/O5vNkj2N3WERNcy+X11QOdH5DQrgzBEnBlmjPzTSgdhADLmUxjrJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787003385; c=relaxed/simple;
	bh=fnzv4nfFmLb1Db1eWVPWcDqiSWZLZlo2mUuCicgODGM=;
	h=Date:Message-ID:From:To:Cc:Subject; b=ZyXB77Nk8QHtpKTx91MJzMw6fbLMEGhzWrztHvHZxri6CgdloocinmNum+R8pGM5JwfNZkoy+xHWD7Ce6TO8rDyozm07TNwvIr7hLhj74RT655g41s7esVRP+Z+0XUIcdyY6u4RBOO6T5vNku02ZHhopG4OT/OmNZohrlAJ9nZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AeIM559/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AeIM559/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703901F000E9;
	Mon, 17 Aug 2026 21:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787003383;
	bh=Tl4tG/aO+cxW71j0dGeJG4n7yJXFQskHDfmbVaRkJFM=;
	h=Date:From:To:Cc:Subject;
	b=AeIM559/Z27y28JFFKv7iR1PsAEi5Nn76KR2iEufZYr5K3l1s1exvQvrVBto39MID
	 rm1G9iipJCjhYIu8wW/ITdvgHreCPJxIhr2ElVZBihGSHrgjeL7gkwzW2ytnPbJZF5
	 69BGkSE3oCuSLyjhQ0ZjOPnJkkXNDTTEku8ipyvReUXyt0WuFmnvU5yxDn+AMdBcLY
	 U4TmsmuVG9e9cuowm8ezCT8wqVl4tfYXysC9E8nm12KXLbOSsKnZxbTGmgfnNkWTRU
	 zcWR4QCyvJMapvKz6cNXglXls6jRJp9lWal7u/60Ip11HzJyyh9xQmyxRLr/CkRJi9
	 WKCN8/zOLyx9Q==
Date: Mon, 17 Aug 2026 11:49:42 -1000
Message-ID: <e066a6c46c8b345bbb78c50ee9de81d3@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] cgroup: Changes for v7.3
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

The following changes since commit f0e6f20cb52b14c2c441f04e21cef0c95d498cac:

  Merge tag 'ntfs3_for_7.2' of https://github.com/Paragon-Software-Group/linux-ntfs3 (2026-06-24 10:05:53 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git tags/cgroup-for-7.3

for you to fetch changes up to 2d19207f3fc8e08bab3270af2e3835358ab1473a:

  selftests/cgroup: Remove redundant chown in test_cgcore_lesser_ns_open (2026-08-14 08:32:58 -1000)

----------------------------------------------------------------
cgroup: Changes for v7.3

- cpuset:

  - Attach path bug fixes: migrations spanning multiple source or
    destination cpusets were mishandled, most visibly leaving thread
    affinities stale when the controller is disabled in a threaded subtree.
    Configuration writes could also race an in-flight attach and apply stale
    state, and the deadline task count could get corrupted by concurrent
    updates, skewing SCHED_DEADLINE admission decisions.

  - Memory binding bug fixes: which node masks get applied differed between
    the binding update paths, and tasks cloned with CLONE_INTO_CGROUP
    skipped rebinding entirely. Rebinding also now runs once per process
    instead of repeating for every thread sharing the mm.

  - Overhead removals with no behavior change: CPU hotplug iterated tasks of
    cpusets that just inherit the parent's effective masks, and the
    slab-spreading task flag was still being maintained although the SLAB
    allocator that consumed it is long gone.

- Data-race annotations for benign races so that KCSAN reports stay
  meaningful, selftest coverage for the fixes above along with flakiness and
  portability fixes, and documentation corrections.

----------------------------------------------------------------
Guopeng Zhang (3):
      cgroup: Use data_race() for task->flags in task_css_set_check()
      cgroup/cpuset: Use WRITE_ONCE() for shared prs_err updates
      cgroup/cpuset: Remove obsolete PFA_SPREAD_SLAB task flag

Jian Guo (1):
      selftests/cgroup: Remove redundant cg_enter_current() call in test_core

Joe Simmons-Talbott (1):
      selftests/cgroup: Adjust cpu test duration based on HZ

Julia Lawall (1):
      cgroup: drop unneeded semicolon

Manuel Ebner (1):
      docs: cgroup: Fix bracket

Michal Koutný (1):
      selftests/cgroup: Add test for cpuset affinity on controller disable

Rui Qi (2):
      selftests/cgroup: Avoid awk -e in cpuset tests
      selftests/cgroup: Preserve CPU hotplug write errors

Shaojie Sun (3):
      selftests/cgroup: add user_usec sanity check in test_cpucg_nice
      cgroup/cpuset: Add test for partition root invalidation returning wrong CPUs
      selftests/cgroup: Remove redundant chown in test_cgcore_lesser_ns_open

Song Hu (1):
      selftests/cgroup: fix missing TAP output in test_hugetlb_memcg

Sun Shaojie (1):
      cgroup/cpu: document cpu.stat.local and clarify cpu.stat behavior

Tao Cui (2):
      Docs/admin-guide/cgroup-v2: fix delay_nsec unit in io.latency doc
      docs: cgroup-v2: mark memory.pressure and io.pressure as read-write

Waiman Long (14):
      cgroup/cpuset: Avoid unnecessary cpus & mems update in cpuset_hotplug_update_tasks()
      cgroup/cpuset: Rebind/migrate mm only for threadgroup leader in cpuset_update_tasks_nodemask()
      cgroup/cpuset: Make nr_deadline_tasks an atomic_t
      cgroup/cpuset: Fix node inconsistencies between cpuset_update_tasks_nodemask() and cpuset_attach()
      cgroup/cpuset: Prevent race between task attach and cpuset state change
      cgroup/cpuset: Put all task attach related variables into attach_ctx
      cgroup/cpuset: Add a cpuset_reserve_dl_bw() helper
      cgroup/cpuset: Expand the scope of cpuset_can_attach_check()
      cgroup/cpuset: Make attach_ctx.old_cs track task group leader
      cgroup/cpuset: Move mpol_rebind_mm/cpuset_migrate_mm() calls inside cpuset_attach_task()
      cgroup/cpuset: Support multiple source cpusets for cpuset_*attach()
      cgroup/cpuset: Support multiple destination cpusets for cpuset_*attach()
      cgroup/cpuset: Handle the special case of non-moving tasks in cpuset_can_attach()
      selftests/cgroup: Fix minor defects in test_cpuset

Yousef Alhouseen (1):
      tools/cgroup: iocost_monitor: parse help before importing drgn

Zenghui Yu (Huawei) (1):
      cgroup: Fix a typo of the function name in comment

Zhe Liu (1):
      docs: cgroup-v2: fix stale "io" controller introduction

 Documentation/admin-guide/cgroup-v1/cpusets.rst    |  42 +-
 Documentation/admin-guide/cgroup-v1/memcg_test.rst |   2 +-
 Documentation/admin-guide/cgroup-v2.rst            |  50 +-
 include/linux/cgroup-defs.h                        |   2 +-
 include/linux/cgroup.h                             |   2 +-
 include/linux/sched.h                              |   5 -
 kernel/cgroup/cgroup.c                             |   2 +-
 kernel/cgroup/cpuset-internal.h                    |  12 +-
 kernel/cgroup/cpuset-v1.c                          |  13 +-
 kernel/cgroup/cpuset.c                             | 569 +++++++++++++--------
 tools/cgroup/iocost_monitor.py                     |  10 +-
 .../selftests/cgroup/lib/include/cgroup_util.h     |   1 +
 tools/testing/selftests/cgroup/test_core.c         |  12 +-
 tools/testing/selftests/cgroup/test_cpu.c          |  45 +-
 tools/testing/selftests/cgroup/test_cpuset.c       | 247 +++++++++
 tools/testing/selftests/cgroup/test_cpuset_prs.sh  |  24 +-
 .../testing/selftests/cgroup/test_cpuset_v1_hp.sh  |   2 +-
 .../testing/selftests/cgroup/test_hugetlb_memcg.c  |  10 +-
 18 files changed, 747 insertions(+), 303 deletions(-)

-- 
tejun
