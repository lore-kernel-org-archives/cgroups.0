From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup changes for v4.21-rc1
Date: Thu, 27 Dec 2018 18:16:05 -0800
Message-ID: <20181228021605.GI2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=jjHgTJ4aRr18V+ui2gibzCqSKjDgcxiZ/58gLInlOzw=;
        b=Lb4dVx8Hwy8+3wyPqhFDXxyrTltxboCN7Hpglv6x5S9Pd/TmGSUiGoegMLLIharsA3
         fUVSh9/0+wRljHCm3ge5fv4eqL4gzSt/YJoX1KJ/f1VCPbtHm1nBUqbifOJ1Reim1ChL
         RvMcO6WioStkzI9JBKQc8H7Y1ZO794zKikc3PgplqBm4phCNASuaMxBaiZAWqYCWgu0p
         enbSNTSqlwwZsXgzkpB3fy8HA2kNFD7sDob+r3dMaESYQqkQEtFnVd8cCVFdKh3X8+hi
         qiZpv7+Wn70CDnL+0qWlQy4M1vWD2iTdej9Ov6BoEAjTxZBudnC7FLeljreqcT9Dvt0T
         UDtw==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Waiman Long <longman@redhat.com>

Hello, Linus.

cgroup changes for v4.21.

* Waiman's cgroup2 cpuset support has been finally merged closing one
  of the last remaining feature gaps.

* cgroup.procs could show non-leader threads when cgroup2 threaded
  mode was used in certain ways.  I forgot to push the fix during the
  last cycle.

Happy new year!

The following changes since commit f2ce1065e767fc7da106a5f5381d1e8f842dc6f4:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2018-11-19 09:24:04 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.21

for you to fetch changes up to 4d71c6f8771a6bccb844244f09831fa4624b22c1:

  Merge branch 'for-4.20-fixes' into for-4.21 (2018-12-27 18:05:30 -0800)

----------------------------------------------------------------
Tejun Heo (4):
      cpuset: Minor cgroup2 interface updates
      cgroup: Add .__DEBUG__. prefix to debug file names
      cgroup: fix CSS_TASK_ITER_PROCS
      Merge branch 'for-4.20-fixes' into for-4.21

Waiman Long (12):
      cpuset: Enable cpuset controller in default hierarchy
      cpuset: Define data structures to support scheduling partition
      cpuset: Simply allocation and freeing of cpumasks
      cpuset: Add new v2 cpuset.sched.partition flag
      cpuset: Add an error state to cpuset.sched.partition
      cpuset: Track cpusets that use parent's effective_cpus
      cpuset: Make CPU hotplug work with partition
      cpuset: Make generate_sched_domains() work with partition
      cpuset: Expose cpus.effective and mems.effective on cgroup v2 root
      cpuset: Use descriptive text when reading/writing cpuset.sched.partition
      cpuset: Add documentation about the new "cpuset.sched.partition" flag
      cpuset: Expose cpuset.cpus.subpartitions with cgroup_debug

Yangtao Li (1):
      cgroup: remove unnecessary unlikely()

YueHaibing (1):
      cpuset: Remove set but not used variable 'cs'

 Documentation/admin-guide/cgroup-v2.rst | 182 +++++-
 include/linux/cgroup-defs.h             |   1 +
 kernel/cgroup/cgroup-internal.h         |   2 +
 kernel/cgroup/cgroup.c                  |  58 +-
 kernel/cgroup/cpuset.c                  | 944 +++++++++++++++++++++++++++++---
 kernel/cgroup/debug.c                   |   4 +-
 6 files changed, 1095 insertions(+), 96 deletions(-)
